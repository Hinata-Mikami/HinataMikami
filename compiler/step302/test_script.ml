(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load_rec "expect.cmo"
*)

open Expect

let tigerc = Filename.concat "Build" "tigerc"
let execf = Filename.concat "Build" "a.out"

(* Test parsing *)
let cmd_parse fname = [tigerc; "--dump-parse"; fname]

let _ = 
  expect_fail @@ test_it 
 {q|
  let val y := 1+x
      val z :=4+y in 10+y+z
 |q}
 cmd_parse

let _ = 
  expect "(add (let [y,1] y) 2)" @@ test_it 
 {q|
  let val y := 1 in y end + 2
 |q}
  cmd_parse

(* Add more *)


(* Testing successful compilation *)
(* We are *not* testing running of the compiled code *)

let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ = expect "" @@ test_it "1 + x + 3" cmd_run

let _ = expect "" @@ test_it "let val y := 1+x in y end" cmd_run

let _ = 
  expect_fail @@ test_it "y" cmd_run

(* Add more *)  
(* Ex 18 *)
let _ = expect "" @@ test_it "succ 1" cmd_run

let _ = expect "" @@ test_it "pred x" cmd_run

let _ = expect "" @@ test_it "not (is_zero 1)" cmd_run

let _ = expect "" @@ test_it "not (is_zero (let val y := 1 in y end))" cmd_run

let _ = expect_fail @@ test_it "pred true" cmd_run

let _ = expect_fail @@ test_it "not (succ x)" cmd_run

let _ = expect_fail @@ test_it "let val x := 1 in (not x) end" cmd_run




let () = print_endline "All Done"

;;


