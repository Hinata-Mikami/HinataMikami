open Syntax

exception Eval_error
exception Zero_Division
exception Unexpected_Expression_at_binOp
exception Unexpected_Expression_at_eval_if
exception Variable_Not_Found
exception Type_error


(*型代入*)
let rec apply_ty_subst (s : ty_subst) (t : ty) : ty =
  match t with
  | TyInt -> TyInt
  | TyBool -> TyBool
  | TyFun(t1, t2) -> TyFun(apply_ty_subst s t1, apply_ty_subst s t2)
  | TyVar n -> 
    (match s with
    | [] -> t
    | (s', t') :: rest when s' = n -> t'
    | (s', t') :: rest -> apply_ty_subst rest t
    )


(*s1とs2の合成*)
let compose_ty_subst (s1 : ty_subst) (s2 : ty_subst) : ty_subst =
  let rec make_l2 s2 =
    match s2 with
    | [] -> []
    | (s, t) :: rest -> (s, apply_ty_subst s1 t) :: (make_l2 rest)
  in let l2 = make_l2 s2
  in
  let rec make_l1 s1 = 
    match s1 with
    | [] -> []
    | (s, t) :: rest ->
      (match List.assoc_opt s s2 with
      | Some x -> make_l1 rest
      | None -> (s, t) :: (make_l1 rest)
      )
  in let l1 = make_l1 s1
in l2 @ l1


(*tがsを含んでいるかどうかを確認する関数*)
let rec check_var_fault (s : string) (t : ty) : bool =
  match t with
  | TyInt -> false
  | TyBool -> false
  | TyVar n -> if n = s then true else false
  | TyFun (t1, t2) -> check_var_fault s t1 || check_var_fault s t2

  
(*制約の単一化*)  
let rec ty_unify (c : ty_constraints) : ty_subst =
  match c with
  (*unify {} = {}*)
  | [] -> []
  (*unify ( {s = s} U c) = unify c *)
  | (t1, t2) :: rest when t1 = t2 -> ty_unify rest
  (*unify ({ s1->t1 = s2->t2 } U c) = unify ({ s1=s2, t1=t2 } U c)*)
  | (TyFun (s1, t1), TyFun (s2, t2)) :: rest -> ty_unify ((s1, s2) :: (t1, t2) :: rest)
  (*unify ({s = t} U C) = unify ({t = s} U C) = unify (( C[s ↦ t] )∘[s ↦ t]) *)
  (*tはsを含まない -> t が s を含む場合はエラーを投げる*)
  | (TyVar s, t) :: rest | (t, TyVar s) :: rest ->
    if check_var_fault s t then raise Type_error
    (*C(rest)の各要素(t1,t2)においてsにtを代入する*)
    else compose_ty_subst
    (ty_unify (List.map (fun (t1, t2) -> (apply_ty_subst [(s, t)] t1, apply_ty_subst [(s, t)] t2)) rest)) [(s, t)]
  | _ -> raise Type_error


(* カウンタを保持する参照を作成 *)
let counter = ref 0

(* 新しい型変数名を生成する関数 *)
let new_ty_var () =
  (* カウンタの値を取得 *)
  let current_count = !counter in
  (* カウンタをインクリメント *)
  counter := current_count + 1;
  (* 新しい型変数名を生成して返す *)
  "t" ^ string_of_int current_count


