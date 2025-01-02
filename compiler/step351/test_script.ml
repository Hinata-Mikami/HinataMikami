(* testing script *)

(* testing script *)

(*
#load "unix.cma"
#directory "../util"
#load_rec "config.cmo"
*)

open Expect

let tigerc = Filename.concat "Build" "tigerc"
let execf = Filename.concat "Build" "a.out"

(* Test parsing *)
let cmd_parse fname = [tigerc; "--dump-parse"; fname]

(* identifiers starting with an underscore aren't allowed in user input 
   (Fixing the bug identified by a student)
*) 
let _ = 
  expect_fail @@ test_it "let val __t_1 := x + 3 in __t_1 * (__t_1 - 1) end"
  cmd_parse

let _ = 
  expect "(call print_bool (let [__t_1,\"\"] (eq \"\" __t_1)))" 
  @@ test_it "print_bool(\"\"=\"\")"
  cmd_parse

let _ = 
  expect "(call print \"World, \\227\\129\\147\\227\\130\\147\\227\\129\\171\\227\\129\\161\\227\\129\\175!\")"
  @@ test_it "print(\"World, こんにちは!\")"
  cmd_parse

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ = 
  expect_fail
  @@ test_it "1=\"\"" 
  cmd_gen

let _ = 
  expect_fail
  @@ test_it "print_string(\"\")" 
  cmd_gen

let _ = 
  expect_fail
  @@ test_it "print_line(1)" 
  cmd_gen

let _ = 
  expect_fail
  @@ test_it "print(1)" 
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
.LC_1:
	.4byte	23
	.byte	87
	.byte	111
	.byte	114
	.byte	108
	.byte	100
	.byte	44
	.byte	32
	.byte	227
	.byte	129
	.byte	147
	.byte	227
	.byte	130
	.byte	147
	.byte	227
	.byte	129
	.byte	171
	.byte	227
	.byte	129
	.byte	161
	.byte	227
	.byte	129
	.byte	175
	.byte	33
	.text
	leaq	.LC_1(%rip), %rax
	movq	%rax, %rdi
	call	print
	addq	$8, %rsp
	ret|q}
 @@ test_it "print(\"World, こんにちは!\")"
    cmd_gen

(* Testing executions and type-checking *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "print_bool(not (read_bool()))"
    cmd_run;
  expect_fail @@ test_command_stdin "100\n" [execf]

let _ =
 expect ""
 @@ test_it "print_bool(not (read_bool()))"
    cmd_run;
  expect "true\nDone" @@ test_command_stdin "false\n" [execf]

let _ =
 expect ""
 @@ test_it "print_bool(not (read_bool()))"
    cmd_run;
  expect_fail @@ test_command_stdin "truee\n" [execf]

let _ =
 expect ""
 @@ test_it "print_bool(not (read_bool()))"
    cmd_run;
  expect "false\nDone" @@ test_command_stdin "true\n" [execf]

let _ =
 expect ""
 @@ test_it "print(\"World, こんにちは!\")"
    cmd_run;
  expect "World, こんにちは!\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 let val x := random(10,15) val y := random(10,15) in 
 print_bool(10 <= x & x < 15 & 10 <= y & y < 15 & x <> y) end|q}
    cmd_run;
  expect "true\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 let val x := seed(20); random(10,15) val y := seed(20); random(10,15) in 
 print_bool(10 <= x & x < 15 & x = y) end|q}
    cmd_run;
  expect "true\nDone" @@ test_command [execf]



(* Ex 26, 27 *)
let _ =
  expect ""
  @@ test_it "print_bool(\"a\" = \"a\")"
     cmd_run;
   expect "true\nDone" @@ test_command_stdin "100\n" [execf]

let _ =
  expect ""
  @@ test_it "print_bool(\"11\" <= \"2\")"
     cmd_run;
   expect "true\nDone" @@ test_command_stdin "100\n" [execf]
let () = print_endline "All Done"

;;

