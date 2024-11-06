(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load "expect.cmo"
*)


let () = print_endline("L10")
open Expect
let tigerc = Filename.concat "Build" "tigerc"
let execf = Filename.concat "Build" "a.out"

(* Check command-line arguments *)
let _ =
  expect_fail @@ test_it "" (fun name -> [tigerc])

let _ =
  expect_fail @@ test_it "" (fun name -> [tigerc; name; name])

let _ =
  expect_fail @@ test_it "" (fun name -> [tigerc; "xxx"])

let _ =
  expect_fail @@ test_it "" (fun name -> [tigerc; "--xxx"])


(* Test parsing *)
let cmd_parse fname = [tigerc; "--dump-parse"; fname]

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



let () = print_endline("L50")
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
  let () = print_endline("L75")
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

let () = print_endline("L105")
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

let () = print_endline("L150")
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

let _ =
  expect "true" @@ test_it "true" cmd_parse
let () = print_endline("L170")
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
  expect "(is_zero 7)" @@ test_it "is_zero 7" cmd_parse

let _ =
  expect "(not (is_zero 7))" @@ test_it "not is_zero 7" cmd_parse

let _ =
  expect "(not (is_zero x))" @@ test_it "not is_zero x" cmd_parse

let _ =
  expect "(is_zero (succ 2))" @@ test_it "is_zero succ 2" cmd_parse

let _ =
  expect "(is_zero (pred (neg 2)))" @@ test_it "is_zero pred - 2" cmd_parse



let () = print_endline("L205")
let _ =
  expect_fail @@ test_it "true false" cmd_parse

let _ =
  expect_fail @@ test_it "not" cmd_parse

let _ =
  expect_fail @@ test_it "is_zero" cmd_parse

let _ =
  expect_fail @@ test_it "true false" cmd_parse

let _ =
  expect_fail @@ test_it "false x" cmd_parse

let _ =
  expect_fail @@ test_it "is_zero succ" cmd_parse

let _ =
  expect_fail @@ test_it "true is_zero" cmd_parse

let _ =
  expect_fail @@ test_it "- is_zero" cmd_parse

let _ =
  expect_fail @@ test_it "not y" cmd_parse
(* Testing code generation *)


let () = print_endline("L235")
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	movq	%rdi, %rax
	negq	%rax
	incq	%rax
	movq	%rax, %rdi
	call	_print_int
	addq	$8, %rsp
	ret|q}
  @@ test_it "succ - x" cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	movq	$9223372036854775807, %rax
	decq	%rax
	negq	%rax
	incq	%rax
	movq	%rax, %rdi
	call	_print_int
	addq	$8, %rsp
	ret|q}
  @@ test_it "succ - pred 9223372036854775807" cmd_gen
 
let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
	.type	_ti_main, @function
_ti_main:
	subq	$8, %rsp
	movq	$0, %rax
	testq	%rax, %rax
	setz	%al
	movzb	%al, %rax
	movq	%rax, %rdi
	call	_print_bool
	addq	$8, %rsp
	ret|q}
  @@ test_it "is_zero 0" cmd_gen

(* Testing executions *)
let () = print_endline "Testing executions"
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
  expect "" @@ test_it "succ - pred 9223372036854775807" cmd_run;
  expect "-9223372036854775805\nDone" @@ test_command [execf; "42"]

let _ =
  expect "" @@ test_it "succ - x" cmd_run;
  expect "-3\nDone" @@ test_command [execf; "4"]

let _ =
  expect "" @@ test_it "succ - x" cmd_run;
  expect "-9223372036854775804\nDone" @@ test_command [execf; "9223372036854775805"]

let _ =
  expect "" @@ test_it "succ - x" cmd_run;
  expect_fail @@ test_command [execf]

let _ =
  expect "" @@ test_it "succ - x" cmd_run;
  expect_fail @@ test_command [execf;"xxx"]

let _ =
  expect "" @@ test_it "succ pred - x " cmd_run;
  expect "9223372036854775805\nDone" @@ test_command [execf; "-9223372036854775805"]

let _ =
  expect "" @@ test_it "true" cmd_run;
  expect "true\nDone" @@ test_command [execf; "1"]

let _ =
  expect "" @@ test_it "is_zero x" cmd_run;
  expect "true\nDone" @@ test_command [execf; "0"]

  let _ =
    expect "" @@ test_it "not x" cmd_run;
    expect "false\nDone" @@ test_command [execf; "true"]
let () = print_endline "All Done"

;;


