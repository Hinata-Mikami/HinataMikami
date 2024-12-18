(* Extended code generator *)

include Code_gen_32
let (>>) f g = fun x -> f x |> g

let empty : repr = Sq.empty

type fname = Asm.symbol

let call0 : fname -> repr = Asm.call >> Sq.one

let call : fname -> repr -> atom list -> repr = fun nm arg1 atoms ->
  let open Sq in
  let rec loop seq atoms regs = match (atoms,regs) with
  | ([],_) -> seq @ call0 nm
  | (_,[]) -> Util.fail "The function is called with %d arguments: too many"
        (* nm *) (1 + List.length atoms)
  | (a::atoms, r::regs) ->
      loop (snoc Asm.(movq a (reg r)) seq) atoms regs
  in loop 
  (snoc Asm.(movq (reg rax) (reg (List.hd reg_arguments))) arg1)
  atoms (List.tl Asm.reg_arguments)
