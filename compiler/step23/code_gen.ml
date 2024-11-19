(* Another implementation of lang.mli: Code-generator *)

(* Assumptions:
   %rdi always contains the value of the variable x

  There are no function calls in expressions (so, no need to save
  caller-save registers)
   ...

  Think of type repr as representing the program (as we shall see,
  it represents a block). Therefore, it must not be duplicated.
  It should be used linearly.
  OTH, atoms may be freely duplicated.
*)
(* Extension *)

include Code_gen_22

(* For code generation,
   an atom is something that can be converted to an operand of an
   instruction.
   This determines the representation
 *)
type atom = Asm.operand

let int  : int64 -> atom = Asm.imm
let bool : bool -> atom = fun x -> Asm.imm (if x then 1L else 0L)

let varx : atom = Asm.(reg rdi)

let atomic : atom -> repr = fun a ->
  Sq.one Asm.(movq a (reg rax))

let add : repr -> atom -> repr = fun ins a ->
  snoc Asm.(addq a (reg rax)) ins

