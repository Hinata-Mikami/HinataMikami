(* testing script, particular cases that would work correctly later *)

(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load_rec "expect.cmo"
*)

open Expect

let tigerc = Filename.concat "Build" "tigerc"
let execf = Filename.concat "Build" "a.out"

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

(* should fail for now: no access to the parent env *)
let _ =
  expect_fail
 @@ test_it {q|
   let function foo1(x:int):int =
       let function foo2(y:int):int = x + 1 in
       foo2(x+1) * foo2(x+2) end
   in
   print_int(foo1(10))
   end|q}
    cmd_gen

let () = print_endline "All Done"

;;
