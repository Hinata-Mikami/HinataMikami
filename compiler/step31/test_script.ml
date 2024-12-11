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
  expect "(let [y,(add 1 x)] (let [z,(add 4 y)] (add (add (add 10 x) y) z)))" 
  @@ test_it "let val y := 1+x\n val z :=4+y in 10+x+y+z end" 
       cmd_parse

let _ = 
  expect "(add (let [y,1] y) 2)" @@ test_it "(let val y := 1 in y end) + 2" 
  cmd_parse

let _ = 
  expect "(add (let [y,1] (add y 1)) 2)" @@ 
  test_it "(let val y := 1 in y+1 end) + 2" 
  cmd_parse

let _ = 
  expect "(add (succ (let [y,(add x 1)] (pred (add y 1)))) 2)" @@ 
  test_it "succ (let val y := x+1 in pred (y+1) end) + 2" 
  cmd_parse

let _ = 
  expect "(add (let [x,(add (succ (let [x,(add x 1)] (add x 1))) 2)] (add x 1)) 2)" @@ 
  test_it "(let val x := succ (let val x := x+1 in x+1 end) + 2 in x+1 end) + 2" 
  cmd_parse

let _ = 
  expect "(let [x,(add x 1)] (let [x,(add x 1)] (let [x,(add (add (let [x,(add x 1)] (add x 1)) x) 1)] (add x 1))))" @@ test_it 
 {q|
 let val x := x + 1 
    val x := x + 1 
    val x := (let val x := x + 1 in x + 1 end) + x + 1
 in x + 1
 end|q}
  cmd_parse

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]
let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	movq	%rdi, %rax
	addq	$1, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	addq	(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$8, %rsp
	ret|q}
 @@ test_it "let val y := x + 1 in y + 1 + y end" cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	$1, %rax
	addq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	$4, %rax
	addq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	$10, %rax
	addq	%rdi, %rax
	addq	(%rsp), %rax
	addq	8(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "let val y := 1+x\n val z :=4+y in 10+x+y+z end" cmd_gen


let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	$1, %rax
	addq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	$4, %rax
	addq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	$8, %rax
	addq	8(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	$10, %rax
	addq	%rdi, %rax
	addq	16(%rsp), %rax
	addq	8(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "let val y := 1+x\n val z :=4+y\n val u := 8+z in 10+x+u+z end" 
      cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	$1, %rax
	addq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	$2, %rax
	addq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	$4, %rax
	addq	8(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	$10, %rax
	addq	%rdi, %rax
	addq	8(%rsp), %rax
	addq	16(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "let val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z :=4+y in 10+x+y+z end" cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$40, %rsp
	movq	%rdi, %rax
	addq	$1, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, 8(%rsp)
	movq	8(%rsp), %rax
	addq	$1, %rax
	movq	%rax, 16(%rsp)
	movq	16(%rsp), %rax
	addq	$1, %rax
	addq	8(%rsp), %rax
	addq	$1, %rax
	movq	%rax, 24(%rsp)
	movq	24(%rsp), %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	print_int
	addq	$40, %rsp
	ret|q}
 @@ test_it
 {q|
 let val x := x + 1 
    val x := x + 1 
    val x := (let val x := x + 1 in x + 1 end) + x + 1
 in x + 1
 end|q}
  cmd_gen

let _ = 
  expect_fail @@ test_it "10+y+z" cmd_gen

let _ = 
  expect_fail @@ test_it "let val y := y in 1 end" cmd_gen

(*
let (s,_) = test_it
let _ = print_endline s
*)

(* Testing executions and type-checking *)

let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "let val y := 1+x\n val z :=4+y\n val u := 8+z in 10+x+u+z end" 
    cmd_run;
  expect "328\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it "let val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z :=4+y in 10+x+y+z end" cmd_run;
  expect "320\nDone" @@ test_command [execf; "100"]


let _ =
  expect "" @@ test_it
 {q|
 let val x := x + 1 
    val x := x + 1 
    val x := (let val x := x + 1 in x + 1 end) + x + 1
 in x + 1
 end|q}
  cmd_run;
  expect "208\nDone" @@ test_command [execf; "100"]


let _ =
  expect "" @@ test_it
 {q|
 let 
  val x := 10
  val y := x + 1
  val z := y + 2
 in z + x
 end|q}
  cmd_run;
  expect "23\nDone" @@ test_command [execf; "100"]

let () = print_endline "All Done"

;;

;;


