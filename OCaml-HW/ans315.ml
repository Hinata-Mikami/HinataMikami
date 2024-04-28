(*
int -> int -> int -> int　は，3つの整数を順番に引数として受け取り。整数を返すもの   
*)

let f1 x1 x2 x3 = x1 + x2 + x3;;

(*
(int -> int) -> int -> int は，右結合であり，(int -> int) -> (int -> int)の意味。

*)
 
let f2 f = fun x -> f(2*x) - f(x);;

(*
(int -> int -> int) -> int は (int -> (int -> int)) -> int) のこと。
関数に2つの引数を入れる必要がある。
*)

let f3 f = 0 * f 1 1 ;;
