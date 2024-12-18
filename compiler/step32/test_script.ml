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

let _ = 
  expect "(let [y,(let [__t_1,x] (sub 1 __t_1))] (let [z,(let [__t_2,y] (mul 4 __t_2))] (let [__t_5,(let [__t_4,z] (add y __t_4))] (eq (let [__t_3,x] (add 10 __t_3)) __t_5))))" 
  @@ test_it "let val y := 1-x\n val z :=4*y in 10+x=y+z end" 
       cmd_parse

let _ = 
  expect "(let [y,(let [__t_1,x] (sub 1 __t_1))] (let [z,(let [__t_2,y] (mul 4 __t_2))] (let [__t_4,y] (eq (let [__t_3,x] (add 10 __t_3)) __t_4))))" 
  @@ test_it "let val y := 1-x\n val z :=4*y in 10+x=y end" 
       cmd_parse

let _ = 
  expect_fail @@ test_it "1=2=3" 
  cmd_parse

let _ = 
  expect "(let [__t_2,3] (eq (let [__t_1,2] (eq 1 __t_1)) __t_2))" @@ test_it "(1=2)=3" 
  cmd_parse

let _ = 
  expect "(let [__t_2,(let [__t_1,3] (eq 2 __t_1))] (eq 1 __t_2))" @@ test_it "1=(2=3)" 
  cmd_parse

let _ = 
  expect "(let [__t_2,3] (lt (let [__t_1,2] (leq 1 __t_1)) __t_2))" @@ test_it "(1<=2)<3" 
  cmd_parse

let _ = 
  expect "(let [__t_2,true] (lt (let [__t_1,2] (leq 1 __t_1)) __t_2))" @@ test_it "(1 <=2 )< true" 
  cmd_parse

let _ = 
  expect "(let [__t_2,3] (sub (let [__t_1,2] (mul x __t_1)) __t_2))" @@ test_it "x*2- 3" 
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
	subq	$24, %rsp
	movq	$1, %rax
	movq	%rax, 8(%rsp)
	movq	$2, %rax
	movq	%rax, (%rsp)
	movq	$1, %rax
	cmpq	(%rsp), %rax
	setle	%al
	movzb	%al, %rax
	cmpq	8(%rsp), %rax
	setl	%al
	movzb	%al, %rax
	movq	%rax, %rdi
	call	print_bool
	addq	$24, %rsp
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


