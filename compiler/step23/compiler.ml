(* Another implementation of lang.mli: Compiler *)
(* Type checking, etc. *)
(* Extension from compiler_22.ml *)

module Ty = Types

type atom =                             (* atom representation type *)
    Ty.t * Code_gen.atom

let int  : int64 -> atom = fun x -> 
  (Ty.int, Code_gen.int x) 
let bool : bool -> atom = fun x ->
  (Ty.bool, Code_gen.bool x) 

let varx : atom = (Ty.int, Code_gen.varx)

type repr =                             (* representation type *)
    Ty.t * Code_gen.repr

let atomic : atom -> repr = fun (ty,c) -> (ty,Code_gen.atomic c)

let type_cnv1 (intyp:Ty.t) (outtyp:Ty.t) (cgen: 'a -> 'b) : 
    (Ty.t * 'a) -> (Ty.t * 'b) =
    fun (ty,c) -> Ty.check_type intyp ty; (outtyp, cgen c)

let neg  = type_cnv1 Ty.int Ty.int Code_gen.neg
let succ = type_cnv1 Ty.int Ty.int Code_gen.succ
let pred = type_cnv1 Ty.int Ty.int Code_gen.pred
let not  = type_cnv1 Ty.bool Ty.bool Code_gen.not
let is_zero  = type_cnv1 Ty.int Ty.bool Code_gen.is_zero

let type_cnv2 (intyp1:Ty.t) (intyp2:Ty.t) (outtyp:Ty.t) (cgen: 'a->'b->'c) : 
    (Ty.t * 'a) -> (Ty.t * 'b) -> (Ty.t * 'c) =
    fun (ty1,c1) (ty2,c2) -> 
      Ty.check_type intyp1 ty1;
      Ty.check_type intyp2 ty2;
      (outtyp, cgen c1 c2)

let add = type_cnv2 Ty.int Ty.int Ty.int Code_gen.add

type obs = out_channel -> unit                (* observation type *)

let observe : repr -> obs = fun (ty, seq) ->
  Code_gen.observe @@
  match () with
  | _ when Ty.(eq ty int)  -> Code_gen.call1 "print_int" seq
  | _ when Ty.(eq ty bool) -> Code_gen.call1 "print_bool" seq
  | _      -> Ty.type_error "unsupported type %s of the whole program"
                (Ty.to_string ty)
