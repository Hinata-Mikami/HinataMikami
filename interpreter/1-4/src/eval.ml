open Syntax

type command_result = Command_result of name option * value * env

exception Eval_error;;

let rec eval (env : env) (expr : expr) =
  (*binOpの解析*)
  let eval_bin_op (env : env) (op : binOp) (e1 : expr) (e2 : expr) =
    let v1 = eval env e1 in
    let v2 = eval env e2 in
    match v1, v2 with
    | (VInt x, _), (VInt y, _) ->
    ( match op with
      | OpAdd -> (VInt (x + y), env)
      | OpSub -> (VInt (x - y), env)
      | OpMul -> (VInt (x * y), env)
      | OpDiv -> if y = 0 then raise Eval_error else (VInt (x / y), env)
      | OpEq -> (VBool (x = y), env)
      | OpLt -> (VBool (x < y), env))
    | _ -> raise Eval_error

  (*ifの解析*)
  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr) =
    match eval env e0 with
    | (VBool true, env) -> eval env e1
    | (VBool false, env) -> eval env e2
    | _ -> raise Eval_error

  (*変数に束縛された値を返す*)
  in let lookup_variable (env : env) (x : name) : value =
    try
      (*encの中からxに対応するキーを返す*)
      List.assoc x env
    with
    | Not_found -> raise Eval_error

  (*変数の定義*)  
  in let eval_let (env : env) (n : name) (e1 : expr) (e2 : expr) = 
    match eval env e1 with
       | (v1,_) -> eval ((n,v1) :: env) e2

  in  match expr with
    | ELiteral x -> (value_of_literal x, env)
    | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
    | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
    | EVar x -> (lookup_variable env x, env)
    | ELet (x, e1, e2) -> eval_let env x e1 e2


let eval_command (env:env) (cmd:command) = 
  match cmd with
    | CExp expr -> eval env expr
    | CLet (e1,e2) -> eval env (ELet (e1,e2,e2))
  
let eval_and_print_command (env:env) (cmd:command) =
  match cmd with
  | CExp expr -> 
    (match eval env expr with
     | (v,_) -> print_value v)
  | CLet (e1, e2) -> 
    print_string ("val "); print_string e1; print_string (" = "); 
      let (v,_) = eval env (ELet (e1,e2,e2)) in print_value v
      
let rec eval_and_print_expr env expr = 
        match eval env expr with
        | (v,_) -> print_value v
      
let print_var v = print_string v