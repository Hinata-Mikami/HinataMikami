(* Pretty-printer showing scope: The environment semantics *)

type vname = string
let (>>) f g = fun x -> f x |> g

(* The traditional PP, which doesn't deal with scope *)
module P = Pp_ast_ns

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
type atom = env -> P.atom

type repr = env -> P.repr

(* Int and bool literals don't depend on the context *)
let int  : Int64.t -> atom = fun x -> fun _env -> P.int x
let bool : bool -> atom    = fun x -> fun _env -> P.bool x

(* But the following certainly does depend on the context *)
let var : vname -> atom = fun n -> fun env ->
  try List.assoc n env
  with Not_found -> Util.fail "Can't find var %s" n

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

