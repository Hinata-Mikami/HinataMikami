(*5-1*)
(*
1.　正　
2.　誤　データ型が異なる
3.　正
4.　正　→誤り　右結合であり， 2 :: [[]] は型が不適切 
5.　正
6.　誤　データ型がintとbool -> 正（データ型はどちらもbool）  
*)


(*5-2*)
(* 1 *)
let rec downto1 n =
  match n with 
    1 -> [1];
  | _ -> n :: downto1 (n - 1);;

downto1 6;;


(* 2 *)
let rec roman l n =
  match l with
    [] -> ""
  | (x, y)::rest when x <= n -> y ^ (roman ((x, y)::rest)  (n-x)) 
  | (x, y)::rest when x > n -> roman rest n;;

roman [(1000, "M"); (500, "D"); (100, "C"); (50, "L"); (10, "X"); (5, "V"); (1, "I")] 1984;;
roman [(1000, "M"); (900, "CM"); (500, "D"); (400, "CD"); (100, "C"); (90, "XC"); (50, "L"); (40, "XL"); (10, "X"); (9, "IX"); (5, "V"); (4, "IV"); (1, "I")] 1984;;


(* 3 *)
let nested_length list =
  let rec num_of_list l = 
    match l with
      [] -> 0
    | _::[] -> 1
    | _::rest -> 1 + (num_of_list rest)
  in 
  let rec length l = 
    match l with
      [] -> 0
    | x::rest -> (num_of_list x) + (length rest)
in length list;;

nested_length [[1; 2; 3]; [4; 5]; [6]; [7; 8; 9; 10]];;


(* 4 *)
let rec concat list =
  match list with 
    [] -> []
  | x::rest -> x @ (concat rest);;

concat [[0; 3; 4]; [2]; []; [5; 0]];;


(* 5 *)
let rec zip la lb =
  match (la, lb) with
    ([], _) -> []
  | (_, []) -> []
  | (a::rest, b::rest') -> (a, b)::(zip rest rest');;

zip [2; 3; 4; 5; 6; 7; 8; 9; 10; 11] [true; true; false; true; false; true; false; false; false; true];;


(* 6 *)
let rec unzip list =
  let rec unzip_a l =
    match l with
      [] -> []
    | (a, b)::rest -> a::(unzip_a rest)
  in
  let rec unzip_b l =
    match l with
      [] -> []
    | (a, b)::rest -> b::(unzip_b rest)
  in (unzip_a list, unzip_b list);;

unzip (zip [2; 3; 4; 5; 6; 7; 8; 9; 10; 11] [true; true; false; true; false; true; false; false; false; true]);;


(* 7 *)
let rec filter f list =
  match list with
    [] -> []
  | x::rest when f x -> x::(filter f rest)
  | x::rest -> filter f rest;;

let is_positive x = (x > 0);;

let rec length = function (*p.90より*)
  [] -> 0
  | _ :: rest -> 1 + length rest;;

filter is_positive [-9; 0; 2; 5; -3];;
filter (fun l -> length l = 3) [[1; 2; 3]; [4; 5]; [6; 7; 8]; [9]];;


(* 8 *)
let rec take n list =
  match list with
    [] -> []
  | x::rest when n > 0 -> x::take (n-1) rest
  | x::rest -> [];;

let rec drop n list =
  match list with
    [] -> []
  | x::rest when n > 0 -> drop (n-1) rest
  | x::rest -> x::(drop (n-1) rest);; 

let ten_to_zero = downto1 10;;
take 8 ten_to_zero;;
drop 7 ten_to_zero;;


(* 9 *)
let max_list list =
  let rec search n l = 
    match l with
      [] -> n
    | x::rest when x >= n -> search x rest
    | x::rest -> search n rest
  in search 0 list;;


(*5-3*)
(* 1 *)
let rec mem a s =
  match s with
    [] -> false
  | x::rest when x = a -> true
  | x::rest -> mem a rest;;

(*
# mem 1 [0; 1; 3; 7];;
- : bool = true
# mem 0 [7; 5; 8];;
- : bool = false
# mem 2 [];;  
- : bool = false
*)


(* 2 *)
let rec intersect s1 s2 =
  match s1 with
    [] -> []
  | x::rest when mem x s2 -> x::(intersect rest s2)
  | x::rest -> intersect rest s2;;

(*
# intersect [1;2;3;4;5] [6;7;8;9;10];;
- : int list = []
# intersect [0;1;2] [1;2;3];;
- : int list = [1; 2]
# intersect [0;1;2] [8;9;0;1];;
- : int list = [0; 1]
# intersect [11;22;33] [11;22;33];;
- : int list = [11; 22; 33]
*)


(* 3 *)
let rec union s1 s2 =
  match s1 with
  [] -> s2
  | x::rest when mem x s2 -> union rest s2
  | x::rest -> x::(union rest s2);; 

(*
# union [0;1;2] [3;4;5];;
- : int list = [0; 1; 2; 3; 4; 5]
# union [0;1;2] [1;2;3];;
- : int list = [0; 1; 2; 3]
# union [1;2;3] [0;1;2];;
- : int list = [3; 0; 1; 2]
# union [0;1;2] [0;1;2];;
- : int list = [0; 1; 2]
*)


