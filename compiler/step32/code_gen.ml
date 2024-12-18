(* Code generation, extension of code_gen_31.ml 
   with many binary operators
*)

include Code_gen_31

let sub : repr -> atom -> repr = fun ins a ->
  snoc Asm.(subq a (reg rax)) ins

let mul : repr -> atom -> repr = fun ins a ->
  snoc Asm.(imulq a (reg rax)) ins

(* Remember, 0 represents false and 1 represents true *)
(* so bit operations make sense *)

let bor : repr -> atom -> repr = fun ins a ->
  snoc Asm.(orq a (reg rax)) ins

let band : repr -> atom -> repr = fun ins a ->
  snoc Asm.(andq a (reg rax)) ins

(* Booleans are so happened to be appropriately ordered *)

let comparison (f: Asm.operand -> Asm.instr) : 
  repr -> atom -> repr = fun ins a ->
  snocs Asm.([cmpq a (reg rax); f (reg al); movzb (reg al) (reg rax)]) ins

let eq  : repr -> atom -> repr = comparison Asm.sete
let neq : repr -> atom -> repr = comparison Asm.setne
let lt  : repr -> atom -> repr = comparison Asm.setl
let leq : repr -> atom -> repr = comparison Asm.setle
let gt  : repr -> atom -> repr = comparison Asm.setg
let geq : repr -> atom -> repr = comparison Asm.setge
