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
  expect "(add (if (eq x 1) 2 (if (eq x 2) 3 4)) 10)" 
  @@ test_it "if x = 1 then 2 elif x=2 then 3 else 4 fi + 10"
  cmd_parse

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ = 
  expect_fail 
  @@ test_it "if 1 = 1 then 2 elif 1=2 then print_int(1) fi"
  cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	call	read_int
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	cmpq	$1, %rax
	sete	%al
	movzb	%al, %rax
	test	%rax, %rax
	je	.L_2
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	print_int
	jmp	.L_3
.L_2:
	movq	(%rsp), %rax
	cmpq	$2, %rax
	sete	%al
	movzb	%al, %rax
	test	%rax, %rax
	je	.L_1
	movq	(%rsp), %rax
	addq	$2, %rax
	movq	%rax, %rdi
	call	print_int
.L_1:
.L_3:
	addq	$8, %rsp
	ret|q}
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) elif x = 2 then print_int(x+2) fi end"
    cmd_gen

(* Testing executions and type-checking *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) elif x = 2 then print_int(x+2) fi end"
    cmd_run;
  expect "2\nDone" @@ test_command_stdin "1\n" [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) elif x = 2 then print_int(x+2) fi end"
    cmd_run;
  expect "4\nDone" @@ test_command_stdin "2\n" [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) elif x = 2 then print_int(x+2) fi end"
    cmd_run;
  expect "Done" @@ test_command_stdin "0\n" [execf]

let _ =
 expect ""
 @@ test_it {q|let val x:=read_int() in 
    print_int(if x = 1 then x+1 elif x = 2 then x+2 
    elif x=3 then x+3 else 10 fi) end|q}
    cmd_run;
  expect "10\nDone" @@ test_command_stdin "0\n" [execf]

let _ =
 expect ""
 @@ test_it {q|let val x:=read_int() in 
    print_int(if x = 1 then x+1 elif x = 2 then x+2 
    elif x=3 then x+3 else 10 fi) end|q}
    cmd_run;
  expect "6\nDone" @@ test_command_stdin "3\n" [execf]

let _ =
 expect ""
 @@ test_it {q|let val x:=read_int() in 
    print_int(if x = 1 then x+1 elif x = 2 then x+2 
    elif x=3 then x+3 else 10 fi) end|q}
    cmd_run;
  expect "2\nDone" @@ test_command_stdin "1\n" [execf]

let () = print_endline "All Done"

;;

