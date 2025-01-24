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

(* no space before function name and paren *)
let _ = 
  expect_fail 
  @@ test_it "let function foo () = () in () end"
  cmd_parse

let _ = 
  expect "(letfun (foo():void ()) ())" 
  @@ test_it "let function foo() = () in () end"
  cmd_parse

let _ = 
  expect "(letfun (foo():int 1) ())" 
  @@ test_it "let function foo():int = 1 in () end"
  cmd_parse

let _ = 
  expect "(letfun (add(x:int,y:int):int (add x y)) (call add 1 2))" 
  @@ test_it "let function add(x:int,y:int):int = x+y in add(1,2) end"
  cmd_parse


let _ = 
  expect "(let [*x,1] (letfun (get():int x) (letfun (set(v:int):void (assign x v)) (seq (call set 5) (call0 get)))))"
  @@ test_it {q|let
  var x := 1
  function get() : int = x
  function set(v:int) = x := v
  in 
  set(5); get()
  end|q}
  cmd_parse

let _ = 
  expect "(letfun (test(c:int):int (let [*x,c] (letfun (get():int x) (letfun (set(v:int):void (assign x v)) (seq (call set 5) (call0 get)))))) (call print_int (call test 1)))"
  @@ test_it {q|let
  function test(c: int):int =
  let
  var x := c
  function get() : int = x
  function set(v:int) = x := v
  in 
  set(5); get()
  end
  in
  print_int(test(1))
  end|q}
  cmd_parse


(* Testing code generation *)
let cmd_gen fname = [tigerc; "--dump-asm"; fname]

let _ = 
  expect_fail 
  @@ test_it {q|let
  function add(x: xxx, y: int): int = x + y
 in () end|q}
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it {q|let
  function add(x: int, x: int): int = x + x
 in () end|q}
  cmd_gen


(* number of arguments *)
let _ = 
  expect_fail 
  @@ test_it {q|let
  function g(a: int, b: string): int = a in
  g("one") end|q}
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it {q|let
  function g(a: int, b: string): int = a in
  g(3, "one", 5)end|q}
  cmd_gen


let _ = 
  expect_fail 
  @@ test_it {q|let
  function g(a: int, b: string): int = a in
  g("one", "two") end|q}
  cmd_gen

let _ = 
  expect_fail 
  @@ test_it {q|let
  function foo(): int = "abc"
 in () end|q}
  cmd_gen

(* the simplest function *)
let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.type	foo_1, @function
foo_1:
	subq	$8, %rsp
	addq	$8, %rsp
	ret
	.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	addq	$8, %rsp
	ret|q}
 @@ test_it "let function foo() = () in () end"
    cmd_gen


let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.type	add_1, @function
add_1:
	subq	$24, %rsp
	movq	%rdi, %rax
	movq	%rax, 8(%rsp)
	movq	%rsi, %rax
	movq	%rax, (%rsp)
	movq	8(%rsp), %rax
	addq	(%rsp), %rax
	addq	$24, %rsp
	ret
	.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	movq	$1, %rax
	movq	%rax, %rdi
	movq	$2, %rsi
	call	add_1
	movq	%rax, %rdi
	call	print_int
	addq	$8, %rsp
	ret|q}
 @@ test_it "let function add(x:int,y:int):int = x+y in print_int(add(1,2)) end"
    cmd_gen

(* nested functions *)
let _ =
  expect_fail
 @@ test_it {q|
   let function foo1(x:int):int =
       let function foo2(y:int):int = y + 1 in
       foo1(x+1) * foo2(x+2) end
   in
   print_int(foo2(10))
   end|q}
    cmd_gen

let _ =
  expect_fail
 @@ test_it {q|
   let function foo1(x:int):int =
       let function foo2(y:int):int = y + 1 in
       foo2(x+1) * foo2(x+2) end
   in
   print_int(foo2(10))
   end|q}
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.type	foo2_2, @function
foo2_2:
	subq	$8, %rsp
	movq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	addq	$8, %rsp
	ret
	.text
	.type	foo1_3, @function
foo1_3:
	subq	$24, %rsp
	movq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$2, %rax
	movq	%rax, %rdi
	call	foo2_2
	movq	%rax, 8(%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	foo2_2
	imulq	8(%rsp), %rax
	addq	$24, %rsp
	ret
	.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$8, %rsp
	movq	$10, %rax
	movq	%rax, %rdi
	call	foo1_3
	movq	%rax, %rdi
	call	print_int
	addq	$8, %rsp
	ret|q}
 @@ test_it {q|
   let function foo1(x:int):int =
       let function foo2(y:int):int = y + 1 in
       foo2(x+1) * foo2(x+2) end
   in
   print_int(foo1(10))
   end|q}
    cmd_gen

let _ =
  expect ~comparator:comparator_asm
 {q|.text
	.type	adder_2, @function
adder_2:
	subq	$8, %rsp
	movq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$1, %rax
	addq	$8, %rsp
	ret
	.text
	.type	adder_1, @function
adder_1:
	subq	$8, %rsp
	movq	%rdi, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$2, %rax
	addq	$8, %rsp
	ret
	.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
	subq	$24, %rsp
	movq	$3, %rax
	movq	%rax, %rdi
	call	adder_2
	movq	%rax, 8(%rsp)
	movq	$3, %rax
	movq	%rax, %rdi
	call	adder_1
	movq	%rax, (%rsp)
	movq	8(%rsp), %rax
	addq	(%rsp), %rax
	movq	%rax, %rdi
	call	print_int
	addq	$24, %rsp
	ret|q}
 @@ test_it {q|
 let
   function adder(x: int): int = x + 1
   val v1 := adder(3)
   function adder(x: int): int = x + 2
   val v2 := adder(3)
 in
  print_int(v1+v2)
 end|q}
    cmd_gen

(* Testing executions and type-checking *)
let cmd_run fname = [tigerc; "-o"; execf; fname]

let _ =
 expect ""
 @@ test_it "let function foo() = () in () end"
    cmd_run;
  expect "Done" @@ test_command [execf]


let _ =
 expect ""
 @@ test_it "let function add(x:int,y:int):int = x+y in print_int(add(1,2)) end"
    cmd_run;
  expect "3\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
 let
   function adder(x: int): int = x + 1
   val v1 := adder(3)
   function adder(x: int): int = x + 2
   val v2 := adder(3)
 in
  print_int(v1+v2)
 end|q}
    cmd_run;
  expect "9\nDone" @@ test_command [execf]


let _ =
 expect ""
 @@ test_it {q|
   let function foo1(x:int):int =
       let function foo2(y:int):int = y + 1 in
       foo2(x+1) * foo2(x+2) end
   in
   print_int(foo1(10))
   end|q}
    cmd_run;
  expect "156\nDone" @@ test_command [execf]

let _ =
 expect ""
 @@ test_it {q|
   let function foo(x:string):bool = x = "abc"
   in
   print_bool(foo("x"))
   end|q}
    cmd_run;
  expect "false\nDone" @@ test_command [execf]

(* TODO
let _ =
 expect ""
 @@ test_it {q|
     let
       function square(x: int): int = x * x
       function sum_of_squares(x: int, y: int): int = square(x) + square(y)
       in print_int(sum_of_squares(2, 3))
   end|q}
    cmd_run;
  expect "13\nDone" @@ test_command [execf]
*)

let () = print_endline "All Done"

;;


