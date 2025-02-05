(* Code generation, extension of code_gen_23.ml 

   This is the re-implementation of step31/code_gen.ml
   which was very naive.

   It is time to pay for our sins: using global state for
   memory allocation. Local functions have their own allocation,
   therefore, global state won't suffice.

   The most reliable idea is to delay allocation. We represent cells
   by virtual registers, which we can allocate monotonously.
   For which, a global counter would work fine.
   Later, we map virtual registers to stack cells (or registers, or both).
   This can be done locally.

   This file uses a very, very naive memory allocation
   which allocates a qword on stack for each let-bound variable, which
   is quite more than it is really needed.
*)

include Code_gen_23                  (* old code generator *)

type vreg = int                         (* A memory location, or `register' *)

let genvreg : unit -> vreg = 
  let vreg_cnt = ref 0 in
  fun () -> let v = !vreg_cnt in incr vreg_cnt; v

(* Allocating a pseudo-operand, which needs to be substituted
   with a proper memory location later, when we did the allocation
 *)
let hole : vreg -> atom = fun i ->
  Asm.pseudo_operand i

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
  Sq.(store exp v @ body) |> Sq.add_annot v

(* Eager allocation of stack space for the vreg
   This is very naive.
*)

let allocate : vreg list -> (vreg * Asm.operand) list = fun l ->
  List.fast_sort Int.compare l |>
  List.map2 (fun l i -> (i,Asm.stack_rel (l*8)))
    (List.init (List.length l) Fun.id)

let observe : repr -> obs = fun seq ch ->
  let vars = Sq.get_annot seq in
  let locals = List.length vars in
  make_function ~locals (Asm.name "ti_main") seq |>
  Sq.iter (fun i -> Asm.substitute_pseudo_op (allocate vars) i |>
                    Asm.print ch)
