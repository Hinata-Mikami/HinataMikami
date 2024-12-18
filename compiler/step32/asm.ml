(* We need more assembly language facilities *)

include Asm_impl_31

let imulq = ins2 "imulq"

let orq  = ins2 "orq"
let andq = ins2 "andq"

let cmpq  = ins2 "cmpq"

let setne = ins1 "setne"
let setl  = ins1 "setl"
let setle = ins1 "setle"
let setg  = ins1 "setg"
let setge = ins1 "setge"
