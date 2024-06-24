open Syntax_cbn

exception Error of string

let value_of_literal (l:  literal) : value = 
  match l with
  | LInt i -> VInt i 
  | LBool b -> VBool b

let rec eval (env : env) (expr : expr) : value =
  let eval_bin_op (env : env) (op : binOp) (e1 : expr) (e2 : expr) : value =
    let v1 = eval env e1 in
    let v2 = eval env e2 in
    match v1, v2 with
    | VInt x, VInt y ->
    ( match op with
      | OpAdd -> VInt (x + y)
      | OpSub -> VInt (x - y)
      | OpMul -> VInt (x * y)
      | OpDiv -> if y = 0 then raise (Error "Eval_Error : Zero_Division") else VInt (x / y)
      | OpEq -> VBool (x = y)
      | OpLt -> VBool (x < y))
    | _ -> raise (Error "Eval_Error : Unexpected expression on eval_bin_op")

  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr) : value =
    match eval env e0 with
    | VBool true -> eval env e1
    | VBool false -> eval env e2
    | _ -> raise (Error "Eval_Error : Unexpected expression on eval_if")

  in let lookup_variable (env : env) (x : name) : value =
    try
      let Thunk(exp, env) = List.assoc x env in
      eval env exp
    with
    | Not_found -> raise (Error "Eval_Error : Variable not found on lookup_variable")

  in let eval_let (env : env) (n : name) (e1 : expr) (e2 : expr) : value = 
    eval ((n, Thunk (e1, env)) :: env) e2
       
  in match expr with
      | ELiteral x -> value_of_literal x
      | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
      | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
      | EVar n -> lookup_variable env n
      | ELet (x, e1, e2) -> eval_let env x e1 e2
      | EFun (x, e) -> VFun (x, e, env)
      | EApp (e1, e2) -> 
        let v1 = eval env e1 in
        (match v1 with
        | VFun (x, e, oenv) -> eval ((x, Thunk(e, oenv)) :: oenv) e2
        (* | VRFunAnd (i, l, oenv) -> 
          (let rec make_env (j : int)  (l1 : (name * name * expr) list) : env =
            match l1 with
              | [] -> []
              | (fj, _, _) :: rest -> (fj, VRFunAnd(j, l, oenv)) :: make_env (j + 1) rest
          (*作成した環境を既存の環境oenvに追加*)
          in let nenv = (make_env 0 l) @ oenv
          (*i番目の要素を取り出す*)
          in let (f, x, e) = List.nth l i
          in eval ((x, v2) :: nenv) e) i番目の変数名と値v2を環境に追加したうえでeを評価 *)
        | _ -> raise (Error "EvalError : Non-function cannot be applied"))
      | ENil -> VNil        
      | ECons (e1, e2) -> VCons (Thunk (e1, env), Thunk (e2, env))
      | ETuple el -> VTuple (List.map (fun e -> Thunk (e, env)) el)
      (* (* | ERLetAnd (l, e) ->
        (*リストから環境を生成: (f0, VRFunAnd(0, l, env)), ... を生成*)
        let rec make_env (i: int) (l' : (name * name * expr) list) : env =
        match l' with
        | [] -> env
        | (f, x, e) :: rest -> (f, VRFunAnd(i, l, env)) :: (make_env (i + 1) rest) in
          let nenv = make_env 0 l  *)
        (*環境の下でeを評価*)
        in eval nenv e *)
      | _ -> raise (Error "still developing : eval") 

let eval_thunk (th : thunk) : value = 
  let Thunk (exp, env) = th in
  eval env exp

let rec find_match (p : pattern ) (v : value) (env : env): env option =
  match p, v with
  | PInt i1, VInt i2 -> if i1 = i2 then Some [] else None
  | PBool b1, VBool b2 -> if b1 = b2 then Some [] else None
  | PVar x, _ -> Some [(x, Thunk (EVar x, env))] 
  | PWild, _ -> Some [] 
  | PCons(ph, prest), VCons(vh, vrest)  ->
    let h = find_match ph (eval_thunk vh) env in 
    let rest = find_match prest (eval_thunk vrest) env in 
    (match h, rest with
      | Some env1, Some env2 -> Some (env1 @ env2) 
      | _ -> None)
  | PNil, VNil -> Some [] 
  | PTuple pl, VTuple thl ->
    (let rec match_tuple (pl:pattern list) (vl: value list) : env option =
    match pl, vl with
      | [], [] -> Some []
      | p :: prest , v :: vrest ->
        let h = find_match p v env in
        let rest = match_tuple prest vrest in
        (match h, rest with
          | Some env1, Some env2 -> Some (env1 @ env2)
          | _ -> None)
    in match_tuple pl (List.map(fun th -> eval_thunk th) thl))
  | _ -> None

let rec make_thunk (exp : expr) (env : env) : thunk =
  match exp with
  | ELiteral x -> Thunk (exp, env)
  | EBin (op, e1, e2) -> 
    (match op with
    | OpDiv -> 
      (match eval env e2 with
      | VInt 0 -> raise (Error "Zero-Division detected")
      | _ -> Thunk (exp, env)
      )
    | _ -> Thunk (exp, env)
    )
  | EIf (e0, e1, e2) -> 
    (match eval env e0 with
    | VBool true -> Thunk (e1, env)
    | VBool false -> Thunk (e2, env)
    | _ -> raise (Error "Eval_cbn Error (make_thunk) : Unexpected bool detected") 
    ) 
  | EVar n -> List.assoc n env
  | ELet (x, e1, e2) -> Thunk (e2, (x, Thunk (e1, env)) :: env)
  | EFun (x, e) -> Thunk (exp, env)
  | EApp (e1, e2) -> Thunk (exp, env)
  | ENil -> Thunk (exp, env)
  | ECons (e1, e2) -> Thunk (exp, env)
  | ETuple el -> Thunk (exp, env)
  | EMatch (e, pl) -> 
      let v = eval env e in
      let rec match_to_thunk (v: value) (l: (pattern * expr) list) : thunk =
        match l with
        | [] -> raise (Error "Evalerror : No pattern matched")
        | (p, e') :: rest ->
          (match find_match p v env with
          | Some nenv -> Thunk (e', (nenv @ env))
          | None -> match_to_thunk v rest) 
        in match_to_thunk v pl 
  | _ -> raise (Error "still developing : make_thunk") 


let print_value (v: value) : unit =
  print_string " = ";
  let rec print_loop v =
    match v with
    | VInt i -> print_int i 
    | VBool b -> print_string (string_of_bool b)
    | VFun (x, e, env) -> print_string " = <fun>"
    | VRLetAnd (_, l, _) -> print_string " = <fun>"
    | VNil -> print_string "[]" 
    | VCons (th, threst) -> 
      (match threst with
      | Thunk (ENil, _) -> print_loop (eval_thunk th); print_string " :: []"
      | Thunk _ -> print_loop (eval_thunk th); print_string " :: "; print_loop (eval_thunk threst)
      )
    | VTuple thl -> print_string " = (";
      match thl with
      | th :: rest -> print_loop (eval_thunk th);
        List.map (fun th -> print_string ", "; print_loop (eval_thunk th)) rest;
        print_string (")")
      | _ -> raise (Error "Unexpected Pattern : print_value")
    in print_loop v


let rec print_command_value (env : env) (cmd : command) (t_e : ty_env) : env * ty_env =
  let t_e' = Functions_cbn.print_command_type t_e cmd in
  match cmd with
  | CExp expr -> print_value (eval_thunk (make_thunk expr env)); print_newline(); (env, t_e')
  | CLet (n, e) ->  
    let command_let (env : env) (n : name) (e : expr) : (value * env) =
      (match eval env e with | v1 -> (v1, ((n, Thunk (e, env)) :: env))) in
    let (v,e') = command_let env n e in print_value v; print_newline();
    (e', t_e')
  (* | CRLetAnd l ->
    let rec and_env (i: int) (l1: (name * name * expr) list) : env =
    match l1 with
    | [] -> env
    | (f, x, e) :: rest -> (f, VRLetAnd(i, l, env)) :: (and_env (i + 1) rest) in
    let nenv = and_env 0 l in
      (nenv, t_e') *)
  | _ -> raise (Error "still developing : print_command_value")