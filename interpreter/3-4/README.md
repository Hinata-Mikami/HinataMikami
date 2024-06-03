## コンパイル方法
cd でsrcフォルダまで移動して以下を実行

```
ocamllex lexer.mll  
ocamlyacc parser.mly  
ocamlc -c syntax.ml  
ocamlc -c parser.mli  
ocamlc -c parser.ml  
ocamlc -c lexer.ml  
ocamlc -c eval.ml  
ocamlc -c functions.ml  
ocamlc -c main.ml  
ocamlc -o main syntax.cmo parser.cmo lexer.cmo eval.cmo functions.cmo main.cmo
```

## 実行方法
```
$./main
# (文字列を入力) ;;
```

または
```
$./main test.txt
```  

## テストケース
### test1.txt

```
fun x -> fun y -> x + (fun x -> if x then 1 else 2) y;;
```
==> `- : Int -> Bool -> Int = <fun>`

### test2.txt

```
fun x -> fun y -> y x;;
```
==> `- : (t1 -> t2 -> t3) -> (t1 -> t2) -> t1 -> t3`

### test3.txt

```
fun x -> fun y -> fun z -> x z (y z);;
```
==> `fact : Int -> Int = <fun>`

### test4.txt

```
let fact = 
 let rec fix f = fun x -> f (fix f) x in
 fix (fun f -> fun x -> if x < 1 then 1 else x * f (x - 1));;
```
==> `fact : Int -> Int = <fun>`

### test5.txt

```
let rec loop x = loop x;;
```
==> `loop : t1 -> t2`

### test6.txt

```
let rec f x = x + 1
    and g x = if x then f 1 else f 2
in g true;;
```
==> `- : Int = 2`

### test7.txt

```
let f = fun x -> 1;;
```
==> `f : t1 -> Int = <fun>`
```
f 3;;
```
==> `- : Int = 1`
```
f;;
```
==> `- : Int -> Int = <fun>`

### test8.txt
```
let f = fun x -> 1;;
```
==> `f : t1 -> Int = <fun>`
```
let rec h x = let _ = f 3 in 1 and g x = h x;;
```
==> `h : t2 -> Int = <fun>`  
    `g : t2 -> Int = <fun>`
```
f;;
```
==> `f : Int -> Int`

### test9.txt
```
fun x -> x x;;
```
==> `Error`

### test10.txt
```
fun f -> (f 0 < 1) && f true;;
```
==> `Error`

## functions.ml
### `apply_ty_subst` ty_subst -> ty -> ty
型代入を行う関数。
`t_s : ty_subst = (ty_var * ty) list`と`t : ty`を受け取り、型代入リスト`t_s`のうち適当なものを`t`に代入する。  
具体的には、`t = TyVar tv`において`tv`がリスト`t_s`に含まれる組`(t_v', t')`の第1要素に既に存在するとき、`t_v`を`t_v'`に置き換える。  `t = TyFun (t1 t2)`のときは、再帰的に`t1`、`t2`に対して型代入を行う。
```OCaml
let rec apply_ty_subst (t_s : ty_subst) (t : ty) : ty =
  match t with
  | TyInt -> TyInt
  | TyBool -> TyBool
  | TyFun(t1, t2) -> TyFun(apply_ty_subst t_s t1, apply_ty_subst t_s t2)
  | TyVar t_v -> 
    (match t_s with
    | [] -> t
    | (t_v', t') :: rest when t_v' = t_v -> t'
    | (t_v', t') :: rest -> apply_ty_subst rest t
    )
```

### `compose_ty_subst` ty_subst -> ty_subst -> ty_subst
型代入の合成を行う関数。リスト`s1, s2 = ty_subst = (ty_var * ty) list`を受け取り、合成したリストを返す。  
`make_l2`関数では、型代入`s1`を`s2`の各要素`(t_v, t)`に行い、`l2`を得る。  
次に、`make_l1`関数で、型代入`s1`の各要素のうち既に`s2`に代入したものを削除したリスト`l1`を作成する。  
最後に、`l2`と`l1`を結合する。
```OCaml
let compose_ty_subst (s1 : ty_subst) (s2 : ty_subst) : ty_subst =
  let rec make_l2 s2 =
    match s2 with
    | [] -> []
    | (t_v, t) :: rest -> (t_v, apply_ty_subst s1 t) :: (make_l2 rest)
  in let l2 = make_l2 s2
  in
  let rec make_l1 s1 = 
    match s1 with
    | [] -> []
    | (t_v, t) :: rest ->
      (match List.assoc_opt t_v s2 with
      | Some x -> make_l1 rest
      | None -> (t_v, t) :: (make_l1 rest)
      )
  in let l1 = make_l1 s1
in l2 @ l1
```

