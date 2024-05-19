open Syntax

type command_result = Command_result of value * env

(*例外：デバッグ用*)
exception Eval_error;;
exception Zero_Division;;
exception Unexpected_Expression_at_binOp
exception Unexpected_Expression_at_eval_if
exception Variable_Not_Found

let rec eval (env : env) (expr : expr) : value =

  (*binOp -> value*)
  let eval_bin_op (env : env) (op : binOp) (e1 : expr) (e2 : expr) : value =
    let v1 = eval env e1 in
    let v2 = eval env e2 in
    match v1, v2 with
    | VInt x, VInt y ->
    ( match op with
      | OpAdd -> VInt (x + y)
      | OpSub -> VInt (x - y)
      | OpMul -> VInt (x * y)
      | OpDiv -> if y = 0 then raise Zero_Division else VInt (x / y)
      | OpEq -> VBool (x = y)
      | OpLt -> VBool (x < y)
      | OpOr -> raise Eval_error)
    | _ -> raise Unexpected_Expression_at_binOp

  (*if e0 then e1 else e2 -> value*)
  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr) : value =
    match eval env e0 with
    | VBool true -> eval env e1
    | VBool false -> eval env e2
    | _ -> raise Unexpected_Expression_at_eval_if

  (* (x, v)∊env ⇒ v *)
  in let lookup_variable (env : env) (x : name) : value =
    try
      List.assoc x env
    with
    | Not_found -> raise Variable_Not_Found

  (*let n = e1 in e2-> value*)
  in let eval_let (env : env) (n : name) (e1 : expr) (e2 : expr) : value = 
    match eval env e1 with
       | v1 -> eval ((n,v1) :: env) e2
       
  (*match v with p -> ... *)     
  in let rec find_match (pv : value) (v : value) : env option =
    match (pv, v) with
    | (VInt i1, VInt i2) -> if i1 = i2 then Some [] else None   (* int  ->  *)
    | (VBool b1, VBool b2) -> if b1 = b2 then Some [] else None
    (* | (EVar v, (_ as t)) -> Some [(v, t)] *)
    (* | ((_ as t), EVar v) -> Some [(v, t)] *)
    | (VPair (v1, v2), VPair (v3, v4)) ->
      let first = find_match v1 v3 in
      let second = find_match v2 v4 in
      (match (first, second) with
      (Some s1, Some s2) -> Some (s1 @ s2)
      | _ -> None)
    | (VNil, VNil) -> Some []
    | (VCons (e1, e2) , VCons (e3, e4)) ->
      let element = find_match e1 e3 in
      let rest = find_match e2 e4 in
      (match (element, rest) with
      (Some s1, Some s2) -> Some (s1 @ s2)
      | _ -> None)
    | _ -> None
      
  (*match v with e2 -> value*)    
  in let rec eval_match (v:value) (e2:expr) (env:env) : value=
    match e2 with
      (*p1 -> e1 end;;*)
      EMatchpairend (p, e) ->
        (match e with
        | EVar x -> eval ((x, v) :: env) e
        | _ -> let pv = eval env p in
        (match find_match pv v with
        | Some s -> eval (s @ env) e
        | None -> raise Eval_error))
      (*p1 -> e1 | expr*)
      | EBin (OpOr, EMatchpair (p, e), e') ->
        (match e with
        | EVar x -> eval ((x, v) :: env) e
        | _ -> let pv = eval env p in
        (match find_match pv v with
        | Some s -> eval (s @ env) e
        | None -> eval_match v e' env))
      | _ -> raise Eval_error

  in let rec eval_env l l' oenv i =
    match l with
    [] -> oenv
    | (f, x, e) :: rest -> (f, VRFunand (i, l', oenv)) :: (eval_env rest l' oenv (i + 1))

  in match expr with
      | ELiteral x -> value_of_literal x
      | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
      | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
      | EVar n -> lookup_variable env n
      | ELet (x, e1, e2) -> eval_let env x e1 e2
      | ERLet (f, x, e1, e2) -> 
          let env' = (f, VRFun(f, x, e1, env)) :: env in
          eval env' e2
      | EFun (x, e) -> VFun (x, e, env)
      | EApp (e1, e2) -> 
        let v1 = eval env e1 in
        let v2 = eval env e2 in
        (match v1 with
          | VFun (x, e, oenv) -> eval ((x, v2) :: oenv) e 
          | VRFun (f, x, e, oenv)  ->
              let env' = (x,v2) :: (f, VRFun (f,x,e,oenv)) :: oenv in
              eval env' e
          | _ -> raise Eval_error)
      | EMatch (e1, e2) ->  let v = eval env e1 in
                            eval_match v e2 env
      | EPair (e1, e2) -> VPair (eval env e1, eval env e2)
      | ENil -> VNil
      | ECons (e1, e2) ->
        let v = eval env e2 in
        (match v with
        | VNil -> VCons (eval env e1, v)
        | VCons (e1', e2') -> VCons (eval env e1, v)
        | _ -> raise Eval_error)
      | ERLetand (l, e) ->
        let l' = l in
        let env' = eval_env l l' env 0 in eval env' e
      | _ -> raise Eval_error


(*CLet (n, e) : let n = e;;*)
let command_let (env : env) (n : name) (e : expr) : (value * env) =
  match eval env e with
  | v1 -> (v1, ((n,v1) :: env))


(*対話型シェル：実行＋新たな環境envを返す関数*)
(*main.mlの再帰部分の引数に*)
(*env -> command -> env*)
let print_command_result (env : env) (cmd : command) : env =
  match cmd with
  | CExp expr -> 
    (match eval env expr with
     | v -> print_string (" ― : "); 
     (match v with
     | VInt _ -> print_string ("int = "); print_value v; print_newline()
     | VBool _ -> print_string ("bool = "); print_value v; print_newline()
     | VPair (e1, e2) -> print_string "pair"
     | VNil -> print_string "nil list"
     | VCons (e1, e2) -> print_string "list"
     | _ -> print_string "function"
     );
     env)
  | CLet (n, e) -> 
    print_string ("val "); print_string n; print_string (" = "); 
    let (v,e') = command_let env n e in print_value v; print_newline();
    e'