(*制約の収集*)
let rec gather_ty_constraints (t_e : ty_env) (e : expr) : ty * ty_constraints =
  match e with
  (*定数*)
  | ELiteral x 
    ->(match (Eval.value_of_literal x) with
      (*1 -> int型, 制約{}*)
      | VInt _ -> (TyInt, [])
      (*true -> bool型, 制約{}*)
      | VBool _ -> (TyBool, [])
      | _ -> raise Type_error
      )
  (*変数 : 型環境を検索・それに従う(なければエラー)*)
  | EVar x
    ->(match List.assoc_opt x t_e with
      | Some x' -> (x', [])
      | None -> raise Type_error
      )
  (*let式：現型環境でe1の型(t1)と制約(c1)を求める 
    -> (x, t1) :: 現環境 -> e2の型(t2)と制約(c2)
    -> (t2, c1@c2*)
  | ELet (x, e1, e2)
    ->let (t1, c1) = gather_ty_constraints t_e e1 in
      let (t2, c2) = gather_ty_constraints ((x, t1) :: t_e) e2 in
      (t2, c1 @ c2)
  (*if式 -> すべてのeについて、(ti, ci)
         -> (t2, {t1=bool, t2=t3} U c1 U c2 U c3)*)
  | EIf (e1, e2, e3)
    ->let (t1, c1) = gather_ty_constraints t_e e1 in
      let (t2, c2) = gather_ty_constraints t_e e2 in
      let (t3, c3) = gather_ty_constraints t_e e3 in
      (t2, [(t1, TyBool); (t2, t3)] @ c1 @ c2 @ c3)
  (*関数抽象：新たな型変数αを用意し、(x, α)::現環境
    -> eの型(t)と制約(c)を求める
  　-> (α->t(TyFun), c)*)
  | EFun (x, e)
    ->let a = new_ty_var () in
      let new_ty_env = (x, TyVar a) :: t_e in
      let (t, c) = gather_ty_constraints new_ty_env e in
      (TyFun (TyVar a, t), c)
  (*関数適用：それぞれの型と制約(ti, ci)
            -> 新たな型変数α
            -> (α, {t1=t2 -> α} U c1 U c2)*)
  | EApp (e1, e2) 
    ->let (t1, c1) = gather_ty_constraints t_e e1 in
      let (t2, c2) = gather_ty_constraints t_e e2 in 
      let a = new_ty_var () in
      (TyVar a, [(t1, TyFun (t2, TyVar a))] @ c1 @ c2)
  (*再帰関数let rec f x = e1 in e2*)
  | ERLetAnd (l, e2)
    ->( match l with
        | (f, x, e1) :: []
          ->let a = new_ty_var () in
            let b = new_ty_var () in
            let gamma = (f, TyFun (TyVar a, TyVar b)):: t_e in
            let new_env = (x, TyVar a) :: gamma in
            let (t1, c1) = gather_ty_constraints new_env e1 in
            let (t2, c2) = gather_ty_constraints new_env e2 in
            (t2, [(t1, TyVar b)] @ c1 @ c2)
        | _ -> raise Type_error (*一旦 andを含むものは許さない *)
      )
  | _ -> raise Type_error


(*型推論の実装：expr*)
let rec infer_expr (t_e : ty_env) (e : expr) : ty * ty_env = 
  let (t, c) = gather_ty_constraints t_e e in
  let t_s = ty_unify c in
  (apply_ty_subst t_s t, List.map (fun (n, ty) -> (n, apply_ty_subst t_s ty)) t_e)


(*型推論の実装：command*)
let rec infer_cmd (t_e : ty_env) (cmd : command) : ty_env * ty_env =
  match cmd with
  | CExp e ->
    let (t, t_e') = infer_expr t_e e in
    (t_e', t_e')
  | CLet (n, e) ->
    let (t, t_e') = infer_expr t_e e in
    let newenv = (n, t) :: t_e' in
    ([(n, t)], newenv)
  | CRLetAnd l ->
      let l' = (List.map (fun (f, x, e) ->
        let s1 = new_ty_var () in
        let s2 = new_ty_var () in
        (f, x, e, s1, s2)) l) in
      let t_e' = (List.map (fun (f, x, e, s1, s2) ->
        (f, TyFun (TyVar s1, TyVar s2))) l') @ t_e in
      let newenv = List.fold_left (fun list (f, x, e, s1, s2) ->
        let (tl, tenvl) = infer_expr ((x, TyVar s1) :: t_e') (EFun (x, e)) in
        (f, tl) :: tenvl @ list) [] l' in
      let newenv' = (List.map (fun (f, x, e, s1, s2) ->
        let (tl, tenvl) = infer_expr ((x, TyVar s1) :: t_e') (EFun (x, e)) in
        (f, tl))) l' in
      (newenv', newenv)

let rec print_type : ty -> unit =
  fun t ->
  match t with
  | TyInt -> print_string "int"
  | TyBool -> print_string "bool"
  | TyFun (t1, t2) -> print_type t1; print_string " -> "; print_type t2
  | TyVar s -> print_string s

  
let rec print_command_type : ty_env -> unit =
  fun l ->
  match l with
  | [] -> print_string ";"
  | (name, t) :: [] ->
    print_string (name ^ ": "); print_type t; print_string ";";
  | (name, t) :: rest ->
    print_string (name ^ ": "); print_type t; print_string "; "; print_command_type rest


let rec print_value (v: value) : unit =
  match v with
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b)
  | VFun (x, e, env) -> print_string "<fun>"
  (* | VRFun (f, x, e, env) -> print_string "<fun>" *)
  | VCons (v, rest) -> 
    (match rest with
    | VNil -> print_value v; print_string " :: "; print_string "[]"
    | _ -> print_value v; print_string " :: ("; print_value rest; print_string ")" )
  | VNil -> print_string "[]"
  | VTuple vlist ->
      (*組を表示する関数*)
      let rec print_tuple (vl : value list) : unit =
      match vl with
        | [] -> print_char ')'
        | v :: rest -> print_string ", "; print_value v; print_tuple rest; in
      (match vlist with
        | [] -> raise Eval_error
        | v :: rest -> print_char '('; print_value v; print_tuple rest)
  | VRFunAnd (_, l, _) -> print_string "<fun>"


