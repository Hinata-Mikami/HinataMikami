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


## functions.ml
### apply_ty_subst
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

### compose_ty_subst
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

### check_var_fault
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

### ty_unify
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

### new_ty_var
未定義の型変数 `t1, t2, ...` を導入するための関数。  
`let counter = ref 0` でカウンターの値を保持する領域を作成し、新たな型変数を作成する際は都度カウンタの値を取得し1加算した後、新しい型変数を`str`型で返す。
```OCaml
let counter = ref 0
let new_ty_var () =
  let current_count = !counter in
  counter := current_count + 1;
  "t" ^ string_of_int current_count
```

### gather_ty_constraints
型環境`ty_env = (name * ty) list`を受け取り、 `型`expr`に含まれる型制約を収集し、型と型制約の組`ty * ty_constraints` を返す関数。
`expr`によって場合分けを行う。
1. ELiteral x
   定数のときは,それ自身の型と空の制約を返す。`x`を`value`に直したうえで返り値を求める。
2. EVar x
   変数のときは、型環境からxの型を検索する。存在する場合はそれと空の制約を返す。存在しない場合は `Error : Unbound value x`を投げる。
```OCaml
let rec gather_ty_constraints (t_e : ty_env) (e : expr) : ty * ty_constraints =
  match e with
  | ELiteral x  (*1*) 
    ->(match (Eval.value_of_literal x) with
      | VInt _ -> (TyInt, [])
      | VBool _ -> (TyBool, [])
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
```
