(* testing script *)

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
  expect_fail @@ test_it "1 + read_int ()" 
  cmd_parse

let _ = 
  expect "(let [__t_1,(call0 read_int)] (add 1 __t_1))" 
  @@ test_it "1 + read_int()" 
  cmd_parse

let _ = 
  expect "(let [__t_1,(call foo 1)] (add 1 __t_1))" 
  @@ test_it "1 + foo(1)"
  cmd_parse

let _ = 
  expect "(let [__t_1,(call foo 1 2)] (add 1 __t_1))" 
  @@ test_it "1 + foo(1,2)"
  cmd_parse

let _ = 
  expect "(let [__t_3,(let [__t_1,(add x 1)] (let [__t_2,(add x 2)] (call foo 1 __t_1 2 __t_2)))] (add 1 __t_3))" 
  @@ test_it "1 + foo(1,x+1, 2, x+2)"
  cmd_parse

let _ = 
  expect "(seq (call0 foo) (seq (call0 bar) 1))" 
  @@ test_it "foo(); bar(); 1"
  cmd_parse

let _ = 
  expect "(seq (call0 foo) (seq (call0 bar) (add 1 2)))" 
  @@ test_it "foo(); bar(); 1+2"
  cmd_parse

let _ = 
  expect "(seq () (seq (call0 foo) (seq () (seq (call0 bar) (add 1 2)))))" 
  @@ test_it "(); foo(); (); bar(); 1+2"
  cmd_parse


(* It parses; but it gives type error later on *)
let _ = 
  expect "(seq (add 1 2) (add 3 4))"
  @@ test_it "1+2; 3+4" 
  cmd_parse

let _ = 
  expect "(let [x,(seq 1 2)] (let [y,(seq 3 4)] (seq (call0 foo) 5)))" 
  @@ test_it "let val x:=1;2 val y:=3;4 in foo(); 5 end"
  cmd_parse

let _ = 
  expect "(let [x,(add 1 2)] (let [*y,x] (let [z,x] (seq (assign y (add (neg x) 1)) 5))))" 
  @@ test_it "let val x:=1+2 var y:=x  val z:=x in y:=-x+1; 5 end" 
  cmd_parse

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ = 
  expect_fail
  @@ test_it "1+2; 3+4" 
  cmd_gen

let _ = 
  expect_fail
  @@ test_it "let val x:= 1 in x end" 
  cmd_gen

(* x is no longer pre-defined *)
let _ = 
  expect_fail
  @@ test_it "print_int(x+1)" 
  cmd_gen

let _ = 
  expect_fail
  @@ test_it "foo(1)" 
  cmd_gen

(* Type error *)
let _ = 
  expect_fail
  @@ test_it "read_int() & true" 
  cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	movq	$1, %rax
	movq	%rax, %rdi
	call	print_int
	movq	$1, %rax
	movq	%rax, (%rsp)
	addq	$8, %rsp
	ret|q}
 @@ test_it "let val x:= print_int(1); 1 in () end"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	call	read_int
	movq	%rax, (%rsp)
	call	read_int
	subq	(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$8, %rsp
	ret|q}
 @@ test_it "print_int(read_int() - read_int())"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	movq	$1, %rax
	decq	%rax
	movq	%rax, (%rsp)
	movq	$1, %rax
	incq	%rax
	addq	(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$8, %rsp
	ret|q}
 @@ test_it "let val z := 1 in print_int(succ z + pred z) end"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	$1, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	8(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "let var x := 1 val z := x in x := x + 1; print_int(x + z) end"
    cmd_gen

(*
let (s,_) = test_it  cmd_gen
let _ = print_endline s
*)



(* Testing executions and type-checking *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "let var x := 1 val z := x in x := x + 1; print_int(x + z) end"
    cmd_run;
  expect "3\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z := y in print_int(10+x+(y+z)) end"
    cmd_run;
  expect "316\nDone" @@ test_command_stdin "100\n" [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    val y := \
    let val y1 := 1 + x in 2 + y1 end \
    var z := 1 in z := z + (y + -1); print_int(10+x+(y+z)) end"
    cmd_run;
  expect "316\nDone" @@ test_command_stdin "100\n" [execf]

let () = print_endline "All Done"

;;


