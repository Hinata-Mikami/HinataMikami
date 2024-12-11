(* We need more assembly language facilities *)

include module type of Asm_22

(* Another addressing mode: stack-relative *)
val stack_rel : int -> operand
