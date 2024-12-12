(* Code generation, extension of code_gen_23.ml 

   This file uses a very, very naive memory allocation
   which allocates a qword on stack for each let-bound variable, which
   is quite more than it is really needed.

   It has lots of other simplifications, which we will come to regret.
*)

include Code_gen_23                  (* old code generator *)

type vreg = int                         (* A memory location, or `register' *)

let vreg_cnt = ref 0                    (* Exposing the counter. Not good! *)
let genvreg : unit -> vreg = 
  fun () -> let v = !vreg_cnt in incr vreg_cnt; v

(* Eager allocation of stack space for the vreg
   This is very naive.
   But simple, though, and easy to explain
*)
let hole : vreg -> atom = fun i ->
  Asm.(stack_rel (i * 8))

let new_loc : unit -> (vreg * atom) = fun () ->
  let vr = genvreg () in
  (vr,hole vr)

(* store the result of repr (which is in rax) in an vreg *)
let store : repr -> vreg -> repr = fun seq vr ->
  snoc Asm.(movq (reg rax) (hole vr)) seq

(* introduce a new binding: store the value of the expression in
   vreg
 *)
let local : vreg * repr -> repr -> repr = fun (v,exp) body ->
  Sq.(store exp v @ body)


let observe : repr -> obs = fun seq ch ->
  (* Such use of global state is very bad, and we'll come to regret it.
     Often times the most straightforward thing is no good.
     But it takes time to recognize.
  *)
  let locals = !vreg_cnt in
  make_function ~locals (Asm.name "ti_main") seq |>
  Sq.iter (Asm.print ch)


(* Comparison and arithmetic operations *)

let equal : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi); (* Load second operand into %rdi *)
    cmpq (reg rdi) (reg rax); (* Compare %rax and %rdi *)
    sete (reg al); (* Set AL to 1 if equal *)
    movzb (reg al) (reg rax) (* Move result to %rax *)
  ] lhs

let ne : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    cmpq (reg rdi) (reg rax);
    setne (reg al); (* Set AL to 1 if not equal *)
    movzb (reg al) (reg rax)
  ] lhs

let lt : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    cmpq (reg rdi) (reg rax);
    setl (reg al); (* Set AL to 1 if less than *)
    movzb (reg al) (reg rax)
  ] lhs

let le : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    cmpq (reg rdi) (reg rax);
    setle (reg al); (* Set AL to 1 if less than or equal *)
    movzb (reg al) (reg rax)
  ] lhs

let mt : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    cmpq (reg rdi) (reg rax);
    setg (reg al); (* Set AL to 1 if greater than *)
    movzb (reg al) (reg rax)
  ] lhs

let me : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    cmpq (reg rdi) (reg rax);
    setge (reg al); (* Set AL to 1 if greater than or equal *)
    movzb (reg al) (reg rax)
  ] lhs

let minus : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    subq (reg rdi) (reg rax) (* Subtract %rdi from %rax *)
  ] lhs

let times : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    imulq (reg rdi) (reg rax) (* Multiply %rax by %rdi *)
  ] lhs

let div : repr -> atom -> repr = fun lhs rhs ->
  snocs Asm.[
    movq rhs (reg rdi);
    cqto; (* Sign extend RAX into RDX:RAX for division *)
    idivq (reg rdi) (* Divide RDX:RAX by %rdi; result in %rax *)
  ] lhs
