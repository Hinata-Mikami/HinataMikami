open Syntax

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
      | OpLt -> VBool (x < y))
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
  (* p v の型一致を確認し、一致ならSome 追加する環境を返す *)
  in let rec find_match (p : pattern ) (v : value) : env option =
    match p, v with
    | PInt i1, VInt i2 -> if i1 = i2 then Some [] else None
    | PBool b1, VBool b2 -> if b1 = b2 then Some [] else None
    | PVar x, _ -> Some [(x, v)] (*左側が変数xなら(x, v)を環境に追加*)
    | PWild, _ -> Some [] (*ワイルドカードは必ず右側を評価*)
    (*リストの評価*)
    | PCons(ph, prest), VCons(vh, vrest) ->
      let h = find_match ph vh in (*先頭のパターンマッチの確認*)
      let rest = find_match prest vrest in (*再帰的に2番目以降の要素のパターンマッチを確認*)
      (match h, rest with
        | Some env1, Some env2 -> Some (env1 @ env2) (*先頭もそれ以降もマッチ->新環境を連結*)
        | _ -> None)
    | PNil, VNil -> Some [] (* [] -> [] なら返す環境なし*)
    (*組の評価 リストの時と同様*)
    | PTuple pl, VTuple vl ->
      let rec match_tuple (pl:pattern list) (vl: value list) : env option =
      match pl, vl with
          | [], [] -> Some []
          | p :: prest , v :: vrest ->
              let h = find_match p v in
              let rest = match_tuple prest vrest in
              (match h, rest with
                | Some env1, Some env2 -> Some (env1 @ env2)
                | _ -> None)
          | _ -> None
          in match_tuple pl vl
    | _ -> None

  in match expr with
      | ELiteral x -> value_of_literal x
      | EBin (op, e1, e2) -> eval_bin_op env op e1 e2
      | EIf (e0, e1, e2) -> eval_if env e0 e1 e2
      | EVar n -> lookup_variable env n
      | ELet (x, e1, e2) -> eval_let env x e1 e2
      (* | ERLet (f, x, e1, e2) -> 
          let env' = (f, VRFun(f, x, e1, env)) :: env in
          eval env' e2 *)
      | EFun (x, e) -> VFun (x, e, env)
      | EApp (e1, e2) -> 
        let v1 = eval env e1 in
        let v2 = eval env e2 in
        (match v1 with
        | VFun (x, e, oenv) -> eval ((x, v2) :: oenv) e
        | VRFun (f, x, e, oenv) ->
            let env' = (x, v2) :: (f, VRFun (f, x, e, oenv)) :: oenv in
            eval env' e
        (*l = (f, x, e) と oenv から (f1, l, oenv), ..., (fn, l, oenv)　を作成*)
        | VRFunAnd (i, l, oenv) -> 
          (let rec make_env (j : int)  (l1 : (name * name * expr) list) : env =
            match l1 with
              | [] -> []
              | (fj, _, _) :: rest -> (fj, VRFunAnd(j, l, oenv)) :: make_env (j + 1) rest
          (*作成した環境を既存の環境oenvに追加*)
          in let nenv = (make_env 0 l) @ oenv
          (*i番目の要素を取り出す*)
          in let (f, x, e) = List.nth l i
          in eval ((x, v2) :: nenv) e) (*i番目の変数名と値v2を環境に追加したうえでeを評価*)
        | _ -> raise Eval_error)
      (*match e with ... の e とパターンの組のリスト (p, e) list を受け取る *)
      | EMatch (e, pl) -> 
        let v = eval env e in
        (*マッチ時は情報を環境に追加してそのうえで->の右側を評価)*)
        let rec match_to_value (v: value) (l: (pattern * expr) list) : value =
          match l with
          | [] -> raise Eval_error
          | (p, e') :: rest ->
            (match find_match p v with
            | Some nenv -> eval (nenv @ env) e'
            | None -> match_to_value v rest) 
          in match_to_value v pl
      | ENil -> VNil
      (*リストの評価：要素をvalueに変える*)          
      | ECons (e1, e2) ->
        let v1 = eval env e1 
        and v2 = eval env e2 in
        VCons (v1, v2)
      (*組の評価：すべての要素をvalueに変える*)
      | ETuple el -> VTuple (List.map (fun e -> eval env e) el)
      | ERLetAnd (l, e) ->
        (*リストから環境を生成: (f0, VRFunAnd(0, l, env)), ... を生成*)
        let rec make_env (i: int) (l' : (name * name * expr) list) : env =
        match l' with
        | [] -> env
        | (f, x, e) :: rest -> (f, VRFunAnd(i, l, env)) :: (make_env (i + 1) rest) in
          let nenv = make_env 0 l 
        (*環境の下でeを評価*)
        in eval nenv e


(*CLet (n, e) : let n = e;;*)
let command_let (env : env) (n : name) (e : expr) : (value * env) =
  match eval env e with
  | v1 -> (v1, ((n,v1) :: env))



let print_types_of_tuple (l : value list) : unit =
  match l with
  | [] -> ()
  | v :: rest ->
    let rec string_of_value_type (l' :value list) : unit =
      (match l' with
      | [] -> ()
      | v' :: rest' ->
        (match v' with
        | VInt _ -> print_string(" * int");(string_of_value_type rest')
        | VBool _ -> print_string(" * bool");(string_of_value_type rest')
        | _ -> print_string(" *  ");(string_of_value_type rest')
        )
      )
      in 
        (match v with
        | VInt _ -> print_string("int");(string_of_value_type rest)
        | VBool _ -> print_string("bool");(string_of_value_type rest)
        | _ -> print_string(" ");(string_of_value_type rest)
        )

  

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
     | VCons _ -> print_string ("list = "); print_value v; print_newline()
     | VNil -> print_string ("list = "); print_value v; print_newline()
     | VTuple l -> print_types_of_tuple l; print_string (" = "); print_value v; print_newline()
     | _ -> print_value v; print_newline()
     );
     env)
  | CLet (n, e) -> 
    print_string ("val "); print_string n; print_string (" = "); 
    let (v,e') = command_let env n e in print_value v; print_newline();
    e'
  (* (f, x, e) list*)
  | CRLetAnd l ->
      (*リストから環境を作成*)
      let rec and_env (i: int) (l1: (name * name * expr) list) : env =
      match l1 with
        | [] -> env
        | (f, x, e) :: rest -> (f, VRFunAnd(i, l, env)) :: (and_env (i + 1) rest) in
      let nenv = and_env 0 l in
      (*コマンドラインに変数を表示*)
      let rec printfun (l2 : (name * name * expr) list) : unit =
        match l2 with
        | [] -> ()
        | (f, x, e) :: rest ->
            print_endline (f ^ " = <fun>"); printfun rest;
        in printfun l;
      nenv