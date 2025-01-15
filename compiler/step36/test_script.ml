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
  expect "(add (if (eq x 1) 2 3) 4)" 
  @@ test_it "if x = 1 then 2 else 3 fi + 4"
  cmd_parse

let _ = 
  expect "(if (eq x 1) (if (eq y 1) 1 3))" 
  @@ test_it "if x = 1 then if y = 1 then 1 else 3 fi fi"
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
	call	read_int
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	cmpq	$1, %rax
	sete	%al
	movzb	%al, %rax
	test	%rax, %rax
	je	.L_1
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	print_int
.L_1:
	addq	$8, %rsp
	ret|q}
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) fi end"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$24, %rsp
	call	read_int
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	cmpq	$1, %rax
	sete	%al
	movzb	%al, %rax
	test	%rax, %rax
	je	.L_1
	movq	$2, %rax
	jmp	.L_2
.L_1:
	movq	$3, %rax
.L_2:
	addq	$4, %rax
	movq	%rax, 8(%rsp)
	movq	8(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "let val x:=read_int() \
    val y := if x = 1 then 2 else 3 fi + 4 \
    in print_int(y) end"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	.data
	.balign	4
.LC_2:
	.4byte	1
	.byte	98
	.text
	leaq	.LC_2(%rip), %rax
	movq	%rax, (%rsp)
	.data
	.balign	4
.LC_1:
	.4byte	0
	.text
	leaq	.LC_1(%rip), %rax
	movq	%rax, %rdi
	movq	(%rsp), %rsi
	call	string_eq
	xorq	$1, %rax
	movq	%rax, %rdi
	call	print_bool
	addq	$8, %rsp
	ret|q}
 @@ test_it {q| print_bool( "" <> "b" ) |q}
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$56, %rsp
	call	read_int
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	test	%rax, %rax
	setz	%al
	movzb	%al, %rax
	movq	%rax, 8(%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	test	%rax, %rax
	setz	%al
	movzb	%al, %rax
	movq	%rax, 16(%rsp)
	movq	8(%rsp), %rax
	test	%rax, %rax
	je	.L_2
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, 24(%rsp)
	movq	$2, %rax
	imulq	(%rsp), %rax
	cmpq	24(%rsp), %rax
	setg	%al
	movzb	%al, %rax
	jmp	.L_3
.L_2:
	movq	(%rsp), %rax
	addq	$2, %rax
	movq	%rax, 32(%rsp)
	movq	$2, %rax
	imulq	(%rsp), %rax
	movq	%rax, 40(%rsp)
	movq	40(%rsp), %rax
	cmpq	32(%rsp), %rax
	setg	%al
	movzb	%al, %rax
	orq	8(%rsp), %rax
.L_3:
	andq	16(%rsp), %rax
	movq	%rax, %rdi
	call	print_bool
	addq	$56, %rsp
	ret|q}
 @@ test_it {q| 
  print_bool(
  let val x := read_int()
      val y := is_zero x
  in
  if y then let val z := x + 1 in 2*x > z end
  else let val z := x+2 val u := 2*x in (u > z) | y end fi & (is_zero (x+1))
  end)
 |q}
    cmd_gen

