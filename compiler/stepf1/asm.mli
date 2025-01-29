(* We need more assembly language facilities:
   make_function should also make local functions
 *)

include module type of Asm_3

val start_function : ?local_fun:bool -> symbol -> instr

val pseudo_operand : int -> operand
val substitute_pseudo_op : (int*operand) list -> instr -> instr
