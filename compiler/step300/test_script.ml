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
(* Ex 12 *)








let () = print_endline "All Done"

;;

;;


