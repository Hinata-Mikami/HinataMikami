(* Code generation, extension of code_gen_23.ml 
   The main extension is working space, or virtual register, or
   locations
*)

open Util

module CG = Code_gen_23                  (* old code generator *)
include CG


type vreg = Vreg.vreg

module H = 
  Sq.Hole.Make(struct type hname = vreg 
                      type res = Asm.operand
                      let error_msg = Util.fail "unbound variable %d"
               end)

(* Atom denotes an operand: a SRC operand
   An atom can also be a hole: not-yet allocated location. That's why
   we need the continuation type for it
*)
type atom = (Asm.operand -> Asm.instr list) -> repr -> repr

(* 
  Think of type repr as representing the program (as we shall see,
  it represents a block). Therefore, it must not be duplicated.
  It should be used linearly.
  OTH, atom can be freely duplicated.
*)

let op_atom : Asm.operand -> atom = fun op k seq -> snocs (k op) seq 
let int (x : int64) : atom = CG.int x  |> op_atom
let bool (x : bool) : atom = CG.bool x |> op_atom

let varx : atom = CG.varx |> op_atom

let with_operand : (Asm.operand -> Asm.instr list) -> repr -> atom -> repr =
  fun k seq a -> a k seq

let atomic : atom -> repr = fun a ->
  with_operand Asm.(fun op -> [movq op (reg rax)]) Sq.empty a

let add : repr -> atom -> repr = 
  with_operand Asm.(fun op -> [addq op (reg rax)])

let hole : vreg -> atom = fun n k seq ->
  Sq.(seq @ (hole (H.hole n) k |> annotate (Vreg.one n)))


let genvreg : unit -> vreg = 
  let cnt = ref 0 in
  fun () -> let v = !cnt in incr cnt; v

let new_loc : unit -> (vreg * atom) = fun () ->
  let vr = genvreg () in
  (vr,hole vr)

(* if vreg does not appear in attr.used, there is no need to allocate 
   memory for it.
   (TODO If the binding expr is pure, there is no need to evaluate it)
   See bind_reg in step40: should have expressed in terms of that
 *)
let bind : vreg * repr -> repr -> repr = fun (v,exp) body ->
  let (@) = Sq.(@) in
  match Sq.get_annotation body with
  | {used} when Vreg.S.find_opt v used = None ->
      exp @ body (* no binding *)
  | _ ->
      let body' = hole v Asm.(fun op -> [movq (reg rax) op]) Sq.empty @ body in
      match Sq.get_annotation body' with
      | {used;defined} -> 
          let used = Vreg.S.remove v used in
          let defined = (v,used) :: defined in
          exp @ Sq.annotate {used; defined} body'

(* store the result of repr in an vreg
   TODO: define a type for locations?
   TODO: here it would be good to change repr to track where the result is
   (rax or elsewhere) or even if there is a result.
   For example, after the store there isn't really a result.
   So, we should report an error if we use the store'd repr in an addition!
 *)
let store : repr -> vreg -> repr = fun seq vr ->
  with_operand Asm.(fun op -> [movq (reg rax) op]) seq (hole vr) 

(* Convert an index of a stack-allocated variable to its location
   on stack
 *)
(* TODO: if loc is a small number, use a scratch register instead of
   stack! But beware of function calls that may destroy scratch registers!
   TODO: should return an atom! So we can easily generalize
   to parent-scope refs
*)
let temp_location : int -> Asm.operand = fun i ->
  Asm.(stack_rel (i * 8))

(* Same as before
type obs = out_channel -> unit     (* observation type *)
*)

(* very dumb allocation 
   TODO: alocation should return an atom! So we can easily generalize
   to parent-scope refs
*)
let allocate : (vreg * Vreg.S.t) list -> (int * (vreg * Asm.operand) list) =
  fun l ->
    let n = List.length l in
    (n, List.map2 (fun (v,_) i -> (v,temp_location i)) l
        (List.init n Fun.id))

let allocate_resolve : repr -> (int * Sq.Hole.plug) = fun seq -> 
  let (locals,env) = 
    allocate (match Sq.get_annotation seq with 
              {used;defined} -> if Vreg.S.is_empty used then defined 
                 else Util.fail "unbound variable %d" (Vreg.S.choose used))
  in
  (locals, H.plugs env)

let observe : repr -> obs = fun seq ch ->
  let (locals,resolver) = allocate_resolve seq in
  make_function ~locals (Asm.name "ti_main") seq |>
  Sq.iter ~resolver (Asm.print ch)
