(* Emitting Assembly *)

type name = string

(* Instructions. For now, just strings, newline terminated *)
type instr = string
let (@) : instr -> instr -> instr = (^)

(* basic format of an assembly instruction
   tab, instname tab arg1, arg2,...
 *)
let ins : string list -> string = function
  | [op]       -> "\t" ^ op ^ "\n"
  | (op::args) -> "\t" ^ op ^ "\t" ^ String.concat ", " args ^ "\n"
  | _          -> assert false

(* The format of global names is peculiar for MacOS *)
let adjust_name : name -> name = fun name ->
  if Config.is_macos then "_" ^ name else name

let call : name -> instr = fun name -> ins ["call";adjust_name name]

type register = string
let rdi : register = "%rdi"

type operand = string
(* making operands *)

(* Fixed in Ex2 : int -> int64, %d -> %Ld*)
let imm : int64 -> operand = fun x -> Printf.sprintf "$%Ld" x
let reg : register -> operand = Fun.id

let movq : operand -> operand -> instr = fun op1 op2 -> ins ["movq";op1;op2]

let label : name -> instr = fun name -> name ^ ":\n"

let make_function : name -> instr -> instr = fun name body ->
  let name = adjust_name name in
  [
   ins [".text"];
   ins [".globl";name];
   if not Config.is_macos then ins [".type"; name; "@function"] else "";
   label name;
   ins ["subq"; "$8"; "%rsp"];
   body;
   ins ["addq"; "$8"; "%rsp"];
   ins ["ret"]
 ] |> Util.reduce (@)

let write_file : out_channel -> instr -> unit = output_string

