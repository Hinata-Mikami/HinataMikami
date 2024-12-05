(* Another implementation of lang.mli: Compiler *)
(* Extension with variable bindings *)

(* This is a STUB. Adjust/extend *)

let (>>) f g x = f x |> g

type vname = string


(* previous version of the compiler, to extend with variable bindings *)
(* Try to re-use C as much as possible *)
module C = Compiler_23
let type_cnv1 = C.type_cnv1
let type_cnv2 = C.type_cnv2

module CG = Code_gen

type atom = C.atom          (* CHANGE *)

(* Literals are answered immediately: don't depend on the context *)
let int  : int64 -> atom = C.int
let bool : bool -> atom  = C.bool

(* let var : vname -> atom = fun n -> 
  if n = "x" then C.varx else Util.fail "Not implemented" *)

type repr = C.repr          (* Change *)

let atomic : atom -> repr = C.atomic

let neg  : repr -> repr = C.neg
let succ : repr -> repr = C.succ
let pred : repr -> repr = C.pred
let not  : repr -> repr = C.not
let is_zero  : repr -> repr = C.is_zero

let add : repr -> atom -> repr = C.add

(* Introducing a local variable, and answering questions about it *)
(* let local : vname * repr -> repr -> repr = fun (name,exp) body ->
  Util.fail "Not implemented" *)
 
type obs = C.obs                        (* observation type *)

(* let observe : repr -> obs = C.observe *)


(* Ex19 *)
let ty_env : (vname * C.Ty.t) list ref = ref []

let local : vname * repr -> repr -> repr = fun (name, exp ) body ->
  ty_env := List.remove_assoc name !ty_env; body

let var : vname -> atom = fun n ->
  match n with
  | "x" -> C.varx 
  |  n' -> ty_env := (n', C.Ty.int) :: !ty_env; C.varx

let observe : repr -> obs = fun (ty, seq) ->
  if !ty_env = [] then
    Code_gen.observe @@
    match () with
    | _ when C.Ty.(eq ty int)  -> Code_gen.call1 "print_int" seq
    | _ when C.Ty.(eq ty bool) -> Code_gen.call1 "print_bool" seq
    | _      -> C.Ty.type_error "Unexpected type %s"
                  (C.Ty.to_string ty)
  else Util.fail "Unbound variable (observe)"

