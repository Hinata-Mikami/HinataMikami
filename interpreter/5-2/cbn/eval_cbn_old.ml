open Syntax_cbn

exception Error of string

let value_of_literal (l:  literal) : value = 
  match l with
  | LInt i -> VInt i 
  | LBool b -> VBool b

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
      | OpDiv -> if y = 0 then raise (Error "Eval_Error : Zero_Division") else VInt (x / y)
      | OpEq -> VBool (x = y)
      | OpLt -> VBool (x < y))
    | _ -> raise (Error "Eval_Error : Unexpected expression on eval_bin_op")

  (*if e0 then e1 else e2 -> value*)
  in let eval_if (env : env) (e0 : expr) (e1 : expr) (e2 : expr) : value =
    match eval env e0 with
    | VBool true -> eval env e1
    | VBool false -> eval env e2
    | _ -> raise (Error "Eval_Error : Unexpected expression on eval_if")

  (* (x, v)∊env ⇒ v *)
  in let lookup_variable (env : env) (x : name) : value =
    try
      List.assoc x env
    with
    | Not_found -> raise (Error "Eval_Error : Variable not found on lookup_variable")

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
      | EFun (x, e) -> VFun (x, e, env)
      | EApp (e1, e2) -> 
        let v1 = eval env e1 in
        let v2 = eval env e2 in
        (match v1 with
        | VFun (x, e, oenv) -> eval ((x, v2) :: oenv) e
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
        | _ -> raise (Error "EvalError : Non-function cannot be applied"))
      (*match e with ... の e とパターンの組のリスト (p, e) list を受け取る *)
      | EMatch (e, pl) -> 
        let v = eval env e in
        (*マッチ時は情報を環境に追加してそのうえで->の右側を評価)*)
        let rec match_to_value (v: value) (l: (pattern * expr) list) : value =
          match l with
          | [] -> raise (Error "Evalerror : No pattern matched")
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

let make_thunk (exp : expr) (env : env) : thunk = Thunk (exp, env)

(* let rec make_ERLetAnd_env (expl : (name * name * expr) list) (env : env) : env =
  match expl with
  | [] -> env
  | (f, x, e1) :: rest -> (f, Thunk (EFun (x, e1), env)) :: (make_ERLetAnd_env rest env) *)
  
(* let rec make_thunk (exp : expr) (env : env) : thunk =
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
  | EFun (n, e) -> Thunk (EFun (n, e), env)
  | EApp (e1, e2) -> 
    (match make_thunk e1 env with
    | Thunk (EFun (n, e), env') -> Thunk (e, (n, Thunk (e2, env)) :: env')
    (* (match e1 with
    | EFun (n, e1) -> Thunk (e2, (n, Thunk (EFun (n, e1), env)) :: env) *)
    (* | ERLetAnd (expl, e) -> 
      let env' = make_ERLetAnd_env expl env  *)
    | _ -> raise (Error "Eval-CBN Error : No-Function expression cannot be applied")
    )
  (* | ERLetAnd (expl, e) ->
    let env' = make_ERLetAnd_env expl env in
    Thunk (e, env') *)
  | ETuple elist -> Thunk (ETuple elist, env)
  | ECons (e1, e2) -> Thunk (ECons (e1, e2), env)
  | ENil -> Thunk (ENil, env)
  | EMatch (e, plist) ->
    (let th = make_thunk e env in
    let rec eval_match env l th =
      match l with
      | [] -> raise (Error "Eval_cbn Error : Failed to match")
      | (p, e) :: rest ->
        (match find_match p th with
        | None -> eval_match env rest th
        | Some s -> Thunk (e, (s @ env)))
      in eval_match env plist th
    )
  | _ -> raise (Error "Eval_cbn Error : Still developing") *)

(* and find_match (p : pattern) (th : thunk) : env option =
  match (p, th) with
    | (PVar x, (_ as t)) ->
      Some [(x, t)]
    | (PInt i1, Thunk (ELiteral (LInt i2), env)) ->
      if i1 = i2 then Some [] else None
    | (PBool b1, Thunk (ELiteral (LBool b2), env)) ->
      if b1 = b2 then Some [] else None
    | (PTuple plist, Thunk (ETuple elist, env)) ->
      let rec find_match_loop plist elist =
      (match plist, elist with
      | [], _ | _, [] -> None
      | p1::rest, e1::rest' -> 
        (match (find_match p1 (Thunk(e1, env))) with
        | Some a -> Some a
        | None -> find_match_loop rest rest'
        )
      )
      in find_match_loop plist elist
    | (PNil, Thunk (ENil, env)) -> Some []
    | (PCons (p, prest), Thunk ((ECons (e1, erest)), env)) ->
      let env1 = find_match p (Thunk (e1, env)) in
      let env2 = find_match prest (Thunk (erest, env)) in
      (match (env1, env2) with
      (Some s1, Some s2) -> Some (s1 @ s2)
      | _ -> None)
    | (_, Thunk (e, env)) -> find_match p (make_thunk e env) *)

let value_of_literal (l:  literal) : value = 
  match l with
  | LInt i -> VInt i 
  | LBool b -> VBool b

let value_of_bin_op (op : binOp) (v1 : value) (v2 : value) : value =
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


let rec value_of_etuple (elist : expr list) (env : env) : thunk list = 
  match elist with
  | [] -> []
  | e :: rest -> Thunk (e, env) :: value_of_etuple rest env

let rec value_of_exp (exp : expr) (env : env) : value =
  let Thunk (exp', env') = make_thunk exp env in
    match exp' with
    | ELiteral l -> value_of_literal l
    | EVar x -> value_of_exp exp' env'
    | EBin (op, e1, e2) -> 
      let v1 = value_of_exp e1 env' in
      let v2 = value_of_exp e2 env' in
      value_of_bin_op op v1 v2
    | EIf (e1, e2, e3) -> value_of_exp exp' env'
    | ELet (x, e1, e2) -> value_of_exp exp' env'
    | EApp (e1, e2) -> value_of_exp exp' env'
    | EFun (n, e1) -> VFun (n, e1, env')
    | ETuple elist -> VTuple (value_of_etuple elist env)
    | ENil -> VNil
    | ECons (e1, e2) -> VCons (Thunk (e1, env'), value_of_exp e2 env')
    | _ -> raise (Error "Eval_CBN Error : Undefined expression at value_of_exp")
     

let print_value (v : value) : unit =
  print_string " = ";
  let rec print_loop v =
    match v with
    | VInt i -> print_int i
    | VBool b -> print_string (string_of_bool b)
    | VTuple thlist -> 
      print_string "("; 
      let rec print_value_tuple thlist =
        (match thlist with
        | Thunk (exp, env) :: [] -> print_loop (value_of_exp exp env); print_string ")"
        | Thunk (exp, env) :: rest -> print_loop (value_of_exp exp env); print_string ", "; print_value_tuple rest
        | _ -> raise (Error "Unexpected match happened at eval_cbn/print_value")
        ) 
      in print_value_tuple thlist
    | VNil -> print_string "[]"
    | VCons (Thunk (exp, env), v) -> print_loop (value_of_exp exp env); print_string " :: "; print_loop v
    | VFun (x, e, env) -> print_string "<fun>"
    | VRLetAnd (_, l, _) -> print_string "<fun>" in
  print_loop v
 

  
    
    

