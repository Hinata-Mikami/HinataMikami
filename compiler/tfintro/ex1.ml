(* Examples of using our language: also as tests *)

(* We define the example in a way that is independent of
   the interpreter
*)

module type Lang = module type of Lang

module Ex1(L:Lang) = struct
  open L
  let res = add (add (int 4) (int 0)) 
                (add (int (-1)) (int (-1)))
end

let x = let module M = Ex1(Eval) in M.res
let _ = assert (x=2)

let x = let module M = Ex1(Pp) in M.res
let _ = assert (x = "((4 + 0) + (-1 + -1))")

module Ex1Neg(F:Lang) = Ex1(Neg.Neg(F))

let x = let module M = Ex1Neg(Eval) in M.res
let _ = assert (x= -2)

let x = let module M = Ex1Neg(Pp) in M.res
let _ = assert (x = "((-4 + 0) + (1 + 1))")

let x = let module M = Ex1Neg(Neg.Neg(Eval)) in M.res
let _ = assert (x=2)

let () = print_endline "All Done"