(* Testing executions and type-checking *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) fi end"
    cmd_run;
  expect "2\nDone" @@ test_command_stdin "1\n" [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    in if x = 1 then print_int(x+1) fi end"
    cmd_run;
  expect "Done" @@ test_command_stdin "0\n" [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    val y := if x = 1 then 2 else 3 fi + 4 \
    in print_int(y) end"
    cmd_run;
  expect "6\nDone" @@ test_command_stdin "1\n" [execf]

let _ =
 expect ""
 @@ test_it "let val x:=read_int() \
    val y := if x = 1 then 2 else 3 fi + 4 \
    in print_int(y) end"
    cmd_run;
  expect "7\nDone" @@ test_command_stdin "0\n" [execf]

let _ =
 expect ""
 @@ test_it "print_int(if read_int() = 1 then 10 else 20 fi + 5)"
    cmd_run;
  expect "25\nDone" @@ test_command_stdin "0\n" [execf]

let _ =
 expect ""
 @@ test_it {q|
 let val x := read_int() in
 if x > 0 then print("positive") else print("not positive") fi
  end|q}
    cmd_run;
  expect "positive\nDone" @@ test_command_stdin "1\n" [execf]

let _ =
 expect ""
 @@ test_it {q|
 let val x := read_int() in
 if x > 0 then print("positive") else print("not positive") fi
  end|q}
    cmd_run;
  expect "not positive\nDone" @@ test_command_stdin "-1\n" [execf]

let _ =
 expect ""
 @@ test_it {q|
 let val x := read_int() in
 print(if x > 0 then "positive" else "not positive" fi)
  end|q}
    cmd_run;
  expect "not positive\nDone" @@ test_command_stdin "-1\n" [execf]


(* strings *)
(* Was
let _ =
 expect ""
 @@ test_it "print_bool(\"\"=\"\")"
    cmd_run;
  expect "false\nDone" @@ test_command [execf]
*)

let _ =
 expect ""
 @@ test_it "print_bool(\"\"=\"\")"
    cmd_run;
  expect "true\nDone" @@ test_command [execf]

(* was
let _ =
 expect ""
 @@ test_it {q|
   let val s1 := "abc" val s2 := "123" val s3 := "abc" in
   print_bool(s1<s2); print_line(); print_bool(s2<s3)
   end|q}
    cmd_run;
  expect "true\ntrue\nDone" @@ test_command [execf]
*)

let _ =
 expect ""
 @@ test_it {q|
   let val s1 := "abc" val s2 := "123" val s3 := "abc" in
   print_bool(s1<s2); print_line(); print_bool(s2<s3)
   end|q}
    cmd_run;
  expect "false\ntrue\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 print_bool("ab" =  "b");print_line();
 print_bool("ab" <  "b");print_line();
 print_bool("ab" <= "b");print_line();
 print_bool("ab" <> "b");print_line();
 print_bool("ab" >  "b");print_line();
 print_bool("ab" >= "b")|q}
    cmd_run;
  expect "false\ntrue\ntrue\ntrue\nfalse\nfalse\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 print_bool("ab" =  "ac");print_line();
 print_bool("ab" <  "ac");print_line();
 print_bool("ab" <= "ac");print_line();
 print_bool("ab" <> "ac");print_line();
 print_bool("ab" >  "ac");print_line();
 print_bool("ab" >= "ac")|q}
    cmd_run;
  expect "false\ntrue\ntrue\ntrue\nfalse\nfalse\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 print_bool("" =  "b");print_line();
 print_bool("" <  "b");print_line();
 print_bool("" <= "b");print_line();
 print_bool("" <> "b");print_line();
 print_bool("" >  "b");print_line();
 print_bool("" >= "b")|q}
    cmd_run;
  expect "false\ntrue\ntrue\ntrue\nfalse\nfalse\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 print_bool("ab" =  "a");print_line();
 print_bool("ab" <  "a");print_line();
 print_bool("ab" <= "a");print_line();
 print_bool("ab" <> "a");print_line();
 print_bool("ab" >  "a");print_line();
 print_bool("ab" >= "a")|q}
    cmd_run;
  expect "false\nfalse\nfalse\ntrue\ntrue\ntrue\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 print_bool("ab" =  "ab");print_line();
 print_bool("ab" <  "ab");print_line();
 print_bool("ab" <= "ab");print_line();
 print_bool("ab" <> "ab");print_line();
 print_bool("ab" >  "ab");print_line();
 print_bool("ab" >= "ab")|q}
    cmd_run;
  expect "true\nfalse\ntrue\nfalse\nfalse\ntrue\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 print_bool("" =  "");print_line();
 print_bool("" <  "");print_line();
 print_bool("" <= "");print_line();
 print_bool("" <> "");print_line();
 print_bool("" >  "");print_line();
 print_bool("" >= "")|q}
    cmd_run;
  expect "true\nfalse\ntrue\nfalse\nfalse\ntrue\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
  print_bool(
  let val x := read_int()
      val y := is_zero x
  in
  if y then let val z := x + 1 in 2*x > z end
  else let val z := x+2 val u := 2*x in (u > z) | y end fi & (is_zero (x+1))
  end)
 |q}
    cmd_run;
  expect "false\nDone" @@ 
  test_command_stdin "1\n" [execf]

let () = print_endline "All Done"

;;


