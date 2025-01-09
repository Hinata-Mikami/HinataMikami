(* An extension to the compiler
*)

include Compiler_34

let string : string -> repr = fun n -> Qna.ans (Ty.string, CG.string n)


let type_cnv_comp2 
    (cgen1: 'a->'b->'c) (name : vname): (Ty.t * 'a) -> (Ty.t * 'b) -> (Ty.t * 'c) =
    fun (ty1,c1) (ty2,c2) -> 
      Ty.check_type ty1 ty2;
      if ty1 == Ty.string
      then (Ty.bool, CG.call (Asm.name name) c1 [c2])
      else (Ty.bool, cgen1 c1 c2)

let eq  : repr -> atom -> repr = type_cnv_comp2 CG.eq "eq_str" |> lift2
let neq : repr -> atom -> repr = type_cnv_comp2 CG.neq "neq_str" |> lift2
let lt  : repr -> atom -> repr = type_cnv_comp2 CG.lt "lt_str" |> lift2
let leq : repr -> atom -> repr = type_cnv_comp2 CG.leq "leq_str"|> lift2
let gt  : repr -> atom -> repr = type_cnv_comp2 CG.gt "gt_str" |> lift2
let geq : repr -> atom -> repr = type_cnv_comp2 CG.geq "geq_str"|> lift2
