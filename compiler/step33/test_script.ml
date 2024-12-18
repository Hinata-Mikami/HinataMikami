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

(* identifiers starting with an underscore aren't allowed in user input 
   (Fixing the bug identified by a student in 2022)
*) 
let _ = 
  expect_fail @@ test_it "let val __t_1 := x + 3 in __t_1 * (__t_1 - 1) end"
  cmd_parse

let _ =
  expect "(let [__t_2,(let [__t_1,(neg 3)] (add x __t_1))] (add 1 __t_2))"  
  @@ test_it "1 + (x + - 3)" cmd_parse

let _ = 
  expect "(let [__t_1,(neg 3)] (add (add 1 x) __t_1))" @@ 
  test_it "1 + x + - 3" cmd_parse

(* = is non-associative, so cannot be repeated without parentheses *)
let _ = 
  expect_fail @@ test_it "1=2=3" 
  cmd_parse


let _ = 
  expect "(let [__t_1,(eq 2 3)] (eq 1 __t_1))" @@ test_it "1=(2=3)" 
  cmd_parse

(* Now accepted! *)
let _ = 
  expect "(add (let [__t_1,x] (add 1 __t_1)) 3)" @@ test_it "(1 + (x)) + 3" cmd_parse

let _ = 
  expect "(add (add 1 x) 3)" @@ test_it "(1 + x+ 3)" cmd_parse

let _ = 
  expect "(let [y,(sub 1 x)] (let [z,(mul 4 y)] (let [__t_1,(add y z)] (eq (add 10 x) __t_1))))"
  @@ test_it "let val y := 1-x\n val z :=4*y in 10+x=y+z end" 
       cmd_parse


(* lots of temporaries are produced *)
let _ = 
  expect "(let [y,(add 1 x)] (let [z,(add 4 y)] (let [__t_1,(add y z)] (add (add 10 x) __t_1))))"
 @@ test_it "let val y := 1+x\n val z :=4+y in (10+x)+(y+z) end" cmd_parse

let _ = 
 expect "(let [y,(add 1 x)] (let [z,y] (let [__t_1,(add y z)] (add (add 10 x) __t_1))))"
 @@ test_it "let val y := 1+x\n val z := y in (10+x)+(y+z) end" cmd_parse


(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

(* Opportunity for better register allocation *)
let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$40, %rsp
	movq	$1, %rax
	addq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	$2, %rax
	addq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	$4, %rax
	addq	8(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	8(%rsp), %rax
	addq	16(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	$10, %rax
	addq	%rdi, %rax
	addq	24(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$40, %rsp
	ret|q}
 @@ test_it "let val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z :=4+y in 10+x+(y+z) end"
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.globl	_ti_main
_ti_main:
	subq	$24, %rsp
	movq	$1, %rax
	addq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	$2, %rax
	addq	(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	8(%rsp), %rax
	addq	8(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	$10, %rax
	addq	%rdi, %rax
	addq	16(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it "let val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z := y in 10+x+(y+z) end"
    cmd_gen
(*
let (s,_) = test_it
let _ = print_endline s
*)


(* Testing executions and type-checking *)

let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "1 + (x + - 3)"
    cmd_run;
  expect "98\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "1 + x + - 3"
    cmd_run;
  expect "98\nDone" @@ test_command [execf; "100"]

(* Now allowed! *)
(* Problematic! Optional exercise
let _ =
 expect ""
 @@ test_it "((1 + 9223372036854775800 + 2) + 3)"
    cmd_run;
  expect "9223372036854775806\nDone" @@ test_command [execf; "100"]
*)

(* precedence and associativity tests *)
let _ =
 expect ""
 @@ test_it "1 + x * 3"
    cmd_run;
  expect "301\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "1 + x * 3 - 1+x*2"
    cmd_run;
  expect "500\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "1 - x - x + 5"
    cmd_run;
  expect "-194\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "let val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z :=4+y in 10+x+(y+z) end"
    cmd_run;
  expect "320\nDone" @@ test_command [execf; "100"]

let _ =
 expect ""
 @@ test_it "let val y := \
    let val y1 := 1 + x in 2 + y1 end \
    val z := y in 10+x+(y+z) end"
    cmd_run;
  expect "316\nDone" @@ test_command [execf; "100"]


let () = print_endline "All Done"

;;