### `check_var_fault`   string -> ty -> bool
単一化を行うために用意した関数。引数 `s` と `ty` を与え、`ty` が `TyVar t_v` のとき、`ty = s` でないことを確認する関数。
単一化を行う際、
```
unify ({α=t} ∪ C)= unify ({t=α} ∪ C) = unify ( C[α↦t] )∘[α↦t]
```
となるが、型制約`C`のうちの`α`を`t`で置き換える際、`t`は`α`を含んでいてはいけない。このことを保証するために使用する。
```OCaml
let rec check_var_fault (s : string) (t : ty) : bool =
  match t with
  | TyInt -> false
  | TyBool -> false
  | TyVar t_v -> if t_v = s then true else false
  | TyFun (t1, t2) -> check_var_fault s t1 || check_var_fault s t2
```

### `ty_unify`     ty_constraints -> ty_subst
型制約 `C : ty_constraints = (ty * ty) list`を受け取り、型制約の単一化を行う関数。  
単一化は以下のルールに基づいている。  
1. unify {} = {}
2. unify ( {s = s} U c) = unify c
3. unify ({ s1->t1 = s2->t2 } U c) = unify ({ s1=s2, t1=t2 } U c)
4. unify ({s = t} U C) = unify ({t = s} U C) = unify (( C[s ↦ t] )∘[s ↦ t])  
ただし、tはsを含んではいけないため、`check_var_fault s t`を行った後、`[(s, t)]`を型制約の残り`rest = (ty * ty) list`のそれぞれの`ty`に代入し、さらに`[(s, t)]`を連結する。
```OCaml
let rec ty_unify (c : ty_constraints) : ty_subst =
  match c with
  | [] -> []  (*1*)
  | (t1, t2) :: rest when t1 = t2 -> ty_unify rest  (*2*)
  | (TyFun (s1, t1), TyFun (s2, t2)) :: rest -> ty_unify ((s1, s2) :: (t1, t2) :: rest)  (*3*)
  | (TyVar s, t) :: rest | (t, TyVar s) :: rest -> (*4*)
    if check_var_fault s t then raise Type_error
    else compose_ty_subst
    (ty_unify (List.map (fun (t1, t2) -> (apply_ty_subst [(s, t)] t1, apply_ty_subst [(s, t)] t2)) rest)) [(s, t)]
  | _ -> raise Type_error
```

### `new_ty_var`   unit -> string
未定義の型変数 `t1, t2, ...` を導入するための関数。  
`let counter = ref 0` でカウンターの値を保持する領域を作成し、新たな型変数を作成する際は都度カウンタの値を取得し1加算した後、新しい型変数を`str`型で返す。
```OCaml
let counter = ref 0
let new_ty_var () =
  let current_count = !counter in
  counter := current_count + 1;
  "t" ^ string_of_int current_count
```

### `gather_ty_constraints`  ty_env -> expr -> ty * ty_constraints
型環境`t_e : ty_env = (name * ty) list`を受け取り、 型`expr`に含まれる型制約を収集し、`expr`の型と収集した型制約の組`ty * ty_constraints` を返す関数。
`expr`によって場合分けを行う。
1. ELiteral x  
   定数のときは,それ自身の型と空の制約を返す。`x`を`value`に直したうえで返り値を求める。
2. EVar x  
   変数のときは、型環境からxの型を検索する。存在する場合はそれと空の制約を返す。存在しない場合は `Error : Unbound value x`を投げる。
3. ELet (x, e1, e2) (let x = e1 in e2)  
   `(t1, c1) = (e1の型, 収集した制約)`としたうえで、`t_e` に `(x, t1)` を追加。そのうえで `e2` の型 `t2` と 型制約 `c2` を求める。  
   この式の最終的な型は`t2`。型制約は `c1 @ c2`。
4. EIf (e1, e2, e3) (if e1 then e2 else e3)  
   すべての`ei`について、型と制約`(ti, ci)`を求める。
   最終的な型と制約は `(t2, {t1=bool, t2=t3} U c1 U c2 U c3)`。
5. EFun (x, e) (fun x -> e)  
   新たな型変数`a = new_ty_var ()` を導入し、型環境`t_e`に`(x, TyVar a)`を追加。そのうえで`e`の型`t`と制約`c`を求める。  
   fun式全体の型は `a -> t` つまり `[TyFun (TyVar a, t)]`。fun式全体の制約は`c`。
