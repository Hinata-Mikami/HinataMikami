# コンパイル方法
cd でsrcフォルダまで移動して以下を実行
## 値呼び

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

## 名前呼び
```
ocamllex lexer_cbn.mll  
ocamlyacc parser_cbn.mly  
ocamlc -c syntax_cbn.ml  
ocamlc -c parser_cbn.mli  
ocamlc -c parser_cbn.ml  
ocamlc -c lexer_cbn.ml  
ocamlc -c eval_cbn.ml
ocamlc -c functions_cbn.ml
ocamlc -c main_cbn.ml  
ocamlc -o main syntax_cbn.cmo parser_cbn.cmo lexer_cbn.cmo eval_cbn.cmo functions_cbn.cmo main_cbn.cmo
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

# テストケース
## 1-1

```
let z = 1 / 0;;
```
==> zを評価してしまうとエラーが起きるのでzの型のみを表示するとよいでしょう

## 1-2

```
1 / 0;;
```
==> 実行時エラー

## 1-3

```
(fun x -> 42) (1 / 0);;
```
==> ` - : Int = 42`

## 1-4

```
(fun x -> fun y -> x) 5 (1 / 0);;
```
==> `- : Int = 5`

## 1-5
```
(fun x -> fun y -> x) (loop ()) (1 / 0);;
```
==> 実行時エラー loop定義不可？

## 2-1
```
let head = fun x ->
  match x with
    h :: t -> h
  | [] -> 0
  end
in
head (5 :: (1 / 0));;
```
==> `- : Int = 5` 

## 2-2
```
let fst = fun x ->
  match x with
    (x, y) -> x
  end
in
fst (5, (1 / 0));;
```
==> `- : Int = 5` 
