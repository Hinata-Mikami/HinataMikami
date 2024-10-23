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

let () = print_endline "All Done"

;;


