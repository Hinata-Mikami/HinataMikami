open Syntax_cbn

exception Error of string

(* let rec make_ERLetAnd_env (expl : (name * name * expr) list) (env : env) : env =
  match expl with
  | [] -> env
  | (f, x, e1) :: rest -> (f, Thunk (EFun (x, e1), env)) :: (make_ERLetAnd_env rest env)
   *)
let rec make_thunk (exp : expr) (env : env) : thunk =
  match exp with
  | ELiteral x -> Thunk (ELiteral x, env) 
  | EBin (op, e1, e2) -> Thunk ((EBin (op, e1, e2)), env)
  | EIf (e1, e2, e3) ->
    (match e1 with
    | ELiteral (LBool b) -> if b then Thunk (e2, env) else Thunk (e3, env)
    | _ -> raise (Error "Eval-CBN Error : Unexpected if syntax") 
    )
  | ELet (n, e1, e2) -> Thunk (e2, (n, Thunk (e1, env)) :: env)
  | EVar n ->(try List.assoc n env 
              with Not_found -> raise (Error "Eval-CBN Error : Variable not found"))
  | EApp (e1, e2) -> 
    (match e1 with
    | EFun (n, e1) -> Thunk (e2, (n, Thunk (EFun (n, e1), env)) :: env)
    (* | ERLetAnd (expl, e) -> 
      let env' = make_ERLetAnd_env expl env in
     *)
    | _ -> raise (Error "Eval-CBN Error : No-Function expression cannot be applied")
    )
  (* | ERLetAnd (expl, e) ->
    let env' = make_ERLetAnd_env expl env in
    Thunk (e, env') *)
  | ETuple (e1, e2) -> Thunk (ETuple (e1, e2), env)
  | ECons (e1, e2) -> Thunk (ECons (e1, e2), env)
  | ENil -> Thunk (ENil, env)
  (* | EMatch (e, plist) -> *)
  | _ -> raise (Error "")

  let value_of_literal (l:  literal) : value = 
  match l with
  | LInt i -> VInt i 
  | LBool b -> VBool b

  let rec value_of_thunk (th : thunk) : value =
    match th with
    | Thunk (exp, env) -> 
      (match make_thunk exp env with
      | Thunk (ELiteral x, _) -> value_of_literal x
      | _ as th' -> value_of_thunk th'
      )
    | _ -> raise (Error "") 

  let eval_cbn (exp : expr) (env : env) : value = 
    value_of_thunk (make_thunk exp env)