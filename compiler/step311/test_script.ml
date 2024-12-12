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

(* add を tmpを使うように仕様変更したので不可 *)
(* let _ = 
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
  cmd_parse *)

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

(*　add を tmpを使うように仕様変更したので不可 *)
(* let _ =
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
  cmd_gen *)

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


(* Ex20 *)
let _ = 
  expect "(let [tmp,false] (equal true tmp))" @@ 
  test_it "true = false" 
  cmd_parse

let _ = 
	expect "(let [tmp,2] (add (let [y,1] y) tmp))" @@ test_it "(let val y := 1 in y end) + 2" 
	cmd_parse

let _ = 
	expect "(let [tmp,2] (add (succ (let [y,(let [tmp,1] (add x tmp))] (pred (let [tmp,1] (add y tmp))))) tmp))" @@ 
	test_it "succ (let val y := x+1 in pred (y+1) end) + 2" 
	cmd_parse

let _ =
	expect "(let [tmp,2] (le 1 tmp))" @@ 
	test_it "1 <= 2" 
	cmd_parse

let _ =
	expect "(let [tmp,true] (lt false tmp))" @@ 
	test_it "false < true" 
	cmd_parse

let _ =
	expect "(let [tmp,x] (mt (succ x) tmp))" @@ 
	test_it "succ x > x" 
	cmd_parse

let _ =
	expect "(let [tmp,-6] (me -5 tmp))" @@ 
	test_it "-5 >= -6" 
	cmd_parse

let _ =
	expect "(let [tmp,(let [tmp,(succ -2)] (add (succ 0) tmp))] (ne (pred 1) tmp))" @@ 
	test_it "pred 1 <> succ 0 + succ -2" 
	cmd_parse

let _ =
	expect "(let [tmp,(pred 7)] (times 4 tmp))" @@ 
	test_it "4 * pred 7" 
	cmd_parse

let _ =
	expect "(let [tmp,7] (minus -5 tmp))" @@ 
	test_it "-5 - 7" 
	cmd_parse

let _ =
	expect "(let [tmp,(succ 1)] (div (pred 2) tmp))" @@ 
	test_it "pred 2 / succ 1" 
	cmd_parse

let _ = 
	expect_fail @@ test_it "1 < true" cmd_gen

let _ = 
	expect_fail @@ test_it "succ 1 = is_zero 1" cmd_gen

let _ = 
	expect_fail @@ test_it "is_zero 4 / pred 5" cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$40, %rsp
	movq	$1, %rax
	movq	%rax, (%rsp)
	movq	%rdi, %rax
	addq	(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	16(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	$1, %rax
	movq	%rax, 8(%rsp)
	movq	16(%rsp), %rax
	addq	8(%rsp), %rax
	addq	24(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$40, %rsp
	ret|q}
 @@ test_it "let val y := x + 1 in y + 1 + y end" cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$56, %rsp
	movq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	$1, %rax
	addq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	8(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	$4, %rax
	addq	16(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	24(%rsp), %rax
	movq	%rax, 32(%rsp)
	movq	8(%rsp), %rax
	movq	%rax, 40(%rsp)
	movq	%rdi, %rax
	movq	%rax, 48(%rsp)
	movq	$10, %rax
	addq	48(%rsp), %rax
	addq	40(%rsp), %rax
	addq	32(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$56, %rsp
	ret|q}
 @@ test_it "let val y := 1+x\n val z :=4+y in 10+x+y+z end" cmd_gen


let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$88, %rsp
	movq	$1, %rax
	movq	%rax, (%rsp)
	movq	%rdi, %rax
	addq	(%rsp), %rax
	movq	%rax, 48(%rsp)
	movq	$1, %rax
	movq	%rax, 8(%rsp)
	movq	48(%rsp), %rax
	addq	8(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	$1, %rax
	movq	%rax, 32(%rsp)
	movq	56(%rsp), %rax
	movq	%rax, 64(%rsp)
	movq	$1, %rax
	movq	%rax, 16(%rsp)
	movq	56(%rsp), %rax
	addq	16(%rsp), %rax
	movq	%rax, 72(%rsp)
	movq	$1, %rax
	movq	%rax, 24(%rsp)
	movq	72(%rsp), %rax
	addq	24(%rsp), %rax
	addq	64(%rsp), %rax
	addq	32(%rsp), %rax
	movq	%rax, 80(%rsp)
	movq	$1, %rax
	movq	%rax, 40(%rsp)
	movq	80(%rsp), %rax
	addq	40(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$88, %rsp
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
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	$10, %rax
	movq	%rax, 8(%rsp)
	movq	$2, %rax
	movq	8(%rsp), %rdi
	imulq	%rdi, %rax
	movq	%rax, 16(%rsp)
	movq	$3, %rax
	movq	%rax, (%rsp)
	movq	$3, %rax
	movq	(%rsp), %rdi
	imulq	%rdi, %rax
	movq	16(%rsp), %rdi
	cmpq	%rdi, %rax
	setle	%al
	movzb	%al, %rax
	movq	%rax, %rdi
	call	print_bool
	addq	$24, %rsp
	ret|q}
 @@ test_it
 {q|
	3 * 3 <= 2 * 10
 |q}
  cmd_gen

let _ =
  expect "" @@ test_it
 {q|
	1 = 2
 |q}
  cmd_run;
  expect "false\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	(let val y := 1 in y end) + 2
 |q}
  cmd_run;
  expect "3\nDone" @@ test_command [execf; "100"]

let _ =
	expect "" @@ test_it
	{q|
	true = false
	|q}
	cmd_run;
	expect "false\nDone" @@ test_command [execf; "100"]

let _ =
	expect "" @@ test_it
	{q|
	2 - 1
	|q}
	cmd_run;
	expect "1\nDone" @@ test_command [execf; "100"]

let _ = 
	expect "(let [tmp,(pred x)] (add (succ x) tmp))" @@ 
	test_it "succ x + pred x" 
	cmd_parse
	
let _ =
	expect "" @@ test_it
	{q|
	1 + 4 * 2
	|q}
	cmd_run;
	expect "9\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	1 <= 2
 |q}
  cmd_run;
  expect "true\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	false <= true
 |q}
  cmd_run;
  expect "true\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	succ x > x
 |q}
  cmd_run;
  expect "true\nDone" @@ test_command [execf; "1"]

let _ =
  expect "" @@ test_it
 {q|
	-5 >= -6
 |q}
  cmd_run;
  expect "true\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	pred 1 <> succ 0 + succ -2
 |q}
  cmd_run;
  expect "false\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	4 * pred 7
 |q}
  cmd_run;
  expect "24\nDone" @@ test_command [execf; "100"]

let _ =
  expect "" @@ test_it
 {q|
	let val x := 3 val y := 2 in x / y end
 |q}
  cmd_run;
  expect "1\nDone" @@ test_command [execf; "100"]

let () = print_endline "All Done"
;;

;;


