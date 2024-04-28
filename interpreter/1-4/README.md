## コンパイル方法
cd でsrcフォルダまで移動して以下を実行
srcディレクトリに移動して、
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
を実行

## 実行方法
$./main
> (文字列を入力) ;; (Enter)
