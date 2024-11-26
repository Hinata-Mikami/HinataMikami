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
ocamlc -c functions.ml
ocamlc -c main.ml
ocamlc -o main syntax.cmo parser.cmo lexer.cmo eval.cmo functions.cmo main.cmo
'''''

typeに関する関数のみ実行
'''''
ocaml
#use "types.ml";;
'''''

## 実行方法
$./main
> (文字列を入力) ;; (Enter)

または
$./main test.txt (Enter)./main