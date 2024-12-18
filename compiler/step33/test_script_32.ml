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

(* It now parses differently
let _ = 
  expect "(let [y,(sub 1 x)] (let [z,(mul 4 y)] (add (eq (add 10 x) y) z)))" 
  @@ test_it "let val y := 1-x\n val z :=4*y in 10+x=y+z end" 
       cmd_parse
*)

let _ = 
  expect "(let [y,(sub 1 x)] (let [z,(mul 4 y)] (let [__t_1,(add y z)] (eq (add 10 x) __t_1))))" 
  @@ test_it "let val y := 1-x\n val z :=4*y in 10+x=y+z end" 
       cmd_parse

let _ = 
  expect "(let [y,(sub 1 x)] (let [z,(mul 4 y)] (eq (add 10 x) y)))" 
  @@ test_it "let val y := 1-x\n val z :=4*y in 10+x=y end" 
       cmd_parse

(* No longer parses *)
let _ = 
  expect_fail @@ test_it "1=2=3" 
  cmd_parse

let _ = 
  expect "(eq (eq 1 2) 3)" @@ test_it "(1=2)=3" 
  cmd_parse

(* Now, it succeeds *)
let _ = 
  expect "(let [__t_1,(eq 2 3)] (eq 1 __t_1))" @@ test_it "1=(2=3)" 
  cmd_parse

let _ = 
  expect "(lt (leq 1 2) 3)" @@ test_it "(1<=2)<3" 
  cmd_parse

let _ = 
  expect "(lt (leq 1 2) true)" @@ test_it "(1 <=2 )< true" 
  cmd_parse

let _ = 
  expect "(sub (mul x 2) 3)" @@ test_it "x*2- 3" 
  cmd_parse

(* Unary minus binds tighter *)
let _ = 
  expect_fail @@ test_it "x*2 -3" 
  cmd_parse

(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ = 
  expect_fail @@ test_it "1=2=3" 
  cmd_gen

let _ = 
  expect_fail @@ test_it "(1<=2)<3"
  cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$8, %rsp
	movq	$1, %rax
	cmpq	$2, %rax
	setle	%al
	movzb	%al, %rax
	cmpq	$1, %rax
	setl	%al
	movzb	%al, %rax
	movq	%rax, %rdi
	call	print_bool
	addq	$8, %rsp
	ret|q}
 @@ test_it "(1 <=2 )< true" cmd_gen

(*
let (s,_) = test_it
let _ = print_endline s
*)

(* Testing executions and type-checking *)

let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "(1 <=2 )< true"
    cmd_run;
  expect "false\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "(1 <=2 )<= true"
    cmd_run;
  expect "true\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "(x*2 - 3)"
    cmd_run;
  expect "197\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "(x*2 - 3) < x"
    cmd_run;
  expect "false\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "(x*2 - 3) < x"
    cmd_run;
  expect "true\nDone" @@ test_command [execf; "0"]

let () = print_endline "All Done"

;;

;;


