(* We need more assembly language facilities *)

include module type of Asm_31

val setne : operand -> instr
val setl  : operand -> instr
val setle : operand -> instr
val setg  : operand -> instr
val setge : operand -> instr

val imulq  : operand -> operand -> instr
val orq    : operand -> operand -> instr
val andq   : operand -> operand -> instr
val cmpq   : operand -> operand -> instr
