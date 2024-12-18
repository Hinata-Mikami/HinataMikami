(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load "expect.cmo"
*)

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

(* ZZZ negative numbers are tokens *)
let _ =
  expect "-42" @@ test_it "-42" cmd_parse

(* now works: xxx is just the variable name *)
let _ =
  expect "xxx" @@ test_it "xxx" cmd_parse

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


(* Test for x and unary operations *)

let _ =
  expect "x" @@ test_it "x" cmd_parse

let _ =
  expect "x" @@ test_it " x" cmd_parse

let _ =
  expect "(neg x)" @@ test_it "-x" cmd_parse

let _ =
  expect "(neg x)" @@ test_it "- x" cmd_parse

(* Now, it succeeds *)
let _ =
  expect "(let [__t_1,x] (sub succpred __t_1))" @@ test_it "succpred-x" cmd_parse

(* ZZZ need parentheses now *)
let _ =
  expect_fail @@ test_it "succ - x" cmd_parse

let _ =
  expect_fail @@ test_it "succ pred - x " cmd_parse

let _ =
  expect "(succ (pred (neg x)))" @@ test_it "succ (pred (- x)) " cmd_parse

(* Testing code generation *)

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
  @@ test_it "succ (- x)" cmd_gen

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
  @@ test_it "succ (- (pred 9223372036854775807))" cmd_gen


(* Testing executions *)

let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
  expect "" @@ test_it "succ (- (pred 9223372036854775807))" cmd_run;
  expect "-9223372036854775805\nDone" @@ test_command [execf; "42"]

let _ =
  expect "" @@ test_it "succ (- x)" cmd_run;
  expect "-3\nDone" @@ test_command [execf; "4"]

let _ =
  expect "" @@ test_it "succ (- x)" cmd_run;
  expect "-9223372036854775804\nDone" @@ test_command [execf; "9223372036854775805"]

let _ =
  expect "" @@ test_it "succ (pred (- x)) " cmd_run;
  expect "9223372036854775805\nDone" @@ test_command [execf; "-9223372036854775805"]

let () = print_endline "All Done"

;;


