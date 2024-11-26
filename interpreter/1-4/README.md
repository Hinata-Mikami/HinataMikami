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
$./main
> (文字列を入力) ;; (Enter)


## duneの使い方
dune-project
example.opam

dune build
dune exec example
or
dune exrc example (相対パス:src/test1.txt)

