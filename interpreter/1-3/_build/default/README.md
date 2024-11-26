## コンパイル方法
cd でsrcフォルダまで移動して以下を実行
'''''
ocamllex lexer.mll
ocamlyacc parser.mly
ocamlc -c syntax.ml
ocamlc -c parser.mli
ocamlc -c parser.ml
ocamlc -c lexer.ml
ocamlc -c eval.ml
ocamlc -c main.ml
ocamlc -o main syntax.cmo parser.cmo lexer.cmo eval.cmo main.cmo
'''''

## 実行方法
'''''
$ ./main
$ (文字列を入力) (ctrl+D)
'''''

## 実行結果
1 - 1 - 1 -> -1

3 * 2 / 3 -> 2

1 + 2 * 2 -> 5

1 + 1 < 1 + 1 -> false

if true then 1 else 2 + 1 -> 1

if if true then false else false then
    if true then true else true
  else
    if true then false else false  -> false

(4 + 3 ) * 10 - 5 * 2 - 1 -> 59