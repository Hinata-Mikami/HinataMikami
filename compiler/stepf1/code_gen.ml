(* Extended code generator *)

include Code_gen_3

(* The older make_function should also make local functions

   Local function code typically appears
   in assembly separate from the code of the main function.
   We can solve it in two ways: generalize sequence or use extensible
   effects. Here we chose the former, as it seems simpler.
   Hence the sequence for a local function is designated as a note
*)
let make_function ?(locals=0) ?(local_fun=false) 
    (nm:Asm.symbol) (body:repr) : repr =
  let stack_adj = 8 * if locals mod 2 = 0 then locals + 1 else locals in
  let open Sq in
  snocs Asm.[
   start_function ~local_fun nm;
   label nm;
   subq (imm (Int64.of_int stack_adj)) (reg rsp)] empty @
   body |>
   snocs Asm.[
   addq (imm (Int64.of_int stack_adj)) (reg rsp);
   ret] |>
   if local_fun then Sq.as_note else Fun.id

(* Converting the function name to a unique local symbol.
   This conversion does not depend on the type, but it could, in the future.
*)

let local_fun_name : Lang.vname -> Asm.symbol = fun name ->
  Util.gensym name |> Asm.name ~local:true

(* The first part of buiding a function is to deal with arguments.
   This function takes the list of argument types and builds the
   list of corresponding reprs. These reprs are *not* atoms, because
   they contain argument registers such as rdi (actually, currently the code
   to move from that register to rax, but that could be optimized later).
   Registers are not freely subsitutable in any context: may be overwritten
   in the context. OTH, immediates or memory locations (which are known
   as immutable) are freely substitutable and are atoms.

   For int and bool types, the arguments (until some number)
   are in general-purpose registers. For more detail, see the calling
   convenstions of the ABI. So, this function implements the argument-passing
   part of the calling convenions (ABI).

   The biggest problem was the sin from the past: too simple memory allocation,
   via a global counter vreg_cnt (in ../step31/code_gen.ml ).
   Local functions need their own counter.
 *)

let fundecl : Asm.symbol -> Types.function_t -> 
   ((repr -> repr) -> ('a -> 'a)) -> (repr list -> 'a) -> 'a 
   = fun link_name (args,ret_ty) xmap bodyk ->
  let rec loop tys regs = match (tys,regs) with
  | ([],_) -> []
  | (_,[]) -> Util.fail "The function is defined with %d arguments: too many"
        (* name *) (List.length args)
  | (ty::tys, r::regs) when 
      List.exists (Types.eq ty) Types.[int;bool;string] ->
      Sq.one Asm.(movq (reg r) (reg rax)) :: loop tys regs
  | (ty::_, _) -> Util.fail "Unsupported argument type %s" (Types.to_string ty) 
  in 
  loop args Asm.reg_arguments |> bodyk |>
  (* 
   Since repr by our convention eventually puts the result (if any) in rax,
   which is used for returning the result, we don't need to do anything extra.
   Things will change when we add floats and have functions returning floats.
  *)  
  xmap (fun body ->
    let vars = Sq.get_annot body in
    let locals = List.length vars in
    Sq.set_annot [] body |>
    Sq.map (Asm.substitute_pseudo_op (allocate vars)) |>
    make_function ~local_fun:true ~locals link_name)
