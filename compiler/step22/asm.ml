(* Emitting Assembly 
   Pretty-printing embedded x86-64 in the conventional assembly format
   (also accounting for MacOS/Linux differences)
   A different version could print into Intel format
*)

open Common

type instr = string

(* basic format of an assembly instruction
   tab, instname tab arg1, arg2,...
 *)
let ins : string list -> instr = function
  | [op]       -> "\t" ^ op
  | (op::args) -> "\t" ^ op ^ "\t" ^ String.concat ", " args
  | _          -> assert false


(* First, there are registers *)
(* XXX consider type register = int, for easy comparison *)

type register = string
let rax = "%rax"
let rbx = "%rbx"
let rcx = "%rcx"
let rdx = "%rdx"
let rsi = "%rsi"
let rdi = "%rdi"
let rbp = "%rbp"
let rsp = "%rsp"
let al  = "%al"
let r8  = "%r8"
let r9  = "%r9"
let r10 = "%r10"
let r11 = "%r11"
let r12 = "%r12"
let r13 = "%r13"
let r14 = "%r14"
let r15 = "%r15"

(* All registers are partitioned into 4 disjoint classes: rax,
   reg for argumemnts, callee owned and caller owned. 
   (rsp is very special and not counted in the above)
*)
(* rax, reg_arguments and callee_owned are not preserved across a call *)
let reg_arguments = [rdi; rsi; rdx; rcx; r8; r9]
let reg_callee_owned  = [r10; r11]
(* preserved across a call: *)
let reg_caller_owned  = [rbx; rbp; r12; r13; r14; r15]


type operand = string
(* making operands: addressing modes *)
let imm : int64 -> operand = fun x -> Printf.sprintf "$%Ld" x
let reg : register -> operand = Fun.id
(* there are more: to be uused later. ip-relative, stack-relative, mem *)

let ins1 : string -> operand -> instr = fun opcode op -> ins [opcode;op]
let ins2 : string -> operand -> operand -> instr = fun opcode op1 op2 -> 
  ins [opcode;op1;op2]

(* The instruction table *)
let movq = ins2 "movq"
let addq = ins2 "addq"
let subq = ins2 "subq"

let negq = ins1 "negq"
let incq = ins1 "incq"
let decq = ins1 "decq"

type symbol = string                    (* representation of a number or
                                           address: abstract *)

(* make a named symbol; by default it is global unless ~local:true
  is specified
  Global symbols on MacOS are all prefixed with underscore
  (maybe a local name could include the nesting level)
*)
let name ?(local=false) (s:string) : symbol =
  if local then s else
  if Config.is_macos then "_" ^ s else s


let call : symbol -> instr = fun name -> ins ["call";name]
let ret  : instr = ins ["ret"]

let label : symbol -> instr = fun name -> name ^ ":"

let start_function (name:symbol) : instr =
   (ins [".text"] ::
   ins [".globl";name] ::
   if not Config.is_macos then [ins [".type"; name; "@function"]] else [])
   |> String.concat "\n"


(* Write out *)
let print : out_channel -> instr -> unit = fun ch is ->
  output_string ch is; output_string ch "\n"

(* Extension *)
(* The instruction table *)
let xorq  = ins2 "xorq"
let test  = ins2 "test"
let movzb = ins2 "movzb"

let sete  = ins1 "sete"
let setz  = ins1 "setz"                  (* alias of sete *)

