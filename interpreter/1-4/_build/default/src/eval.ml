open Syntax

type command_result = Command_result of value * env

(*例外：デバッグ用*)
exception Eval_error
exception Zero_Division
exception Unexpected_Expression_at_binOp
exception Unexpected_Expression_at_eval_if
exception Variable_Not_Found

(*expr型の解析*)
(*envを返す必要は全くない！！！*)
let rec eval (env : env) (expr : expr) : value =
  (*binOpの解析*)
  let eval_bin_op (env : env) (op : binOp) (e1 : expr) (e2 : expr) =
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
      | OpLt -> VBool (x < y))
    | _ -> raise Unexpected_Expression_at_binOp

  (*ifの解析*)
  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr):value =
    match eval env e0 with
    | VBool true -> eval env e1
    | VBool false -> eval env e2
    | _ -> raise Unexpected_Expression_at_eval_if

  (*Evar n : 変数に束縛された値を返す*)
  in let lookup_variable (env : env) (x : name) : value =
    try
      (*encの中からxに対応するキーを返す*)
      List.assoc x env
    with
    | Not_found -> raise Variable_Not_Found

  (*変数の定義*)
  (*let n = e1 in e2 の評価*)
  (*今の環境でe1を評価してその結果をv1とし、その環境でe2を評価する*)
  in let eval_let (env : env) (n : name) (e1 : expr) (e2 : expr) : value = 
    match eval env e1 with
       | v1 -> eval ((n,v1)::env) e2

  (*eval関数のメイン部分*)
  in match expr with
      | ELiteral x -> value_of_literal x
      | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
      | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
      | EVar n -> lookup_variable env n
      | ELet (x, e1, e2) -> eval_let env x e1 e2

(*次のprint_command_resultで使う*)
(*CLet (n, e) : let n = e;;*)
let command_let (env : env) (n : name) (e : expr) : (value * env) =
  match eval env e with
  | v1 -> (v1, ((n,v1) :: env))


(*
今の環境でe1を評価し，その結果をv1とする
xとv1との対応を今の環境に追加
得られた新しい環境で以降のコマンドを処理する
read-eval-printループを実装する再帰関数の引数に…
*)

(*対話型シェルのようにcmdを実行し、実行結果等を表示しつつ、新たな環境envを返す関数*)
(*main.mlの再帰関数loop_stdin env や loop_file env の再帰部分の引数に*)
(*env -> command -> env*)
let print_command_result (env : env) (cmd : command) : env =
  match cmd with
  | CExp expr -> 
    (match eval env expr with
     | v -> print_string (" ― : "); 
     (match v with
     | VInt _ -> print_string ("int = "); print_value v; print_newline()
     | VBool _ -> print_string ("bool = "); print_value v; print_newline()
     );
     env)
  (*CLet: let n = e;;*)
  | CLet (n, e) -> 
    print_string ("val "); print_string n; print_string (" = "); 
    let (v,env') = command_let env n e in print_value v; print_newline();
    env'