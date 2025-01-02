(* We need more assembly language facilities *)

include module type of Asm_32

val rip_offset : symbol -> operand
(* essentially, the absolute addressing *)
val imm_symbol : symbol -> operand

val new_label : ?prefix:string -> unit -> symbol 

val set_label : symbol -> instr

val leaq  : operand -> register -> instr

val segment_data : unit -> instr
val segment_text : unit -> instr
val align : int -> instr
val data_uint32 : int -> instr
val data_uint8  : int -> instr

