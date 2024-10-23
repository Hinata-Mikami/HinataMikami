(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load_rec "expect.cmo"
*)

open Expect

let tigerc = Filename.concat "Build" "tigerc"
let execf = Filename.concat "Build" "a.out"

let _ =
  expect_fail @@ test_it "" (fun name -> [tigerc])

let cmd fname = [tigerc; fname]

let _ =
  expect "" @@ test_it "0" cmd;
  expect "0\nDone" @@ test_command [execf]

let _ =
  expect "" @@ test_it "42" cmd;
  expect "42\nDone" @@ test_command [execf]

let _ =
  expect "" @@ test_it "-42" cmd;
  expect "-42\nDone" @@ test_command [execf]

let _ =
  expect_fail @@ test_it "xxx" cmd


let _ =
  expect "" @@ test_it "4611686018427387903" cmd;
  expect "4611686018427387903\nDone" @@ test_command [execf]

let _ =
  expect "" @@ test_it "4611686018427387903" cmd;
  expect "4611686018427387903\nDone" @@ test_command [execf]

(* Ex2 *)
(* Exercise 2*)
(* 2 trials below raised error caused by "int_of_float"*)
(* Exercise 3*)
(* asm.ml, asm.mli, and compiler.ml were fixed 
   so that int64 numbers can be accepted.*)
let _ =
  expect "" @@ test_it "9223372036854775807" cmd;
  expect "9223372036854775807\nDone" @@ test_command [execf] 

let _ =
  expect "" @@ test_it "-9223372036854775808" cmd;
  expect "-9223372036854775808\nDone" @@ test_command [execf]


(* Both trials below still fail. *)
let _ =
  expect_fail @@ test_it "9223372036854775808" cmd

let _ =
  expect_fail @@ test_it "-9223372036854775809" cmd


(* This trial should raise an error but passed.*)
(* 0.1 is unexpected input (not integer)*)
let _ =
  expect "" @@ test_it "0.1" cmd;
  expect "0\nDone" @@ test_command [execf]



let () = print_endline "All Done"

;;


