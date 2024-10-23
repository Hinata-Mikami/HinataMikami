(* The very first version of the compiler
   It takes an input stream (which could be stdin)
   and produces the the assembly code file
   in the given output stream (could be stdout)
*)

(* Write type signatures of all top-level functions!!
   I insists!
*)

(*
let compile : in_channel -> out_channel -> unit = fun ich och ->
*)

(* Note: if % in the argument to printf has to be printed literally,
   it has to be doubled.
*)
let compile (ich:in_channel) (och:out_channel) : unit =
  Scanf.fscanf ich "%d" @@ fun n ->
  Printf.fprintf och {q|
	.text
	.globl	ti_main
 	.type	ti_main, @function
 ti_main:
	subq	$8, %%rsp
	movq	$%d, %%rdi
	call	print_int
	addq	$8, %%rsp
	ret
 |q} n

;;

(* It is most straightforward. It can be tested right away. 
  compile stdin stdout
  54
*)

