(* We need more assembly language facilities *)

include Asm_impl_22

(* Stack-relative addressing mode *)
let stack_rel : int -> operand = fun n ->
  if n = 0 then "(%rsp)" else Printf.sprintf "%d(%%rsp)" n



let cmpq = ins2 "cmpq" 

let setne = ins1 "setne"
let setl = ins1 "setl"  
let setle = ins1 "setle" 
let setg = ins1 "setg"  
let setge = ins1 "setge" 

let imulq = ins2 "imulq"

let cqto = ins ["cqto"]    
let idivq = ins1 "idivq"   
