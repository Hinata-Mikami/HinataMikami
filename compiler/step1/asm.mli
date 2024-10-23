(* Emitting Assembly Interface *)

type name = string

type instr                              (* abstract *)
val (@) : instr -> instr -> instr

val call : name -> instr

type register                           (* abstract *)
val rdi : register

type operand                            (* abstract *)
(* making operands *)
val imm : int -> operand                (* immediate value *)
val reg : register -> operand

val movq : operand -> operand -> instr

val make_function : name -> instr -> instr

val write_file : out_channel -> instr -> unit
