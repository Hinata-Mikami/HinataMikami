(* We need more assembly language facilities *)

include Asm_impl_32

let leaq op r = ins ["leaq";op;reg r]

let rip_offset : symbol -> operand = Printf.sprintf "%s(%%rip)"
let imm_symbol : symbol -> operand = Printf.sprintf "$%s"


let new_label ?(prefix="") () : symbol = 
  Util.gensym (".L"^prefix) |> name ~local:true

let set_label = label

let segment_data () : instr = ins [".data"]
let segment_text () : instr = ins [".text"]

let align (n:int) : instr = 
  assert (List.mem n [4;8;16;32;0]);
  ins [".balign";string_of_int n]

let data_uint32 (n:int) : instr = 
  assert (n >= 0 && n <= 0xffffffff);
  ins [".4byte"; string_of_int n]

let data_uint8 (n:int) : instr =
  assert (n >= 0 && n <= 255);
  ins [".byte"; string_of_int n]
