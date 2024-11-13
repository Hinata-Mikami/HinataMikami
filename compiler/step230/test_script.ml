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


let () = print_endline "All Done"

;;


