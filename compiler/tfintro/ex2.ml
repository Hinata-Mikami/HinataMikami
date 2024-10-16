(* Examples of using our language: also as tests *)

(* We define the example in a way that is independent of
   the interpreter
*)

module type Lang2 = module type of Lang2

module Ex2(L:Lang2) = struct
  open L
  let res = sub (add (int 4) (int 0)) 
                (add (int (-1)) (int (-1)))
end

let x = let module M = Ex2(Eval2) in M.res
let _ = assert (x= 6)

let x = let module M = Ex2(Pp2) in M.res
let _ = assert (x = "((4 + 0) - (-1 + -1))")

module Ex2Neg(F:Lang2) = Ex2(Neg2.Neg2(F))

let x = let module M = Ex2Neg(Eval2) in M.res
let _ = assert (x= -6)

let x = let module M = Ex2Neg(Pp2) in M.res
let _ = assert (x = "((-4 + 0) - (1 + 1))")

let x = let module M = Ex2Neg(Neg2.Neg2(Eval2)) in M.res
let _ = assert (x= 6)

let () = print_endline "Ex2 was All Done "

;;