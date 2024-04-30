open Syntax

type command_result = Command_result of name option * value * env

(*例外：デバッグ用*)
exception Eval_error;;
exception Zero_Division;;
exception Unexpected_Expression_at_binOp
exception Unexpected_Expression_at_eval_if
exception Variable_Not_Found

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
      | OpDiv -> if y = 0 then raise Zero_Division else (VInt (x / y), env)
      | OpEq -> (VBool (x = y), env)
      | OpLt -> (VBool (x < y), env))
    | _ -> raise Unexpected_Expression_at_binOp

  (*ifの解析*)
  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr) =
    match eval env e0 with
    | (VBool true, env) -> eval env e1
    | (VBool false, env) -> eval env e2
    | _ -> raise Unexpected_Expression_at_eval_if

  (*変数に束縛された値を返す*)
  in let lookup_variable (env : env) (x : name) : value =
    try
      (*encの中からxに対応するキーを返す*)
      List.assoc x env
    with
    | Not_found -> raise Variable_Not_Found

  (*変数の定義*)
  (*let n = e1 in e2*)
  (*局所定義：(n, e1)はこのスコープ外には反映されてほしくない*)
  in let eval_let (env : env) (n : name) (e1 : expr) (e2 : expr) = 
    match eval env e1 with
       | (v1,_) -> eval ((n,v1) :: env) e2

  in match expr with
      | ELiteral x -> (value_of_literal x, env)
      | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
      | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
      | EVar n -> (lookup_variable env n, env)
      | ELet (x, e1, e2) -> eval_let env x e1 e2
      | EFun (x, e) -> (VFun (x, e, env), env)
      | EApp (e1, e2) -> 
        let v1, _ = eval env e1 in
        let v2, _ = eval env e2 in
        (match v1 with
          | VFun (x, e, env') ->
              eval ((x, v2) :: env') e
          | _ -> raise Eval_error)
    

(*CLet (n, e) : let n = e;;*)
let command_let (env : env) (n : name) (e : expr) =
  match eval env e with
  | (v1,_) -> eval ((n,v1) :: env) e


let print_command_result (env : env) (cmd : command) : env =
  match cmd with
  | CExp expr -> 
    (match eval env expr with
     | (v,e) -> print_string (" ― : "); 
     (match v with
     | VInt i -> print_string ("int = "); print_value v; print_newline()
     | VBool b -> print_string ("bool = "); print_value v; print_newline()
     | VFun (_, _, _) -> () (*未実装*)
     );
     env)
  (*CLet: let n = e;;*)
  | CLet (n, e) -> 
    print_string ("val "); print_string n; print_string (" = "); 
    let (v,e') = command_let env n e in print_value v; print_newline();
    e'