# コンパイル方法
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

# テストケース
## test1.txt

```
fun x ->
  match x with
    (a, b) -> a
  end;;
```
==> `- : t1 * t2 -> t1 = <fun>`

## test2.txt

```
fun x ->
  match x with
    (a, h :: t) -> h
  end;;
```
==> `- : t1 * [t2] -> t2 = <fun>`

## test3.txt

```
fun x ->
  match x with
    (a, h :: t) -> h
  | (a, []) -> a * 2
  end;;
```
==> `- : Int * [Int] -> Int = <fun>`

## test4.txt

```
fun x -> match x with end;;
```
==> `- : t1 -> t2`
