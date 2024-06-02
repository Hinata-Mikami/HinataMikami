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
# duneを使うとき
## ビルド方法
main.ml等のファイルが置いてあるディレクトリに
dune
ファイルをコピーする。（従来使っていたもの）

srcフォルダがあるディレクトリに、
dune-project
example.opam
を作成する。

## 実行方法
dune build
dune exec example
または
dune exrc example src/test.txt