6. EApp (e1, e2) (e1 e2)  
   `e1`・`e2`それぞれの型`t1`・`t2`と制約`c1`・`c2`を求める。  
   新たな型変数 `a = new_ty_var ()`としたうえで、式全体の型は `a`、制約は `{t1=t2→α}∪C1∪C2` つまり `[(t1, TyFun (t2, TyVar a))] @ c1 @ c2`
7. ERLetAnd (l, e) ただし `l : (name * name * expr) list` (let rec f x = e1 ... in e)  
   `l`の各要素に新たな型変数`a`,`b`を導入し、組`(f, x, e1, a, b)`のリスト`l'`を作る。  
   型環境`gamma`・・・`l'`の各`f, a, b`について、`t_e`に `f` と `a->b` の対応を追加する。つまり、`l'`の各要素について、`t_e`に`(f, TyFun (TyVar a, TyVar b))`を追加する。  
   次に、`gammma`の下で`e`の制約を収集し型`t`と制約`c`を得る。`t`は`e`の型。  
   次に、リスト`l'`の各要素`(f,x1,e1,a,b)`から`gamma`の下で`e1`の制約を収集し、`(t1,c1)`を得る。これを加工し`(t1, TyVar b, c1)`のリスト`ty_con_b`を得る。  
   最後にこのリストの各要素を分解しすべての`(t1, TyVar b)`と`c1`を`c`に結合してリスト`new_con`を得る。これが`e`の制約。
8. EBin(BinOp, e1, e2)
   EBinについても制約を収集できるようにしないとエラーを吐くことに気づいた。
   とりあえず、`e1`と`e2`の制約を収集し、得られた型`11, t2`について、OpEqの時は両者が`bool`であること、それ以外は両者が`int`であることを条件とし、それ以外はエラーを返すようにした。  

今後の改善   
ETuple, ENil, EConsは未実装。
   
```OCaml
let rec gather_ty_constraints (t_e : ty_env) (e : expr) : ty * ty_constraints =
  match e with
  | ELiteral x -> (*1*) 
    (match (Eval.value_of_literal x) with
    | VInt _ -> (TyInt, [])
    | VBool _ -> (TyBool, [])
    | _ -> raise Type_error
    )
  | EVar x ->  (*2*)
    (match List.assoc_opt x t_e with
    | Some x' -> (x', [])
    | None -> raise (Error (" : Unbound variable "^x))
    )
  | ELet (x, e1, e2) -> (*3*)
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints ((x, t1) :: t_e) e2 in
    (t2, c1 @ c2)
  | EIf (e1, e2, e3) -> (*4*)
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in
    let (t3, c3) = gather_ty_constraints t_e e3 in
    (t2, [(t1, TyBool); (t2, t3)] @ c1 @ c2 @ c3)
  | EFun (x, e) -> (*5*)
    let a = new_ty_var () in
    let (t, c) = gather_ty_constraints ((x, TyVar a) :: t_e) e in
    (TyFun (TyVar a, t), c)
  | EApp (e1, e2) -> (*6*)
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in 
    let a = new_ty_var () in
    (TyVar a, [(t1, TyFun (t2, TyVar a))] @ c1 @ c2)
  | ERLetAnd (l, e) -> (*7*)
    let l' = (List.map (fun (f,x1,e1) ->
      let a = new_ty_var () in
      let b = new_ty_var () in
      (f, x1, e1, a, b))
      l) in
    let gamma = 
      (List.map (fun (f,x1,e1,a,b) ->
      (f, TyFun (TyVar a, TyVar b)))
      l') @ t_e in
    let rec ty_con_b_list list =
      (match list with
      | [] -> []
      | (f,x1,e1,a,b) :: rest -> 
        let (t1, c1) = gather_ty_constraints gamma e1 in 
        (t1, TyVar b, c1) :: ty_con_b_list rest  
      ) in
    let (t, c) = gather_ty_constraints gamma e in      
    let rec new_con list' =
      (match list' with
      | [] -> c
      | (t1, t_vb, c1) :: rest -> ((t1, t_vb) :: c1) @ new_con rest  
      ) in
    (t, new_con (ty_con_b_list l'))

  | EBin (op, e1, e2) ->
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in
    (match op with
    | OpAdd | OpSub | OpMul | OpDiv | OpLt
      -> (
        match t1, t2 with
        | TyInt, TyInt -> (TyInt, (c1@c2))
        | _ -> raise (Error "Error : Variable types unmatched")
      )
    | OpEq -> 
      (match t1, t2 with
      | TyBool, TyBool -> (TyBool, (c1@c2))
      | _ -> raise (Error "Error : Variable types unmatched")
      )
    )

  | _ -> raise Type_error
```

