open Syntax

type command_result = Command_result of name option * value * env

exception Eval_error;;

let rec eval (env : env) (expr : expr) : value =
  (*binOpの解析*)
  let eval_bin_op (env : env) (op : binOp) (e1 : expr) (e2 : expr) : value =
    let v1 = eval env e1 in
    let v2 = eval env e2 in
    match (op, v1, v2) with
    | (OpAdd, VInt x, VInt y) -> VInt (x + y)
    | (OpSub, VInt x, VInt y) -> VInt (x - y)
    | (OpMul, VInt x, VInt y) -> VInt (x * y)
    | (OpDiv, VInt x, VInt y) -> if y = 0 then raise Eval_error else VInt (x / y)
    | (OpEq, VInt x, VInt y) -> VBool (x = y)
    | (OpEq, VBool x, VBool y) -> VBool (x = y)
    | (OpLt, VInt x, VInt y) -> VBool (x < y)
    | _ -> raise Eval_error

  (*ifの解析*)
  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr) : value =
    match eval env e0 with
    | VBool true -> eval env e1
    | VBool false -> eval env e2
    | _ -> raise Eval_error

  (*変数に束縛された値を返す*)
  in let lookup_variable (env : env) (x : name) : value =
    try
      (*encの中からxに対応するキーを返す*)
      List.assoc x env
    with
    | Not_found -> raise Eval_error

  (*変数の定義*)  
  in let eval_let (env : env) (x : name) (e1 : expr) (e2 : expr) : value =
    let v1 = eval env e1 in
    let new_env = (x, v1) :: env in
    eval new_env e2

  (*unused?*)
  in let eval_command (env : env) (cmd : command) : command_result =
    match cmd with
    | CExpr expr ->
      let value = eval env expr in
      Command_result (None, value, env)
    | CLet (x, expr) ->
      let value = eval env expr in
      let new_env = (x, value) :: env in
      Command_result (Some x, value, new_env)

  in  match expr with
    | ELiteral x -> value_of_literal x
    | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
    | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
    | EVar x -> lookup_variable env x
    | ELet (x, e1, e2) -> eval_let env x e1 e2
