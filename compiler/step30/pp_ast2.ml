(* Pretty-printer showing scope *)

type vname = string
let (>>) f g = fun x -> f x |> g

(* Pretty printer parameterized by a sequence *)

(*
#directory "../step21/Build"
#load "sq.cmo"
*)

module Pp(Sq: module type of Sq) = struct

  open Sq
  type repr = string Sq.t

  let int  : Int64.t -> repr = Int64.to_string >> one

  let varx : repr = "x" |> one

  let paren (x:repr) : repr = one "(" @ x @ one ")"
  let prepend (pref:string) (s:repr) : repr = one pref @ s

  let neg  : repr -> repr = prepend "neg "  >> paren
  let succ : repr -> repr = prepend "succ " >> paren
  let pred : repr -> repr = prepend "pred " >> paren

  type obs = string                                (* observation type *)
  let observe : repr -> obs = fun seq ->
    let b = Buffer.create 17 in
    iter (Buffer.add_string b) seq;
    Buffer.contents b

  let bool : bool -> repr   = string_of_bool >> one

  let not      : repr -> repr = prepend "not "      >> paren
  let is_zero  : repr -> repr = prepend "is_zero "  >> paren

  type atom = string                               (* representation type *)

  let atomic : atom -> repr = one

  let add : repr -> atom -> repr = fun seq a -> 
    seq @ one (" " ^ a) |> prepend "add " |> paren

  type vname = string
  let var : vname -> atom = Fun.id

  let local : vname * repr -> repr -> repr = fun (name,exp) body ->
  one "[" @ one name @ one "," @ exp @ one "]" @ one " " @ body |> paren
end


(* The traditional PP, which doesn't deal with scope *)
module P0 = Pp(Sq)

(* Annotated sequence *)
module SqAnn = struct
  type 'a hole = B of 'a | V of vname
  type 'a t = 'a hole Sq.t
  let empty = Sq.empty
  let one : 'a -> 'a t = fun x -> Sq.one (B x)
  let (@) = Sq.(@)
  (* skipping the hole *)
  let iter : ('a -> unit) -> 'a t -> unit = fun f ->
    Sq.iter (function B x -> f x | V _ -> ())
end

(* The same un-annotated *)
module P = Pp(SqAnn)

include P

let var : vname -> atom = Fun.id

(* To show scope, the meaning of an expression, such as
   var "x" depends on the context
   What is context? Strictly speaking, this is an expression with a hole.
   But for our purposes, we only care about bindings and their
   nesting, so the simple list suffices.
 *)

(* The vname is the name as appears in a program;
   P.atom is its `meaning': the unique name.
   The head of the list describes the innermost binding
   (the closest to the expression in question)
 *)
type env = (vname * P.atom) list

(* What this file does is adding env:
   relativitizing P with respect to the context
 *)

type astring =
  | B of P.repr
  | V of vname

let inj : string -> astring = fun x -> B x

type atom = astring

(* A sequence like Sq would be better *)
type repr = astring list

(* Int and bool literals don't depend on the context *)
let int  : int64 -> atom = P.int  >> inj
let bool : bool -> atom  = P.bool >> inj

let var : vname -> atom = fun n -> V n


(* But the following certainly does depend on the context *)
let var : vname -> atom = fun n -> fun env ->
  try List.assoc n env
  with Not_found -> Printf.ksprintf failwith "Can't find var %s" n

let local : vname * repr  -> repr -> repr = 
  fun (n,exp) body -> fun env ->
    let e = exp env in                  (* old context *)
    let unique_name = Util.gensym n in
    let new_env = (n,P.var unique_name) :: env in
    let b = body new_env in
    P.local (unique_name,e) b

let atomic : atom -> repr = fun a -> fun env -> P.atomic (a env)
let neg  : repr -> repr = fun e -> fun env -> P.neg (e env)

(* This is becoming repetetive *)
let lift1 : ('a -> 'b) -> ((env -> 'a) -> (env -> 'b)) = 
  fun f e -> fun env -> e env |> f

let succ : repr -> repr = lift1 P.succ
let pred : repr -> repr = lift1 P.pred
let not  : repr -> repr = lift1 P.not
let is_zero : repr -> repr = lift1 P.is_zero

let lift2 : ('a -> 'b -> 'c) -> ((env -> 'a) -> (env -> 'b) -> (env -> 'c)) = 
  fun f e1 e2 -> fun env -> f (e1 env) (e2 env)

let add : repr -> atom -> repr = lift2 P.add

let init_env = [("x",P.var "x")]        (* Global x *)

type obs = P.obs                                (* observation type *)
let observe : repr -> obs = fun e -> e init_env |> P.observe

