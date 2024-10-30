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


let () = print_endline "All Done"

;;


