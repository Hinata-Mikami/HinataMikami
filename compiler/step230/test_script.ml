(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load "expect.cmo"
*)

open Expect

let tigerc = Filename.concat "Build" "tigerc"

(* Test parsing *)
let cmd_parse fname = [tigerc; "--dump-parse"; fname]

let _ =
  expect_fail @@ test_it "nottrue" cmd_parse

let _ =
  expect "(neg true)" @@ test_it "-true" cmd_parse

let _ =
  expect "true" @@ test_it "true" cmd_parse

let _ =
  expect "(not false)" @@ test_it "not false" cmd_parse

let _ =
  expect_fail @@ test_it "not is_zero" cmd_parse

let _ =
  expect "(not (is_zero x))" @@ test_it "not is_zero x" cmd_parse


(* Ex 8, 9 *)
let _ =
  expect "(neg 1)" @@ test_it "-1" cmd_parse

let _ =
  expect "23" @@ test_it "(23)" cmd_parse

let _ =
  expect "(succ true)" @@ test_it "(succ true)" cmd_parse

let _ =
  expect "(pred (succ 5))" @@ test_it "pred (succ 5)" cmd_parse

let _ =
  expect "(not (is_zero (succ 1)))" @@ test_it "not (is_zero (succ 1))" cmd_parse  

let _ =
  expect "true" @@ test_it "(((true)))" cmd_parse

let _ =
  expect "(1 + 1)" @@ test_it "1 + 1" cmd_parse

let _ =
  expect "((1 + 1) + 1)" @@ test_it "1 + 1 + 1" cmd_parse

let _ =
  expect "((neg 1) + 1)" @@ test_it "-1 + 1" cmd_parse

let _ =
  expect "(true + false)" @@ test_it "true + false" cmd_parse

let _ =
  expect "(((not true) + false) + 4)" @@ test_it "((not true) + false) + 4" cmd_parse

let _ =
  expect_fail @@ test_it "" cmd_parse

  let _ =
  expect_fail @@ test_it "+ 1" cmd_parse

let _ =
  expect_fail @@ test_it "( -1 + 1" cmd_parse

let _ =
  expect_fail @@ test_it "1 + (succ 1)" cmd_parse  

let _ =
  expect_fail @@ test_it "+ pred 7" cmd_parse  




let () = print_endline "All Done"

;;


