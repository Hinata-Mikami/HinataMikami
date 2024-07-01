open Syntax_cbn

exception Error of string

let value_of_literal (l:  literal) : value = 
  match l with
  | LInt i -> VInt i 
  | LBool b -> VBool b

let rec find_match (p : pattern ) (th : thunk) (env : env) : env option =
  match p with
  | PInt i1 ->
    (match eval_thunk th with
    | VInt i2 when i1 = i2 -> Some []
    | _ -> None
    ) 
  | PBool b1 ->
    (match eval_thunk th with
    | VBool b2 when b1 = b2 -> Some []
    | _ -> None
    ) 
  | PVar x -> Some [(x, th)] 
  | PWild -> Some [] 
  | PCons(ph, pr)->
    (match eval_thunk th with
    | VCons(thh, thr) ->
      let head = find_match ph thh env in
      let rest = find_match pr thr env in
      (match head, rest with
      | Some env1, Some env2 -> Some (env1 @ env2) 
      | _ -> None)
    | _ -> None
    )
  | PNil when (eval_thunk th = VNil) -> Some [] 
  | PTuple pl ->
    (match eval_thunk th with
    | VTuple thl -> match_tuple pl thl env
    | _ -> None
    )
  | _ -> None

and match_tuple (pl : pattern list)  (thl : thunk list) (env : env) : env option =
  match pl, thl with
  | [], [] -> Some []
  | ph :: pr, thh :: thr 
    ->let head = find_match ph thh env in
      let rest = match_tuple pr thr env in
      (match head, rest with
      | Some env1, Some env2 -> Some (env1 @ env2)
      | _ -> None)
  | _ -> None

and eval (env : env) (expr : expr) : value =
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
    match List.assoc x env with
    | Thunk(exp, env') -> eval env exp
    | ThRLet (n, exp, env') -> eval env exp
    | ThRLetAnd (i, l, env') ->
      let (f, exp) = List.nth l i in
      eval env exp
    | exception Not_found 
      -> raise (Error ("Eval_Error : Variable not found on lookup_variable. 
      You were looking for " ^ x ^ " but couldn't find out.\n"))

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
        | VFun (x, e, oenv) -> eval ((x, Thunk(e2, env)) :: oenv) e
        (* | VRLetAnd (i, l, oenv) -> 
          (let rec make_env (j : int)  (l1 : (name * name * expr) list) : env =
            match l1 with
              | [] -> []
              | (fj, _, _) :: rest -> (fj, VRLetAnd(j, l, oenv)) :: make_env (j + 1) rest
          (*作成した環境を既存の環境oenvに追加*)
          in let nenv = (make_env 0 l) @ oenv
          (*i番目の要素を取り出す*)
          in let (f, x, e) = List.nth l i
          in eval ((x, v2) :: nenv) e) i番目の変数名と値v2を環境に追加したうえでeを評価 *)
        | _ -> raise (Error "EvalError : Non-function cannot be applied"))

      | ENil -> VNil        
      | ECons (e1, e2) -> VCons (Thunk (e1, env), Thunk (e2, env))
      | ETuple el -> VTuple (List.map (fun e -> Thunk (e, env)) el)
      | EMatch (e, pl) -> 
        let th0 = Thunk (e, env) in
        let rec match_to_value (th: thunk) (l: (pattern * expr) list) : value =
          match l with
          | [] -> raise (Error "Eval Error : No pattern matched")
          | (p, e') :: rest ->
            (match find_match p th0 env with
            | Some nenv -> eval (nenv @ env) e' 
            | None -> match_to_value th rest
            ) 
          in match_to_value th0 pl

      | ERLet (n, e1, e2) 
        ->let nenv = (n, ThRLet(n, e1, env)) :: env in
          eval nenv e1
      | ERLetAnd (l, e) ->
        let f_e_list = List.map(fun (f, x, e) -> (f, e)) l in
        let rec and_env (i: int) (l1: (name * name * expr) list) : env =
          match l1 with
          | [] -> env
          | (f, x, e) :: rest -> (f, ThRLetAnd (i, f_e_list, env)) :: (and_env (i + 1) rest) in
        let nenv = and_env 0 l 
        in eval nenv e
  

and eval_thunk (th : thunk) : value = 
  match th with
  | Thunk (exp, env) -> eval env exp
  | _ -> raise (Error "Eval_cbn error : unexpected thunk at eval_thunk")


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
      | _ -> raise (Error "Eval_cbn error : unexpected thunk at print_value")
      )
    | VTuple thl -> print_string " = (";
      match thl with
      | th :: rest -> print_loop (eval_thunk th);
        List.map (fun th -> print_string ", "; print_loop (eval_thunk th)) rest;
        print_string (")")
      | _ -> raise (Error "Unexpected Pattern : print_value")
    in print_loop v


let rec print_command_value (env : env) (cmd : command) (t_e : ty_env) : env * ty_env =
  (* let t_e' = Functions_cbn.print_command_type t_e cmd in *)
  let t_e' = [] in
  match cmd with
  | CExp expr -> print_value (eval_thunk (Thunk (expr, env))); print_newline(); (env, t_e')
  | CLet (n, e) ->  
    let command_let (env : env) (n : name) (e : expr) : (value * env) =
      (match eval env e with | v1 -> (v1, ((n, Thunk (e, env)) :: env))) in
    let (v,e') = command_let env n e in print_value v; print_newline();
    (e', t_e')
  | CRLetAnd l ->
    let f_e_list = List.map(fun (f, x, e) -> (f, e)) l in
    let rec and_env (i: int) (l1: (name * name * expr) list) : env =
    match l1 with
    | [] -> env
    | (f, x, e) :: rest -> (f, ThRLetAnd (i, f_e_list, env)) :: (and_env (i + 1) rest) in
    let nenv = and_env 0 l in
      (nenv, t_e')