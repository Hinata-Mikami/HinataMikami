(* We need more assembly language facilities *)

include Asm_impl_35

(* jumps *)
let jmp : symbol -> instr = fun s -> ins ["jmp";s]

let je  : symbol -> instr = fun s -> ins ["je";s]
let jne : symbol -> instr = fun s -> ins ["jne";s]

(* signed *)
let jg   : symbol -> instr = fun s -> ins ["jg";s]
let jge  : symbol -> instr = fun s -> ins ["jge";s]
let jl   : symbol -> instr = fun s -> ins ["jl";s]
let jle  : symbol -> instr = fun s -> ins ["jle";s]