(*CLet (n, e) : let n = e;;*)
let command_let (env : env) (n : name) (e : expr) : (value * env) =
  match Eval.eval env e with
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
    (match Eval.eval env expr with
     | v -> print_string (" ― : "); 
     (match v with
     | VInt _ -> print_string ("int "); print_value v; print_newline()
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

let repl () =

  let lexbuf = Lexing.from_channel stdin in
  (*ループ部分*)
  let rec loop_stdin env =
  
  let () = print_string "# " in
  let () = flush stdout in
  
  match Parser.command Lexer.token lexbuf with
  | r -> 
    (match print_command_result env r with
      | env' -> loop_stdin env'
      | exception Eval_error -> Printf.printf "exception: Eval_error\n"; loop_stdin env
      | exception Zero_Division -> Printf.printf "exception: Zero_Division\n"; loop_stdin env
      | exception Unexpected_Expression_at_binOp 
        -> Printf.printf "exception: Unexpected_Expression_at_binOp\n"; loop_stdin env 
      | exception Unexpected_Expression_at_eval_if
        -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; loop_stdin env
      | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; loop_stdin env
    )
  
    | exception Lexer.Error msg ->
      Printf.printf "Lexing Error\n" ;
      print_endline msg;
      loop_stdin env
    | exception Parsing.Parse_error ->
      Printf.printf "Parse Error "; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env
  
  in loop_stdin []

let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
    
  (*ループ部分*)
  let rec loop_file env= 
  match Parser.command Lexer.token lexbuf with 
  (*入力コマンドを実行し結果などをプリント->新たな環境を受け取る*)
  | r -> 
    (match print_command_result env r with
      | env' -> loop_file env'
      | exception Eval_error -> Printf.printf "exception: Eval_error\n";
      | exception Zero_Division -> Printf.printf "exception: Zero_Division\n";
      | exception Unexpected_Expression_at_binOp 
        -> Printf.printf "exception: Unexpected_Expression_at_binOp\n";
      | exception Unexpected_Expression_at_eval_if
        -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; 
      | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; 
    )
  | exception Lexer.Error msg -> Printf.printf "Lexing Error\n"; print_endline msg;
  | exception Parsing.Parse_error 
    ->  Printf.printf "Parse Error "; 
        Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf);
  
  in loop_file []