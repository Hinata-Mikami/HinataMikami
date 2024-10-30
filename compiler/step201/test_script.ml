(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load "expect.cmo"
*)

open Expect
let tigerc = Filename.concat "Build" "tigerc"


(* Test parsing *)
let cmd_parse fname = [tigerc; fname]

(* earlier tests *)
let _ =
  expect "0" @@ test_it "0" cmd_parse

let _ =
  expect "42" @@ test_it "42" cmd_parse

let _ =
  expect "(neg 42)" @@ test_it "-42" cmd_parse

let _ =
  expect_fail @@ test_it "xxx" cmd_parse

let _ =
  expect "4611686018427387903" @@ test_it "4611686018427387903" cmd_parse

let max = Int64.(max_int |> to_string)
(*
  val max : string = "9223372036854775807"
*)

(* Now it works! *)
let _ =
  expect max @@ test_it max cmd_parse

let _ =
  expect_fail @@ test_it "9223372036854775808" cmd_parse

let _ =
  expect_fail @@ test_it "123 4" cmd_parse

let _ =
  expect_fail @@ test_it "123xxx" cmd_parse

(* Further tests *)
let _ = 
  expect "(neg 245)" @@ test_it "  -245  " cmd_parse

let _ = 
  expect "124" @@ test_it "000124" cmd_parse

let _ = 
  expect_fail @@ test_it "0x16" cmd_parse

let _ = 
  expect_fail @@ test_it "1_2_3" cmd_parse

(* Test for x and unary operations *)

let _ =
  expect "x" @@ test_it "x" cmd_parse

let _ =
  expect "x" @@ test_it " x" cmd_parse

let _ =
  expect "(neg x)" @@ test_it "-x" cmd_parse

let _ =
  expect "(neg x)" @@ test_it "- x" cmd_parse

let _ =
  expect_fail @@ test_it "succpred-x" cmd_parse

let _ =
  expect "(succ (neg x))" @@ test_it "succ - x" cmd_parse

let _ =
  expect "(succ (pred (neg x)))" @@ test_it "succ pred - x " cmd_parse

(*Extended Tests*)
(* Ex 4 *)
let _ =
  expect "(pred 0)" @@ test_it "pred 0" cmd_parse

let _ =
  expect "(succ 1)" @@ test_it "succ 1" cmd_parse

let _ =
  expect "(pred (succ 1))" @@ test_it "pred succ 1" cmd_parse

let _ =
  expect "(succ (neg 1))" @@ test_it "succ - 1" cmd_parse

let _ =
  expect "(pred (succ (neg 1)))" @@ test_it "pred succ - 1 " cmd_parse

let _ =
  expect_fail @@ test_it "neg y" cmd_parse 

let _ =
  expect_fail @@ test_it "neg 0_1" cmd_parse 

let _ =
  expect_fail @@ test_it "neg 2.5" cmd_parse 

let _ =
  expect_fail @@ test_it "succ - y" cmd_parse

let _ =
  expect_fail @@ test_it "succ 0_1" cmd_parse

let _ =
  expect_fail @@ test_it "succ 2.5" cmd_parse

let _ =
  expect_fail @@ test_it "pred - y" cmd_parse

let _ =
  expect_fail @@ test_it "pred 0_1" cmd_parse

let _ =
  expect_fail @@ test_it "pred 2.5" cmd_parse

let _ =
  expect_fail @@ test_it "succpred 0" cmd_parse

let _ =
  expect_fail @@ test_it "0succpred" cmd_parse

let _ =
  expect_fail @@ test_it "1 succ" cmd_parse

let _ =
  expect_fail @@ test_it "2 - pred" cmd_parse
let _ =
  expect_fail @@  test_it " " cmd_parse

let _ =
  expect_fail @@  test_it "" cmd_parse

(* Ex 5 *)
let _ =
  expect "true" @@ test_it "true" cmd_parse

let _ =
  expect "false" @@ test_it "false" cmd_parse

(*this seems strange but should be accepted by Unary Language*)
let _ =
  expect "(neg true)" @@ test_it "- true" cmd_parse

let _ =
  expect "(not true)" @@ test_it "not true" cmd_parse

let _ =
  expect "(not (not false))" @@ test_it "not not false" cmd_parse

let _ =
  expect "(iszero 7)" @@ test_it "iszero 7" cmd_parse

let _ =
  expect "(not (iszero 7))" @@ test_it "not iszero 7" cmd_parse

let _ =
  expect "(not (iszero x))" @@ test_it "not iszero x" cmd_parse

let _ =
  expect "(iszero (succ 2))" @@ test_it "iszero succ 2" cmd_parse

let _ =
  expect "(iszero (pred (neg 2)))" @@ test_it "iszero pred - 2" cmd_parse

let _ =
  expect_fail @@ test_it "true false" cmd_parse

let _ =
  expect_fail @@ test_it "not" cmd_parse

let _ =
  expect_fail @@ test_it "iszero" cmd_parse

let _ =
  expect_fail @@ test_it "true false" cmd_parse

let _ =
  expect_fail @@ test_it "false x" cmd_parse

let _ =
  expect_fail @@ test_it "iszero succ" cmd_parse

let _ =
  expect_fail @@ test_it "true iszero" cmd_parse

let _ =
  expect_fail @@ test_it "- iszero" cmd_parse

let _ =
  expect_fail @@ test_it "not y" cmd_parse



let () = print_endline "All Done"

;;