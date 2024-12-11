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
