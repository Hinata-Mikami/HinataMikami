let rec fold_right f l e =
match l with
  [] -> e
  | x :: rest -> f x (fold_right f rest e);;

let rec map f = function
  [] -> []
  | x :: rest -> f x :: map f rest;;

let rec concat list = fold_right (@) list [];;

let rec forall p list = fold_right (&&) (map p list) true;;

let rec exists p list = fold_right (||) (map p list) false;;


(*理解メモ*)
(*concatについて*)
(*
右からの畳み込み
fold_right f [a1; a2; ... ; an] e
-> f a1 (fold_right f [a2; ...; an]) e)
-> f a1 (f a2 fold_right [a3;...;an] e)
-> f a1 (f a2 ( ... (f an e) ) ) 

fが@(append), e = []のとき, 
a1 @ (a2 @ (... @ (an @ [])))
->a1 @ (a2 @ [...; an])
->a1 @ [a2; ...; an]
->[a1; a2; ...; an]  

an@[] は anがリストのとき単なるリストの連結だから，この操作でリスト内のすべてのリストを連結することになる
*)

(*forallについて*)
(*
map p list で list = [a1; a2; ...; an]とすると
[p a1; p a2; ...; p an]がつくれる。それぞれはbool。
これにより，
fold_right (&&) (map p list) true
は，
(p a1) && (p a2) && ... && (p an) && true
となる。

existsも同様の考え方。
*)
(*
与えられたリストのリストに対し，内側のリストの要素を並べたリストを返す関数concat。

let rec concat list =
  match list with 
    [] -> []
  | x::rest -> x @ (concat rest);;

  @:2つのリストを連結

forallは，与えられたリスト要素すべてが，ある与えられた性質を満たすかどうかを検査する関数です。「性質」というのは，例えば「～は5 以上の整数である」というようなことです（一般には，述語（predicate）と言います）。

let rec forall p = function
[] -> true
| x :: rest -> if p x then forall p rest else false;;


リストの中に性質を満たす要素があるかどうかを検査する関数が以下のexists です。

let rec exists p = function
[] -> false
| x :: rest -> (p x) || (exists p rest);;
val exists : (’a -> bool) -> ’a list -> bool
*)