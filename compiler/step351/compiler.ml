(* An extension to the compiler
*)

include Compiler_34

let string : string -> repr = fun n -> Qna.ans (Ty.string, CG.string n)

