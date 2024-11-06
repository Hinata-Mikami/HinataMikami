(* Emitting Assembly Interface *)


type instr                              (* abstract *)
val empty : instr                       (* instr is hence a monoid *)
val (@) : instr -> instr -> instr


type register                           (* abstract *)
val rax : register
val rbx : register
val rcx : register
val rdx : register
val rsi : register
val rdi : register
val rbp : register
val rsp : register
val al  : register
val r8  : register
val r9  : register
val r10 : register
val r11 : register
val r12 : register
val r13 : register
val r14 : register
val r15 : register
(* There is also %rip, but it is special. It is used for
   relative addressing. But we'll have a special form for
   relative addressing.
*)

(* All registers are partitioned into 4 disjoint classes: rax,
   reg for argumemnts, callee owned and caller owned. 
   (rsp is very special and not counted in the above)
*)
(* rax, reg_arguments and callee_owned are not preserved across a call
   OTH, reg_caller_owned are preserved across a call. But if we use them,
   we have to save them at entry to the function and restore at exit
*)
val reg_arguments    : register list
val reg_callee_owned : register list
val reg_caller_owned : register list

type operand                            (* abstract *)
(* making operands: addressing modes *)
val imm : int64 -> operand            (* immediate value *)
val reg : register -> operand
(* there are more: to be uused later. ip-relative, stack-relative, mem *)

val negq : operand -> instr
val incq : operand -> instr
val decq : operand -> instr

val movq : operand -> operand -> instr
val addq : operand -> operand -> instr
val subq : operand -> operand -> instr

type symbol                             (* representation of a number or
                                           address: abstract *)

(* make a named symbol; by default it is global unless ~local:true
  is specified
*)
val name : ?local:bool -> string -> symbol

val call : symbol -> instr

val make_function : ?locals:int -> symbol -> instr -> instr

val write_file : out_channel -> instr -> unit

