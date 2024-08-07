# コンパイル方法
以下を実行

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

## 5-4 解答

ones = [1; 1; 1; 1; 1; ...]
```
let rec ones = 1 :: ones;;
ones;;
```

nats = [0; 1; 2; 3; 4; ...]
```
let rec nats = fun x -> x :: nats (x+1);;
nats 0;;
```

fibs = [1; 1; 2; 3; 5; ...]
```
let rec fibs = fun x -> fun y -> (x + y) :: fibs y (x+y);;
fibs 1 0;;
```

## 5-5 解答
natPairs = [(0, 0), ... , (n, m), ...]
```
let rec sub_natPairs = fun x -> fun y -> (x, y) :: sub_natPairs x (y+1);;


let rec natPairs = fun x -> fun l ->
    match l with
    [] -> ( 
            match (sub_natPairs x 0) with
                hd :: tl -> hd :: natPairs (x+1) tl 
            end
            )
    | hd :: tl -> hd :: natPairs x tl
    end;; 

natPairs 0 [];;
```