## `infer_expr`  ty_env -> expr -> ty * ty_env
`expr`式の型推論の実装  

>式やコマンドを型推論することにより，その型変数に対する制約が生じることがあり，型環境をその情報を用いて更新しなければならない

資料の各ステップを実行  
1. 現在の型環境`t_e`において`e`を検査し`e`の型`t`と制約`c`を得る
2. 制約`c`を単一化し、型代入`t_s`を得る
3. `e`の型は`t`に`t_s`を適用したもの。新たな型環境は現環境の各要素`(n, ty)`の`ty`に`t_s`を適用したもの。

```OCaml
let rec infer_expr (t_e : ty_env) (e : expr) : ty * ty_env = 
  let (t, c) = gather_ty_constraints t_e e in
  let t_s = ty_unify c in
  (apply_ty_subst t_s t, List.map (fun (n, ty) -> (n, apply_ty_subst t_s ty)) t_e)
```

### `infer_cmd` ty_env -> command -> ty_env * ty_env
`command`式の型推論の実装  
> `infer_cmd`の返り値の組の第1要素は表示用  
> コマンドを型推論することにより，その型変数に対する制約が生じることがあり，型環境をその情報を用いて更新しなければならない

`cmd`を読み、`(推論したcmdの型環境, 更新した新たな型環境)`を返すように実装する。  
1. CExp e
  `t_e`の下で`e`を型推論して得られた型環境`t_e'`が、cmdの型推論の結果であり、新たな型環境でもある。  
2. CLet (n, e) `let n = e;;`  
  `t_e`の下で`e`を型推論して得られた型`t`が`n`の型である。 
3. CRLetAnd l   `let rec f x1 = e1 and f x2 = e2 ...`
   `l`は`(f, x1, e1)`のリスト。とりあえずERLetAndと同じようにやってみる...?
   新たな型変数`a, b`導入し、現在の環境`t_e`に`f`と`a -> b`の対応を追加。これを`l`のすべての要素において実行し型環境`gamma`を得る。
   この`cmd`の型のリスト`t_e_of_cmd`は、リスト`l'`の各要素において`gamma`に`x1`と`a`を追加したうえで`EFun(x, e1)`を型推論し、得られた型`t_i`を`f`の型とした。
   更新する型`new_t_e`は、上記の`(f. t_i)`と型環境`t_e_i`をリストにして得られる。  

```OCaml
let infer_cmd (t_e : ty_env) (cmd : command) : ty_env * ty_env =
  match cmd with
  | CExp e ->
    let (t, t_e') = infer_expr t_e e in
    (t_e', t_e')
  | CLet (n, e) ->
    let (t, t_e') = infer_expr t_e e in
    let newenv = (n, t) :: t_e' in
    ([(n, t)], newenv)
  | CRLetAnd l ->
    let l' = (List.map (fun (f,x1,e1) ->
    let a = new_ty_var () in
    let b = new_ty_var () in
    (f, x1, e1, a, b))
    l) in
    let gamma = 
      (List.map (fun (f,x1,e1,a,b) ->
      (f, TyFun (TyVar a, TyVar b)))
      l') @ t_e in
    let new_t_e = 
      List.fold_left (fun list (f,x1,e1,a,b) ->
        let (t_i, t_e_i) = infer_expr ((x1, TyVar a) :: gamma) (EFun (x1, e1)) in
        (f, t_i) :: t_e_i @ list) [] l' in
    let t_e_of_command = 
      (List.map (fun (f,x1,e1,a,b) ->
      let (t_i, _) = infer_expr ((x1, TyVar a) :: gamma) (EFun (x1, e1)) in
      (f, t_i))) l' in
    (t_e_of_command, new_t_e)
```

### `print_type` ty -> unit
`ty`の型を表示する関数
```OCaml
let rec print_type (t : ty) : unit =
  match t with
  | TyInt -> print_string "Int"
  | TyBool -> print_string "Bool"
  | TyFun (t1, t2) -> print_type t1; print_string " -> "; print_type t2
  | TyVar s -> print_string s
```

