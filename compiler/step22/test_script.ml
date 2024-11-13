(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load "expect.cmo"
*)

open Expect

let tigerc = Filename.concat "Build" "tigerc"
let execf = Filename.concat "Build" "a.out"

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

let _ =
  expect "(is_zero (is_zero x))" @@ test_it "is_zero is_zero x" cmd_parse

(* Testing code generation *)

let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	movq	%rdi, %rax
	test	%rax, %rax
	setz	%al
	movzb	%al, %rax
	xorq	$1, %rax
	movq	%rax, %rdi
	call	print_bool
	addq	$8, %rsp
	ret|q}
 @@ test_it "not is_zero x" cmd_gen

let _ =
  expect_fail @@ test_it "-true" cmd_gen

let _ =
  expect_fail @@ test_it "is_zero is_zero x" cmd_gen

let _ =
  expect_fail @@ test_it "not - x" cmd_gen

(* Testing executions *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
  expect "" @@ test_it "is_zero x" cmd_run

let _ = expect "false\nDone" @@ 
  test_command [execf; "9223372036854775805"]

let _ = expect "false\nDone" @@ 
  test_command [execf; "-9223372036854775805"]

let _ = expect "true\nDone" @@ 
  test_command [execf; "0"]

let _ =
  expect "" @@ test_it "not is_zero x" cmd_run

let _ = expect "true\nDone" @@ 
  test_command [execf; "9223372036854775805"]

let _ = expect "true\nDone" @@ 
  test_command [execf; "-9223372036854775805"]

let _ = expect "false\nDone" @@ 
  test_command [execf; "0"]

let () = print_endline "All Done"

;;


