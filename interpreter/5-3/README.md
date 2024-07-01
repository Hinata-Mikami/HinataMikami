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
ocamlc -c functions_cbn.ml
ocamlc -c eval_cbn.ml
ocamlc -c main_cbn.ml  
ocamlc -o main syntax_cbn.cmo parser_cbn.cmo lexer_cbn.cmo functions_cbn.cmo eval_cbn.cmo main_cbn.cmo
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
(fun x -> fun y -> x) (1 / 0) (1 / 0);;
```
==> 実行時エラー

## 2-1
```
let head = fun x ->
  match x with
    h :: t -> h
  | [] -> 0
  end
in
head (5 :: (if (1/0) = 0 then [] else []));;
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

## 3-3
```
let rec take = fun n -> fun l ->
  if n < 1 then
    []
  else
    match l with
      h :: t -> h :: take (n - 1) t
    | _ -> []
    end
in 
let rec mylist = 0 :: 1 :: mylist in
take 5 mylist;;
```

==>  - : Int -> Int = <fun>`

## 3-4
```
let rec fix = fun f -> f (fix f) in
fix (fun f -> fun x -> if x < 1 then 1 else x * f (x - 1));;
```

==> `- : [Int] = [0,1,0,1,0]`

## 3-others
```
let rec f = fun x -> g x
and     g = fun x -> h x
and     h = fun x -> x * 2
in
f 3;;
```

```
let rec even = fun x -> if x = 0 then true else odd (x - 1)
and     odd  = fun x -> if x = 0 then false else even (x - 1)
in
even 3;;
```
