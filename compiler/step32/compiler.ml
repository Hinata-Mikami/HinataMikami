(* Another implementation of lang.mli: Compiler *)
(* Extension with many binary operations *)

(* TODO: incorporate lift etc into type_cnv! *)

include Compiler_31

module Ty = Types
let lift1 = Qna.lift1
let lift2 = Qna.lift2
let type_cnv2 = C.type_cnv2

let sub : repr -> atom -> repr = type_cnv2 Ty.int Ty.int Ty.int CG.sub |> lift2
let mul : repr -> atom -> repr = type_cnv2 Ty.int Ty.int Ty.int CG.mul |> lift2


let bor  : repr -> atom -> repr = 
  type_cnv2 Ty.bool Ty.bool Ty.bool CG.bor  |> lift2
let band : repr -> atom -> repr = 
  type_cnv2 Ty.bool Ty.bool Ty.bool CG.band |> lift2

(* Comparison operators are polymorphic: they take values of the same type *)
(* The functionality is also polymorphic, for the time being ...*)

let type_cnv_comp 
    (cgen: 'a->'b->'c) : (Ty.t * 'a) -> (Ty.t * 'b) -> (Ty.t * 'c) =
    fun (ty1,c1) (ty2,c2) -> 
      Ty.check_type ty1 ty2;
      (Ty.bool, cgen c1 c2)

let eq  : repr -> atom -> repr = type_cnv_comp CG.eq   |> lift2
let neq : repr -> atom -> repr = type_cnv_comp CG.neq  |> lift2
let lt  : repr -> atom -> repr = type_cnv_comp CG.lt   |> lift2
let leq : repr -> atom -> repr = type_cnv_comp CG.leq  |> lift2
let gt  : repr -> atom -> repr = type_cnv_comp CG.gt   |> lift2
let geq : repr -> atom -> repr = type_cnv_comp CG.geq  |> lift2
