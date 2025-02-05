(* An extension to the compiler
*)

include Compiler_3

type tname = string

(* typically the list is short *)
let rec check_duplicates : vname list -> unit = function
  | [] | [_] -> ()
  | [x;y] -> if x = y then Ty.type_error "duplicate arg name: %s" x
  | x::t  -> if List.mem x t then (Ty.type_error "duplicate arg name: %s" x)
        else check_duplicates t

(* Update CG.repr buried somehow within repr *)
let map_cg_repr : (CG.repr -> CG.repr) -> (repr -> repr) = fun f ->
   Qna.lift1 (fun (ty,blk) -> (ty, f blk))

(* We need to let-bind the arguments to allocate space for them.
   If we don't do that, the rdi (which holds argument 0) will be overridden
   when we call any function of non-zero arity. 

  Note how the implementation follows the typing rules (with one exception
  though. Can you see which?)
 *)

 let fundecl : vname -> ((vname*tname) list * tname) -> repr -> repr -> repr =
  fun name (args,ret) body rest ->
    let argnames = List.map fst args in
    check_duplicates argnames;
    let ret_ty = Ty.of_string ret in
    let argtypes = List.map (fun (_,tname) -> Ty.of_string tname) args in 
    let funtype = (argtypes, ret_ty) in
    let link_name = CG.local_fun_name name in
    let* (ty,body_blk) = CG.fundecl link_name funtype map_cg_repr @@ begin
    fun argreprs -> 
      let args = 
        List.map2 (fun x y -> (x,y)) argnames @@
        List.map2 (fun ty blk -> Qna.ans (ty,blk)) argtypes argreprs in
      let recursive_env = FunQ.plug (name, (link_name, funtype)) in (* Ex37  *)
      let argbody = Qna.handle recursive_env (List.fold_right local args body) in
      Qna.handle (Util.reduce Qna.Que.compose
            [FunQ.plugs Globals.global_fns; VarQ.error; MutQ.error; FunQ.error]) 
          argbody 
        end
      in
      Ty.check_type ty ret_ty ~msg:": inferred and declared return type";
      Qna.handle (FunQ.plug (name,(link_name,funtype))) rest |>
      map_cg_repr (Sq.(@) body_blk)

(* let fundecl : vname -> ((vname*tname) list * tname) -> repr -> repr -> repr =
  fun name (args,ret) body rest ->
    let argnames = List.map fst args in
    check_duplicates argnames;
    let ret_ty = Ty.of_string ret in
    let argtypes = List.map (fun (_,tname) -> Ty.of_string tname) args in
    let funtype = (argtypes, ret_ty) in
    let link_name = CG.local_fun_name name in
    let* (ty,body_blk) = CG.fundecl link_name funtype map_cg_repr @@ begin
    fun argreprs -> 
    (* list of bindings (vname * repr) where vname is an argument name
       and repr is the expression for its value (typically, this expression
       contains registers rdi, etc. -- unless arguments are too many
       and the expression is a stack location)
    *)
    let args = 
      List.map2 (fun x y -> (x,y)) argnames @@
      List.map2 (fun ty blk -> Qna.ans (ty,blk)) argtypes argreprs in
    (* Function body with let-bound arguments. The arguments are
       now bound and we can type-check the body
    *)
    let argbody = List.fold_right local args body in
    Qna.handle (Util.reduce Qna.Que.compose
          [FunQ.plugs Globals.global_fns; VarQ.error; MutQ.error; FunQ.error]) 
        argbody 
      end
    in
    Ty.check_type ty ret_ty ~msg:": inferred and declared return type";
    Qna.handle (FunQ.plug (name,(link_name,funtype))) rest |>
    map_cg_repr (Sq.(@) body_blk) *)


