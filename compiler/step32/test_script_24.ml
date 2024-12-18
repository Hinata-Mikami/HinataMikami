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

(* ZZZ now accepted: full binary is accepted
let _ =
  expect_fail @@ test_it "1 + (x + - 3)" cmd_parse

let _ = 
  expect_fail @@ test_it "1 + x + - 3" cmd_parse
*)

(* adjustment, now negative numbers are allowed *)
let _ = 
  expect "(let [__t_2,-3] (add (let [__t_1,x] (add 1 __t_1)) __t_2))" @@ test_it "1 + x + -3" cmd_parse

let _ = 
  expect "(let [__t_2,3] (add (let [__t_1,x] (add 1 __t_1)) __t_2))" @@ test_it "1 + x + 3" cmd_parse

let _ = 
  expect "(let [__t_2,3] (add (let [__t_1,x] (add 1 __t_1)) __t_2))" @@ test_it "(1 + x) + 3" cmd_parse

(* ZZZ now accepted
let _ = 
  expect_fail @@ test_it "(1 + (x)) + 3" cmd_parse
*)

let _ = 
  expect "(let [__t_2,3] (add (let [__t_1,x] (add 1 __t_1)) __t_2))" @@ test_it "((1) + x) + 3" cmd_parse

let _ = 
  expect "(let [__t_3,3] (add (is_zero (let [__t_2,2] (add (let [__t_1,1] (add x __t_1)) __t_2))) __t_3))" @@ 
  test_it "is_zero (x + 1 + 2) + 3" cmd_parse

let _ = 
  expect "(is_zero (let [__t_3,3] (add (let [__t_2,2] (add (let [__t_1,1] (add x __t_1)) __t_2)) __t_3)))" @@ 
  test_it "is_zero ((x + 1 + 2) + 3)" cmd_parse


(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	%rdi, %rax
	movq	%rax, 8(%rsp)
	movq	$1, %rax
	movq	%rax, (%rsp)
	movq	%rdi, %rax
	incq	%rax
	addq	(%rsp), %rax
	addq	8(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "(succ x) + 1 + x" cmd_gen

(* Testing executions and type-checking *)

let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
  expect "" @@ test_it "1 + x + 3" cmd_run;
  expect "8\nDone" @@ test_command [execf; "4"]

let _ =
  expect "" @@ test_it "succ x + 1 + x" cmd_run;
  expect "-6\nDone" @@ test_command [execf; "-4"]

let _ =
  expect_fail  @@ test_it "is_zero (x + 1 + 2) + 3" cmd_run

let _ =
  expect "" @@ test_it "is_zero ((x + 1 + 2) + 3)" cmd_run;
  expect "true\nDone" @@ test_command [execf; "-6"]

let _ =
  expect "" @@ test_it "((9223372036854775800 + 1 + 2) + 3)" cmd_run;
  expect "9223372036854775806\nDone" @@ test_command [execf; "-6"]

                                          
let () = print_endline "All Done"

;;


