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
`s : ty_subst = (ty_var * ty) list`と`t : ty`を受け取り、型`t`(具体的には、`t = TyVar tv`のとき、 )が
```OCaml
let rec apply_ty_subst (s : ty_subst) (t : ty) : ty =
  match t with
  | TyInt -> TyInt
  | TyBool -> TyBool
  | TyFun(t1, t2) -> TyFun(apply_ty_subst s t1, apply_ty_subst s t2)
  | TyVar t_v -> 
    (match s with
    | [] -> t_v
    | (s', t') :: rest when s' = t_v -> t'
    | (s', t') :: rest -> apply_ty_subst rest t_v
    )
```
