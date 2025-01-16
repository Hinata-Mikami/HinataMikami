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
  expect "(while (eq x 1) (call print_int x))" 
  @@ test_it "while x = 1 do print_int(x) done"
  cmd_parse

let _ = 
  expect "(for (i 1 5) (call print_int i))" 
  @@ test_it "for i:=1 to 5 do print_int(i) done"
  cmd_parse

let _ = 
  expect "(let [__t_1,(add 4 1)] (for (i (add 0 1) __t_1) (call print_int i)))" 
  @@ test_it "for i:=0+1 to 4+1 do print_int(i) done"
  cmd_parse


(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ = 
  expect_fail 
  @@ test_it "while 1 = 1 do 2 done"
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it "while 1 do print_int(2) done"
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it "for i:=1 to true do print_int(2) done"
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it "for i:=false to true do print_int(2) done"
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it "for i:=1 to 5 do 5 done"
  cmd_gen

(* i is immutable *)
let _ = 
  expect_fail 
  @@ test_it "for i:=1 to 5 do i:=1 done"
  cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	movq	$1, %rax
	movq	%rax, (%rsp)
	jmp	.L_2
.L_1:
	movq	(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, (%rsp)
.L_2:
	movq	(%rsp), %rax
	cmpq	$5, %rax
	setl	%al
	movzb	%al, %rax
	test	%al, %al
	jne	.L_1
	addq	$8, %rsp
	ret|q}
 @@ test_it "let var i:=1 \
    in while i < 5 do print_int(i); i := i+1 done end"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	movq	$1, %rax
	movq	%rax, (%rsp)
	jmp	.L_2
.L_1:
	movq	(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	incq	(%rsp)
.L_2:
	movq	(%rsp), %rax
	cmpq	$5, %rax
	setle	%al
	movzb	%al, %rax
	test	%al, %al
	jne	.L_1
	addq	$8, %rsp
	ret|q}
 @@ test_it "for i:=1 to 5 do print_int(i) done"
    cmd_gen

(* Testing executions and type-checking *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "let var i:=1 \
    in while i < 5 do print_int(i); i := i+1 done end"
    cmd_run;
  expect "1234\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
    while 0=read_int() do print("zero") done|q}
    cmd_run;
  expect "zerozero\nDone" @@ 
  test_command_stdin "0\n0\n1\n" [execf]

let _ =
 expect ""
 @@ test_it "for i:=1 to 5 do print_int(i) done"
    cmd_run;
  expect "12345\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it "for i:=1 to 0 do print_int(i) done"
    cmd_run;
  expect "Done" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it "for i:=-10 to -10 do print_int(i) done"
    cmd_run;
  expect "-10\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it "for i:=-10 to -9 do print_int(i) done"
    cmd_run;
  expect "-10-9\nDone" @@ test_command [execf]

(* example from the notes *)
let _ =
 expect ""
 @@ test_it {q|
  for i:=1 to read_int() do print_int(i) done|q}
    cmd_run;
  expect "12345\nDone" @@ 
  test_command_stdin "5\n" [execf]


(* The code from the Introduction in the course notes *)

let _ =
 expect ""
 @@ test_it {q|
let 
   val n := read_int() 
   var sum := 0
in
   for i:=1 to n do
      let val v := read_int() 
      in sum := sum + v end
   done;
   print_int(sum)
end
|q}
    cmd_run;
  expect "15\nDone" @@ 
  test_command_stdin "5\n1\n2\n3\n4\n5\n" [execf]

let () = print_endline "All Done"

;;
