(*練習問題3.1*)
let dollars_to_yen (n : float) = int_of_float(n *. 114.32);;

let yen_to_dollars (n : int) = floor(float_of_int n /. 114.32);;

let dollars_to_yen2 (n : float) = string_of_float n ^ " dollars are " ^ string_of_int (int_of_float(n *. 114.32)) ^ " yen.";;

let capitalize (n : char) = 
  if 97 <= (int_of_char n) && (int_of_char n) <= 122 then char_of_int((int_of_char n) - 32) 
  else n ;;

(*練習問題3.2*)
(*
if b1 = true 
  then if b2 = true then true
       else false
else false ;;
*)

(*
if b1 = true 
  then true
else if b2 = true then true
     else false ;;
*)

(*練習問題3.3*)
(*
not (not b1 || not b2)
*)

(*
not (not b1 && not b2)
*)

(*練習問題3.4*)
let x = 1 in let x = 3 in let x = x + 2 in x * x ;;
(* x = 1 を定義 → x = 3 に上書き → x = 3 を参照して x = x + 2 を計算 → 結果となる x = 5 を参照して x = x * x を計算
よって評価結果は 25 *)

let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y;;
(* ()内を先に計算するため、y = x and x = y + 2 を参照して x * y = (y + 2) * x を得る → 
x = 2 and y = 3 を参照して in 以下の (y + 2) * x + y を計算
よって計算結果は 13 *)

let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z ;;
(* x = 2 を定義 → y = 3 を定義 → x = 2 を参照して y = x に上書き → 
結果となる y = 2 を参照して z = y + 2 を計算 → 結果となる z = 4 を参照して x * y * z を計算
よって計算結果は 16*)

(*練習問題3.5*)
(*
let x = e1 and y = e2 ;; 
let x = e1 let y = e2 ;; 
前者の and の式では x = e1 と y = e2 は同時定義であり参照・被参照の関係がないため、
例えば e2 が x を含む場合にはエラーとなる
後者の let の式では x = e1 → y = e2 の順に定義されるため、
e2 が x を含む場合には y = e2 は x = e1 を参照して計算される
*)

(*練習問題3.6*)
let geo_mean p =
  let (x , y) = p in sqrt (x *. y) ;;

let bmi p =
  let (a , b , c) = p in 
  let d = c /. (b ** 2.) in
  if d < 18.5 then a ^ "さんはやせています"
  else if 18.5 <= d && d <25.0 then a ^ "さんは標準です"
  else if 25.0 <= d && d <30.0 then a ^ "さんは肥満です"
  else a ^ "さんは高度肥満です"
;;

let sum_and_diff (x , y) = (x + y , x - y) ;;
let f p = let (a , b) = p in (a + b) / 2 , (a - b) / 2 ;;

(*練習問題3.7*)
let rec pow (x , n) = 
  if n = 0 then 1. else pow (x , n - 1) *. x ;;

let pow2 (x , n) = 
  if n mod 2 = 0 then pow (x , n / 2) ** 2. 
  else pow (x , (n - 1) / 2) ** 2. *. x ;;

(*練習問題3.8*)
let rec iterpow (x , y , a , b) = 
  if a = 0 then y + b 
  else iterpow (x , y * x , a - 1 , b) ;;

(* y の初期値 1 と指数 a 、切片 b を与え、x に値を代入した時の値を求める*)
(* 必ず初期値を 1 に設定する y に関して他の記述の仕方がありそうだが思いつかなかった*)

(*練習問題3.9*)
(*let cond (b , e1 , e2) = if b then e1 else e2;;
let rec fact n = cond ((n = 1) , 1, n * fact (n - 1));;*)

(*
以上のように定義すると、
fact 4 = cond ((4 = 1) , 1 , 4 * fact (4 - 1)) の評価が始まるが、
このとき fact (4 - 1) の計算が優先される。
すなわち、n = 1 の時も fact (1 - 1)) の計算が優先されるため、
計算が終了せずスタックオーバーフローが生じる
*)

(*練習問題3.10*)
let rec fib n = 
  if n = 1 || n = 2 then 1 else fib(n - 1) + fib(n - 2);; 

(*
fib 4 -> if 4 = 1 || 4 = 2 then 1 else fib(4 - 1) + fib(4 - 2)
      -> fib(4 - 1) + fib(4 - 2)
      -> fib(3) + fib(2)
      -> (if 3 = 1 || 3 = 2 then 1 else fib(3 - 1) + fib(3 - 2)) + fib(2)
      -> (fib(3 - 1) + fib(3 - 2)) + fib(2)
      -> fib(2) + fib(1) + fib(2)
      -> (if 2 = 1 || 2 = 2 then 1 else fib(2 - 1) + fib(2 - 2)) + fib(1) + fib(2)
      -> 1 + fib(1) + fib(2)
      -> ... -> 1 + 1 + fib(2)
      -> ... -> 1 + 1 + 1
      -> 3
*)

(*練習問題3.11*)
let rec gcd(m , n) = 
  if m = n then m 
  else if n - m > m then gcd (m , n - m)
  else gcd(n - m , m) ;;

let rec comb(m , n) = 
  if m = 0 || m = n then 1 
  else comb(m , n - 1) + comb(m - 1 ,n - 1) ;;

let rec iterfib (i , res1 , res2 , n) = 
  if i = n then res2 
  else iterfib (i + 1 , res2 , res1 + res2 , n) ;;

(* 
初期値は以下
let fib n = iterfib(1 , 0 , 1 ,n) ;; 
*)

let rec max_ascii (i , res , x) = 
  if i = String.length x then char_of_int res 
  else if (int_of_char x.[i]) > res then max_ascii (i + 1 , (int_of_char x.[i]) , x) 
  else max_ascii (i + 1 , res , x) ;;

(*
let max x = max_ascii(1 , 0 , x) ;;
*)

(*練習問題3.12*)
let rec pos n = 
  if n < 0 then 0.0 
  else pos (n - 1) *. (-1.) +. 1. /. (float_of_int (2 * n + 1));;


(*練習問題3.13*)
let rec pow x n =
  if n = 0 then 1.
  else x *. pow x (n - 1) ;;

let rec pow' n x =
  if n = 0 then 1.
  else x *. pow' (n - 1) x ;;

let cube = pow' 3 ;;

(*cube 2.;;*)

(*指数が第2引数である場合は、引数の順番を入れ替える関数を用意する*)
let swap f x y = f y x ;;
let cube' = swap pow 3 ;;

(*練習問題3.14*)
let integral f a b n =
  let delta = (b -. a) /. float_of_int n in
  let rec sum_trapezoid i s =
    if i > n then s
    else 
      let area = ((f (a +. (float_of_int (i - 1)) *. delta)) +. (f (a +. (float_of_int i ) *. delta))) *. delta /. 2. in
      sum_trapezoid (i + 1) (s +. area)
    in sum_trapezoid 1 0. ;;

let pi = 3.1415926535 ;;
let integral_sin = integral sin 0. pi 10000 ;;

(*練習問題3.15*)
(*int -> int -> int -> int*)
(*３つの int 型の引数を持ち int 型の答えを返す関数*)
let example1 x y z = x + y + z ;;

(*(int -> int) -> int -> int*)
(*「int 型の引数を取って int 型の答えを返す関数」と「int 型の値」を引数に取って int 型の答えを返す関数*)
let example2 f x = f (x + 1) * 2;;


(*(int -> int -> int) -> int*)
(*「2つの int 型の引数を取って int 型の答えを返す関数」を引数に取って int 型の答えを返す関数*)
let example3 f = f 2 3 + 1;; 