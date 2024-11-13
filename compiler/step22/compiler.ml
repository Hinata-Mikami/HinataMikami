(* Another implementation of lang.mli: Compiler *)
(* Type checking, etc. *)

type trepr = Int | Bool | String
let string_of_trepr = function
  | Int    -> "int"
  | Bool   -> "bool"
  | String -> "string"

exception Type_error of string

let check_type (expected:trepr) (given:trepr) : unit =
  if expected <> given then
    Printf.kprintf (fun x -> raise (Type_error x))
      "Expected type %s but found %s" 
      (string_of_trepr expected) (string_of_trepr given)

(* This compiler is a product (pair) of two interpreters
   of Lang, interpreting a Lang expression in parallel, so to speak.
   One interpreter evaluates a Lang expression as trepr.
   The other, as Code_gen.repr, that is, instruction sequence.
 *)
type repr =                             (* representation type *)
    trepr * Code_gen.repr

let int  : Int64.t -> repr = fun x -> 
  (Int, Code_gen.int x) 
let bool : bool -> repr = fun x ->
  (Bool, Code_gen.bool x) 


let varx : repr = (Int, Code_gen.varx)

(* Boring
let not  : repr -> repr = fun (ty, c) ->
  check_type Bool ty;
  (ty,Code_gen.not c)
*)

let type_cnv1 (intyp: trepr) (outtyp:trepr) 
    (cgen: Code_gen.repr -> Code_gen.repr) : repr -> repr =
    fun (ty,c) -> check_type intyp ty; (outtyp, cgen c)

let neg  = type_cnv1 Int Int Code_gen.neg
let succ = type_cnv1 Int Int Code_gen.succ
let pred = type_cnv1 Int Int Code_gen.pred
let not      = type_cnv1 Bool Bool Code_gen.not
let is_zero  = type_cnv1 Int Bool Code_gen.is_zero

type obs = out_channel -> unit                (* observation type *)

let observe : repr -> obs = fun (ty, seq) ->
  Code_gen.observe @@
  match ty with
  | Int    -> Code_gen.call1 "print_int" seq
  | Bool   -> Code_gen.call1 "print_bool" seq
  | _      -> raise (Type_error "unsupported type of the whole program")
