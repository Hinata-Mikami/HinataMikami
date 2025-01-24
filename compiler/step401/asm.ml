(* We need more assembly language facilities:
   start_function should also make local functions
*)

include Asm_impl_3

let start_function ?(local_fun=false) (name:symbol) : instr =
   ins [".text"] ^ "\n" ^
   (if local_fun then "" else ins [".globl";name] ^ "\n") ^
   if not Config.is_macos then ins [".type"; name; "@function"] else ""


(* Dealing with pseudo-operands: operands that have to be substituted *)

let pseudo_operand : int -> operand = fun n -> "|" ^ string_of_int n ^ "|"

(* Substitute pseudo-operands, with the index i, with operands,
   according to the substitution list
   An instruction may have only one pseudo-operand
*)

let substitute_pseudo_op : (int*operand) list -> instr -> instr =
  fun env i ->
    if String.contains i '|' then
      match String.split_on_char '|' i with
      | [s1;ns;s2] -> 
          let n = int_of_string ns in begin
            match List.assoc_opt n env with
            | Some op -> s1 ^ op ^ s2
            | None    -> i
          end
      | _ -> Util.fail "bad instruction with a pseudo-operand: %s" i
    else i

          