### `print_command_type` ty_env -> command -> ty_env
`command`の型推論を行い、得られた`ty_env`リストの各要素`(name, ty)`を用いてすべての`name`の型`ty`を表示する関数。
```OCaml
let print_command_type (t_e : ty_env) (cmd : command) : ty_env =

  let (t_e', t_e'') = infer_cmd t_e cmd in

  let rec print_command_loop (t_e : ty_env) : unit =
  match t_e with
  | [] -> ()
  | (name, ty) :: [] -> ();
    print_string (name ^ ": "); print_type ty
  | (name, ty) :: rest ->
    print_string (name ^ ": "); print_type ty; print_string "; "; print_command_loop rest
  in print_command_loop t_e';
  t_e''

```

### `print_value` value -> unit
`value`の型と値を表示する関数
```OCaml
let rec print_value (v: value) : unit =
  match v with
  | VInt i -> print_string "Int = "; print_int i 
  | VBool b -> print_string "Bool = "; print_string (string_of_bool b)
  | VFun (x, e, env) -> print_string " = <fun>"
  | VRFunAnd (_, l, _) -> print_string " = <fun>"
  | _ -> raise (Error "Error : Still developing")
```

### `print_command_value` env -> command -> ty_env -> env * ty_env
`command`の型を表示した後、`command`の値を評価し表示する関数。
```OCaml
let rec print_command_value (env : env) (cmd : command) (t_e : ty_env) : env * ty_env =
  let t_e' = print_command_type t_e cmd in
  match cmd with
  | CExp expr -> print_value (Eval.eval env expr); print_newline(); (env, t_e')
  | CLet (n, e) ->  print_string (" = "); 
    let command_let (env : env) (n : name) (e : expr) : (value * env) =
      (match Eval.eval env e with | v1 -> (v1, ((n,v1) :: env))) in
    let (v,e') = command_let env n e in print_value v; print_newline();
    (e', t_e')
  | CRLetAnd l ->
      let rec and_env (i: int) (l1: (name * name * expr) list) : env =
      match l1 with
        | [] -> env
        | (f, x, e) :: rest -> (f, VRFunAnd(i, l, env)) :: (and_env (i + 1) rest);
      in 
      let nenv = and_env 0 l in
      (nenv, t_e')
```

### `repl`
### `read_file`
メイン関数における一連の処理を行う部分。loop部分に`env`だけでなく`ty_env`も常に更新し続けるように変更している。
```OCaml
let repl () =

  let lexbuf = Lexing.from_channel stdin in

  let rec loop_stdin (env:env) (t_e : ty_env) =  
    let () = print_string "# " in
    let () = flush stdout in
  
    match Parser.command Lexer.token lexbuf with
    | r ->
      (match print_command_value env r t_e with
      | (env', t_e') -> loop_stdin env' t_e'
      | exception Eval_error -> Printf.printf "exception: Eval_error\n"; loop_stdin env t_e
      | exception Zero_Division -> Printf.printf "exception: Zero_Division\n"; loop_stdin env t_e
      | exception Unexpected_Expression_at_binOp 
        -> Printf.printf "exception: Unexpected_Expression_at_binOp\n"; loop_stdin env t_e
      | exception Unexpected_Expression_at_eval_if
        -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; loop_stdin env t_e
      | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; loop_stdin env t_e
      | exception Error s -> print_endline s; print_newline(); loop_stdin env t_e
      )
    | exception Lexer.Error msg ->
      Printf.printf "Lexing Error\n" ;
      print_endline msg;
      loop_stdin env t_e
    | exception Parsing.Parse_error ->
      Printf.printf "Parse Error "; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env t_e
  
  in loop_stdin [] []


let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
    
  let rec loop_file (env : env) (t_e : ty_env) = 
    match Parser.command Lexer.token lexbuf with 
    | r -> 
      (match print_command_value env r t_e with
      | (env', t_e') -> loop_file env' t_e'
      | exception Eval_error -> Printf.printf "exception: Eval_error\n";
      | exception Zero_Division -> Printf.printf "exception: Zero_Division\n";
      | exception Unexpected_Expression_at_binOp 
        -> Printf.printf "exception: Unexpected_Expression_at_binOp\n";
      | exception Unexpected_Expression_at_eval_if
        -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; 
      | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; 
      | exception Error s -> print_endline s; print_newline()
      )
    | exception Lexer.Error msg -> Printf.printf "Lexing Error\n"; print_endline msg;
    | exception Parsing.Parse_error 
      ->  Printf.printf "Parse Error "; 
          Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf);
  
  in loop_file [] []
```
