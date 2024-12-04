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

(*
let
  var x: int := 10
  var y := x + 1
  var z: string := "abc"
in
  x + y
end
*)

let _ = 
  expect_fail @@ test_it "let val y := 1+x\n val z :=4+y in 10+y+z" cmd_parse

let _ = 
  expect "(let [y_1,(add 1 x)] (let [z_2,(add 4 y_1)] (add (add (add 10 x) y_1) z_2)))" 
  @@ test_it "let val y := 1+x\n val z :=4+y in 10+x+y+z end" 
       cmd_parse

let _ = 
  expect "(add (let [y_1,1] y_1) 2)" @@ test_it "let val y := 1 in y end + 2" 
  cmd_parse

let _ = 
  expect "(add (let [y_1,1] (add y_1 1)) 2)" @@ 
  test_it "let val y := 1 in y+1 end + 2" 
  cmd_parse

let _ = 
  expect "(add (succ (let [y_1,(add x 1)] (pred (add y_1 1)))) 2)" @@ 
  test_it "succ (let val y := x+1 in pred (y+1) end) + 2" 
  cmd_parse

let _ = 
  expect "(add (let [x_2,(add (succ (let [x_1,(add x 1)] (add x_1 1))) 2)] (add x_2 1)) 2)" @@ 
  test_it "(let val x := succ (let val x := x+1 in x+1 end) + 2 in x+1 end) + 2" 
  cmd_parse

let _ = 
  expect "(let [x_1,(add x 1)] (let [x_2,(add x_1 1)] (let [x_4,(add (add (let [x_3,(add x_2 1)] (add x_3 1)) x_2) 1)] (add x_4 1))))" @@ test_it 
 {q|
 let val x := x + 1 
    val x := x + 1 
    val x := let val x := x + 1 in x + 1 end + x + 1
 in x + 1
 end|q}
  cmd_parse


let () = print_endline "All Done"

;;

;;


