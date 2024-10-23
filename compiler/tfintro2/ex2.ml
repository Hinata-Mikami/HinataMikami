(* Examples of using our extended language: also as tests *)

(* We define the example in a way that is independent of
   the interpreter
*)

(*
#load_rec "eval2.cmo";;
#load_rec "pp2.cmo";;
#load_rec "neg2.cmo";;
*)

(* the old example, with the old interpreter *)
module type Lang = module type of Lang

module Ex1(L:Lang) = struct
  open L
  let res = add (add (int 4) (int 0)) 
                (add (int (-1)) (int (-1)))
end

module type Lang2 = module type of Lang2

(* but using it with the new interpreter *)
let x = let module M = Ex1(Eval2) in M.res
let _ = assert (x=2)

let x = let module M = Ex1(Pp2) in M.res
let _ = assert (x = "((4 + 0) + (-1 + -1))")

module Ex1Neg(F:Lang2) = Ex1(Neg2.Neg(F))

let x = let module M = Ex1Neg(Eval2) in M.res
let _ = assert (x= -2)

let x = let module M = Ex1Neg(Pp2) in M.res
let _ = assert (x = "((-4 + 0) + (1 + 1))")

let x = let module M = Ex1Neg(Neg2.Neg(Eval2)) in M.res
let _ = assert (x=2)

(* Bigger example: also reusing the older example *)
module Ex2(L:Lang2) = struct
  open L
  module Old = Ex1(L)
  let res = add (twice Old.res) (int 10)
end

let x = let module M = Ex2(Eval2) in M.res
let _ = assert (x=14)

let x = let module M = Ex2(Pp2) in M.res
let _ = assert (x = "(2*((4 + 0) + (-1 + -1)) + 10)")

module Ex2Neg(F:Lang2) = Ex2(Neg2.Neg(F))

let x = let module M = Ex2Neg(Eval2) in M.res
let _ = assert (x= -14)

let x = let module M = Ex2Neg(Pp2) in M.res
let _ = assert (x = "(2*((-4 + 0) + (1 + 1)) + -10)")

let x = let module M = Ex2Neg(Neg2.Neg(Eval2)) in M.res
let _ = assert (x=14)

let () = print_endline "All Done"
