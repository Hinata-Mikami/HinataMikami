(*練習問題4.1*)
(*
let curry f x y = f (x , y) ;;

let average (x , y) = (x +. y) /. 2.0 ;;

let curried_avg = curry average ;;
*)

let uncurry f (x , y) = f x y ;;

(*
let avg = uncurry curried_avg in avg(4.0 , 5.3) ;;
*)

(*練習問題4.2*)
let rec repeat f n x = 
  if n > 0 then repeat f (n - 1) (f x) 
  else x ;;

let fib n =
  let (fibn , _) = 
    repeat (fun (a, b) -> (b, a + b)) n (0, 1)
  in fibn;;

(*練習問題4.3*)
let ($) f g x = f (g x) ;;

let id x = x ;;

let rec funny f n = 
  if n = 0 then id 
  else if n mod 2 = 0 then funny (f $ f) (n / 2) 
  else funny (f $ f) (n / 2) $ f ;;

(*
関数 f と整数 n を受け取り、log (n) 回の計算量で関数 f を n 回適用した関数を返す関数
n = 0 の時は恒等関数 id を返す
n が偶数の時は f を2倍にする
n が奇数の時は f を2倍し、さらに1回追加する
*)

(*練習問題4.4*)
(*
外側の関数から適用していくと、

s k k 1 -> k 1 (k 1) 　　(*k に引数として 1 と (k 1) を渡す*)
        -> 1 　　　　　　 (*(k 1) の値に関わらず 1 を返す*)

よって、恒等関数 id と同様に働く
*)

(*練習問題4.5*)
(*
twice twice f x -> twice (twice f) x
                -> twice f (twice f x)
                -> twice f (f (f x))
                -> f (f (f (f x)))

以上のステップより、twice を2回適用すると f (f (f (f x))) と同様に働く
*)

(*練習問題4.6*)
let k x y = x ;;
let s x y z = x z (y z) ;;

(*解けなかった*)