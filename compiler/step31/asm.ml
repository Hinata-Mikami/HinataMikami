(* We need more assembly language facilities *)

include Asm_impl_22

(* Stack-relative addressing mode *)
let stack_rel : int -> operand = fun n ->
  if n = 0 then "(%rsp)" else Printf.sprintf "%d(%%rsp)" n

