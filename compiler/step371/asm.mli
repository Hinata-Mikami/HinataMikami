(* We need more assembly language facilities *)

include module type of Asm_35

(* jumps *)
val jmp : symbol -> instr

val je   : symbol -> instr
val jne  : symbol -> instr
(* signed *)
val jg   : symbol -> instr
val jge  : symbol -> instr
val jl   : symbol -> instr
val jle  : symbol -> instr

