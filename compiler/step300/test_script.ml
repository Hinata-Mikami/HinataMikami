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
(* Ex 12, 13 *)

let _ = 
  expect "a" @@ test_it 
 {q|
  a
 |q}
  cmd_parse

let _ = 
  expect "-1" @@ test_it 
  {q|
  -1
  |q}
  cmd_parse

let _ = 
  expect "(add 1 -1)" @@ test_it 
  {q|
  1 + -1
  |q}
  cmd_parse

let _ = 
  expect "(let [z,true] (not z))" @@ test_it 
  {q|
    let val z := true in (not z) end
  |q}
  cmd_parse

let _ = 
  expect "(let [x,1] [y,2] x)" @@ test_it 
  {q|
    let val x := 1 val y := 2 in x end
  |q}
  cmd_parse

let _ = 
  expect "(let [x,1] (let [y,true] y))" @@ test_it 
  {q|
    let val x := 1 in (let val y := true in y end) end
  |q}
  cmd_parse

let _ = 
  expect "(let [x,1] (let [y,true] [z,(pred x)] z))" @@ test_it 
  {q|
    let val x := 1 in (let val y := true val z := pred x in z end) end
  |q}
  cmd_parse

let _ =
  expect_fail @@ test_it
  {q|

  |q}
  cmd_parse

let _ =
  expect_fail @@ test_it
  {q|
   let in true end
  |q}
  cmd_parse

let _ =
  expect_fail @@ test_it
  {q|
    let val in true end
  |q}
  cmd_parse

let _ =
  expect_fail @@ test_it
  {q|
    let val z := -2 in end
  |q}
  cmd_parse

let _ =
  expect_fail @@ test_it
  {q|
    1 + (let val z := -2 in z end)
  |q}
  cmd_parse

let _ = 
  expect "(let [x,1] 1)" @@ test_it 
  {q|
  let val x := 1 in 1 end
  |q}
  cmd_parse


let () = print_endline "All Done"

;;

;;


