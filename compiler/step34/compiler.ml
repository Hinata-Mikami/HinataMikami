(* An extension to the compiler
*)

include Compiler_33
let (let*) = Qna.(let*)

let empty : repr = Qna.ans (Ty.void, CG.empty)

let seq : repr -> repr -> repr = fun e1 e2 -> 
  let* (ty1,blk1) = e1 in
  let* (ty2,blk2) = e2 in
  Ty.check_type Ty.void ty1 ~msg:": in seq operation";
  Qna.ans (ty2, Sq.(blk1 @ blk2))


(* Add a question about a mutability of a variable
   and about the type of a function.
 *)
module MutQ = 
  Qna.Que.Make(struct type hname = vname 
                      type res = CG.vreg option
                      let error_msg = Types.type_error "unbound variable %s"
               end)

module FunQ = 
  Qna.Que.Make(struct type hname = vname 
                      type res = (Asm.symbol * Ty.function_t)
                      let error_msg = Types.type_error "unbound function %s"
               end)

let mutble : vname -> CG.vreg option Qna.t = 
  fun n -> Qna.que (MutQ.hole n)
let funq   : vname -> (Asm.symbol * Ty.function_t) Qna.t = 
  fun n -> Qna.que (FunQ.hole n)

(* We now also answer mutability questions *)
let local ?(mut=false) ((name:vname),(exp:repr)) (body:repr) : repr =
  let* (ty,blk) = exp in
  if Ty.(eq ty void) then Ty.type_error 
      "Attempt to bind variable %s to an expression of void type" name;
  let (v,loc)  = CG.new_loc () in
  Qna.handle (Qna.Que.compose (VarQ.plug (name,(ty, loc)))
                              (MutQ.plug (name, if mut then Some v else None)))
      body
    |> Qna.lift1 @@ fun (tyb,resb) -> (tyb, CG.(local (v,blk) resb))

(* If the atom is a variable name we
    check if this is a mutable variable.
    How do we know if it is an variable? We listen for variable
    messages during type-checking
*)
let get_vars : atom -> (vname option * C.atom) Qna.t = function
  | A x -> A (None,x)
  | Q (n,k) -> match n with
    | VarQ.H vn -> Q (n, k >> Qna.lift1 (fun x -> (Some vn,x)))
    | _         -> Q (n, k >> Qna.lift1 (fun x -> (None,x)))

(*
Should generalize to
let get_vars : 'a Qna.t -> (vname option * 'a) Qna.t
*)
  

let local_atom ((name:vname),(a:atom)) (body:repr) : repr =
  let* (vn,a) = get_vars a in
  let* mut = match vn with Some n -> mutble n | _ -> Qna.ans None in
  if mut<>None then local (name, atomic (Qna.ans a)) body else
    local_atom (name, Qna.ans a) body

let assign : vname -> repr -> repr = fun name exp ->
  let* (ety,blk)  = exp in
  let* (vty,atom) = var name in
  Ty.check_type ety vty ~msg:": in assignment";
  let* mut = mutble name in
  match mut with
  | Some v -> Qna.ans (Ty.void, CG.store blk v)
  | None   -> Ty.type_error "assignment to an immutable var %s" name

(* call with no arguments *)
let call0 : vname -> repr = fun name -> 
  let* (linkname,(argty,resty)) = funq name in
  match argty with
  | [] -> Qna.ans (resty, CG.call0 linkname)
  | _ -> Ty.type_error "Function %s needs arguments, but none are given" name

(* Call with at least one argument *)
let call : vname -> repr -> atom list -> repr = fun name arg1 args ->
  let* (ty1,blk1) = arg1 in
  Qna.lift_list args @@ fun atoms ->
    let (tys, atoms) = List.split atoms in
    let given_types = ty1::tys in
    let* (linkname,(argtys, retty)) = funq name in
    if List.length argtys <> List.length given_types then
      Ty.type_error "Function %s needs %d arguments but given %d"
        name (List.length argtys) (List.length given_types);
    List.iter2 (fun tyn tyg -> 
      Ty.check_type tyn tyg ~msg:(": for application of " ^ name)) 
      argtys given_types;
    Qna.ans (retty, CG.call linkname blk1 atoms)


(* Answering the questions about global variables and detecting unbound ones
   There is no longer a global variable "x"
   OTH, there are global functions
*)

let observe : repr -> obs = 
  Qna.handle (FunQ.plugs Globals.global_fns) >> 
  Qna.top_hand (Qna.Que.compose 
                  (Qna.Que.compose VarQ.error MutQ.error) FunQ.error)
  >> (fun (ty,blk) ->
    Ty.check_type Ty.void ty ~msg:": the whole program must have void type";
    CG.observe blk)