(* 4 *)
(*s1とs2の差集合 = s1には属するがs2には属さない*)

let rec diff s1 s2 =
    match s1 with 
      [] -> []
    | x::rest when (mem x s2) = false -> x::(diff rest s2)
    | x::rest -> diff rest s2;;

(*
# diff [0;1;2] [0;1;2];;
- : int list = []
# diff [0;1;2] [1;2;3];;
- : int list = [0]
# diff [0] [1;2;3];;
- : int list = [0]
# diff [0;1;2] [3];;  
- : int list = [0; 1; 2]
*)


(*5-4*)
(*
map 関数は，リスト処理には欠かせない汎用的な関数です。
関数fとリスト[a1; a2;...; an] から，
f を各要素に適用したようなリスト
[f a1; f a2; ...; f an] 
を計算します。
map は関数を引数に取る高階関数です。

map の定義は以下のように与えられます。
*)
let rec map f = function
[] -> []
| x :: rest -> f x :: map f rest;;


(* map f (map g l) -> map (fun x -> ...) l*)

map (fun x -> f (g x)) l;;


(*5-5*)
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


(*5-6*)
(*改前後のクイックソート*)
let rec quick_sort = function
    ([] | [_]) as l -> l
  | pivot :: rest 
  -> let rec partition left right = function
        [] -> let rec merge l1 l2 =
          match l1 with
            [] -> l2
            | x::rest -> x::(merge rest l2)
          in merge (quick_sort left) (pivot :: quick_sort right)
      
        | y :: ys -> if pivot < y then partition left (y :: right) ys else partition (y :: left) right ys
    in partition [] [] rest;;

(*
quick_sort [7;6;5;4;3;2;1;0];;
- : int list = [0; 1; 2; 3; 4; 5; 6; 7]   
*)

(* 改善前のクイックソート *)
let rec quick_sort_p105 = function
  (*パターン1*)
    (*空リストor1要素リスト->*)
    (*l には[]か[_]のどちらかが束縛される*)
    ([] | [_]) as l -> l

  (*パターン2*)
    (*2要素以上->先頭がpivot*)
  | pivot :: rest 

    (*partition関数を局所定義*)
  -> let rec partition left right = function

      (*パターン2-1*)
        (*[]に適用->left rightに2分割してソートした結果を結合して返す*)
        [] -> (quick_sort_p105 left) @ (pivot :: quick_sort_p105 right)

      (*パターン2-2*)
        (*要素/リストに適用->先頭がpivotより大きいときrightに結合，そうでないときはleftに結合。ここここまでの操作を要素数が1以下になるまで繰り返す*)

      | y :: ys -> if pivot < y then partition left (y :: right) ys else partition (y :: left) right ys

      (*はじめはleftもrightも空リスト*)
    in partition [] [] rest;;


(*5-7*)
let rec squares r =
  (*探査範囲の上限を決定。sqrt()の値は切り捨てでよい。
    (上限を議論するのはrが平方数の2倍のときであり，このときsqrt()は整数)*)
  let sup = int_of_float (sqrt ( (float_of_int r)/. 2.))
  in

  (*平方数かどうかを判定。bool型を返す*) 
  let is_square n =
    let tmp  = int_of_float (sqrt (float_of_int n))
      in if tmp * tmp = n then true else false
  in 

  (*リストの組をすべて反転させる関数*)
  let rec convert list =
    match list with
      [] -> []
    | (x, y)::rest -> (y, x)::(convert rest)
  in

  (*0<=x<=supで解に適するものを探索しリストに保存*)
  (*引数a:範囲の最小値 b:範囲の最大値 c:r*)
  let rec search_squares a b c =
    match a with
      x when x > b -> []
    | x when (x <= b) && (is_square (c - x*x)) 
    -> (x, int_of_float (sqrt ( float_of_int (c - x*x))))::(search_squares (x+1) b c)
    | x when x <= b -> search_squares (x+1) b c
  in 
  convert (search_squares 0 sup r);;

squares 48612265;;


(*構想*)
(*
  x^2 + y^2 = r
について，
  2x^2 <= r
  x^2 <= r/2
  x <= sqrt (r/2)
より，x <= sqrt (r/2)を走査すればよい
r/2 < x^2 <= r については考える必要がない。

この範囲で，あるx^2に対し
  r - x^2 = y^2
となる整数yを探す。そのためにはある整数が平方数であるかどうかを判定する関数が必要

よって，方針は
sqrt(r/2)を計算-> sup = int_of_float sqrt (r/2)
ある任意整数nが平方数であるかどうかを判定する関数を作成

0 <= x <= sup における各xについて，
r - x^2　を計算しこれが平方数であるかどうか判定 trueならリストに保存

リストを返す。

なお，x>=y>=0が条件なのに対し，このままではy>=x>=0の組として求まってしまうので，
リストの組(a, b)をすべて(b, a)に反転し出力する。

*)


(*5-8*)
(*
let rec map f = function
  [] -> []
  | x :: rest -> f x :: map f rest;;
*)

let map2 f list=
  let rec map g l =
    match l with
      [] -> []
      | x::rest -> g x :: map g rest
  in map f list;;  