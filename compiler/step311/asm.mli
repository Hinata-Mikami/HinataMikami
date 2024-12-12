(* We need more assembly language facilities *)

include module type of Asm_22

(* Another addressing mode: stack-relative *)
val stack_rel : int -> operand

val cmpq : operand -> operand -> instr

val setne : operand -> instr
val setl : operand -> instr
val setle : operand -> instr
val setg : operand -> instr
val setge : operand -> instr

val imulq : operand -> operand -> instr

val cqto : instr
val idivq : operand -> instr