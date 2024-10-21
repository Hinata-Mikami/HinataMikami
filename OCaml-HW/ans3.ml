(*3-1*)
(* 1 *)
let yen_of_dollar x =
  let y = x *. 114.32 in
  if y -. (floor y) >= 0.5 then int_of_float(floor y +. 1.0) 
  else int_of_float (floor y);;

(* 2 *)
let dollar_of_yen (x : int) =
  let y = float_of_int x /. 114.32 *. 100. in
  if y -. (floor y) >= 0.5 then (floor y +. 1.0) /. 100.
  else (floor y) /. 100.;;

(* 3 *)
let exchange x =
  let y = yen_of_dollar x in
  (string_of_float x) ^ " dollars are " ^ (string_of_int y) ^ " yen.";;

(* 4 *)
let capitalize (x : char) =
  let y = int_of_char x in
  if 97 <= y && y <= 122
    then char_of_int (y - 32)
    else x;;


(*3-2*)
(*
    b1&&b2 = if (b1 == true) then b2 else false
    b1||b2 = if (b1 == true) then true 
                else if (b2 == true) then true else false 
*)


(*3-3*)
(*

b1&&b2 = not ((not b1)||(not b2))
b1||b2 = not ((not b1)&&(not b2))

*)


(*3-4*)
(* 1 *)
let x = 1 in let x = 3 in let x = x + 2 in x * x;;
(*  予想
    x + 2の参照は x = 3
    x * xの参照は x = 3 + 2 = 5
    結果：5 * 5 = 25
*)

(* 2 *)
let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y;;
(*  予想(誤り)
    y = xの参照は x = 2
    y = x + 2 の参照は y = 2
    結果は x * y + y = 2 * 2 + 2 = 6
*)

(*　結果　13
    y = xの参照は x = 2
    y = x + 2 の参照は y = 3
    x * y = 2 * 5 = 10
    + y の参照は y = 3
    結果　10 + 3 = 13
*)

(* 3 *)
let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z;;
(*  予想
    y = xの参照は x = 2
    z = y + 2の参照はy = 2
    結果は x * y * z = 2 * 2 * 4 = 16
*)


(*3-5*)
(*
let x = e1 and y = e2
    ->let (x = e1 and y = e2)
のように，e1とe2を同時に参照する。
このため，e2の中にxが含まれていたとしても，
仮に初めにxが x = e0 と定義されていればe2内のxはe0を参照する。

let x = e1 let y = e2  
    ->let x = e1 ;;
      let y = e2 ;;
のように，e1とe2を順に参照する。
このため，e2の中にxが含まれていたとすれば，そのxはe1である。

*)


(*3-6*)
(* 1 *)
let geo_mean (x, y) =  sqrt (x *. y);;

(* 2 *)
let bmi (n, l, m) = 
    let b = m /. ((l /. 100.) *. (l /. 100.)) in 
    if b <= 18.5 then n ^ "さんは やせ です"
    else if b <= 25. then n ^ "さんは 標準 です"
    else if b <= 30. then n ^ "さんは 肥満 です"
    else n ^ "さんは 高度肥満 です";;

(* 3 *) 
(* x -> x+y , y -> x-y なので， (x, y)を返すには...*)
let f (x,y) = ((x + y)/2, (x - y)/2);;


(*3-7*)
(* 1 *)
let pow (x, n) = 
  let rec repeat(variable, attempt) = 
    if attempt = 0 then 1 
    else variable * repeat(variable, attempt - 1)
  in
  repeat(x, n);;
  
(* 2 *)
let pow2 (x, n) =
  let rec repeat2(variable, attempt) = 
    if attempt = 0 then 1
    else if attempt mod 2 = 0
      then let result = repeat2(variable, attempt/2)
      in result * result
    else  variable * repeat2(variable, attempt-1)
  in repeat2(x, n);;


(*3-8*)
(* f(x) = a ^ x　のとき，*)
let rec iterpow (a, x) =
  if x=0 then 1
  else a * iterpow (a, x-1);;


(*3-9*)
let cond (b, e1, e2) : int = if b then e1 else e2;;
(*val cond : bool * int * int -> int = <fun>*)
let rec fact n = cond ((n = 1), 1, n * fact (n-1));;
(*val fact : int -> int = <fun>*)
fact 4;;
(*????*)

(* Stack overflow during evaluation *)
(* 
  fact関数において，cond関数の第3引数が再帰呼び出しになっており，
  この再帰呼び出しの評価が終わって初めてcond関数の評価が行われるが，
  再帰呼び出しを終了する処理がないため無限に計算され続けてしまう
*)


(*3-10*)
let rec fib n = (* n 番目のフィボナッチ数*)
if n = 1 || n = 2 then 1 else fib(n - 1) + fib(n - 2);;

  (*val fib : int -> int = <fun>*)

  (* 

  fib 4
  -> if 4=1 || 4=2 then 1 else fib(4-1) + fib(4-2)
  -> if false then 1 else fib(4-1) + fib(4-2)
  -> fib(4-1) + fib(4-2)
  -> fib 3 + fib 2

  fib 3
  -> if 3=1 || 3=2 then 1 else fib(3-1) + fib(3-2)
  -> if false then 1 else fib(3-1) + fib(3-2)
  -> fib(3-1) + fib(3-2)
  -> fib 2 + fib 1

  fib 2
  -> if 2=1 || 2=2 then 1 else fib(2-1) + fib(2-2)
  -> if true then 1 else fib(2-1) + fib(2-2)
  -> 1 

  fib 3
  -> 1 + fib 1

  fib 1
  -> if 1=1 || 1=2 then 1 else fib(1-1) + fib(1-2)
  -> if true then 1 else fib(1-1) + fib(1-2)
  -> 1 

  fib 3
  -> 1 + 1
  -> 2

  fib 4
  -> 2 + fib 2

  fib 2
  -> if 2=1 || 2=2 then 1 else fib(2-1) + fib(2-2)
  -> if true then 1 else fib(2-1) + fib(2-2)
  -> 1 

  fib 4
  -> 2 + 1
  -> 3
  
  *)


(*3-11*)
(* 1 *)
let rec gcd (m, n) = 
  if m mod n = 0 then n
  else gcd(n, m mod n);; 

(* 2 *)
(*
  nCm = (n, m)
  0 <= m < n
  (n, 0) = (n, n) = 1
  (n, m) = (n-1, m) + (n-1, m-1)   
*)

let rec comb (n, m) =
  if m = 0 || m = n then 1
  else comb (n-1, m) + comb (n-1, m-1);;

(* 3 *)
(* フィボナッチ数列 x(n) = x(n-1) + x(n-2) *)
let iterfib n =
  let rec tailfib (p, q, n) =
    (* tailfib (1番目, 0番目, 足す回数＝求めたいインデックス) *)
    (*p + qのとき*)
    if n = 0 then q
    (*その次は (p + q) + pになる*)
    else tailfib(p + q, p, n-1)
  in
  tailfib(1,0,n);;

(* 4 *)
let max_ascii s =
  let length = String.length s - 1 in
  let rec res_max (str, len, max) =
    if len = 0 then 
      if int_of_char str.[0] >= max then int_of_char str.[0]
      else max
    else
      if int_of_char str.[len] >= max 
        then res_max (s, len-1, int_of_char str.[len])
      else res_max (s, len-1, max)
in char_of_int (res_max (s, length, 0));;


(*3-12*)
(*
let rec pos n =
  neg (n-1) +. 1.0 /. (float_of_int (4 * n + 1))
  and neg n =
  if n < 0 then 0.0
  else pos n -. 1.0 /. (float_of_int (4 * n + 3));;
*)

let pos n = 
  let rec repeat x = 
    if x = 0 then 1. -. 1. /. 3.
    else repeat (x-1) +. 1. /. float_of_int (4 * x + 1) -. 1. /. float_of_int (4 * x + 3)
  in
  if n mod 2 = 0 then repeat (n/2)
  else let y = (n - 1) / 2 in repeat y +. 1. /. float_of_int (4* y + 1);;


(*3-13*)
(* 3.7 *)
let pow0 (x, n) = 
  let rec repeat(variable, attempt) = 
    if attempt = 0 then 1 
    else variable * repeat(variable, attempt - 1)
  in
  repeat(x, n);;

(* 3.13 *) 
(*カリー化*)
let pow x n =
  let rec repeat f n=
    (*repeat関数の定義*)
    if n = 0 then 1 (*n = 0 なら1*)
    (*n-1番目のrepeat関数の演算結果にf n (x)をかける *)  
    else (repeat f (n-1)) * f n
    (*repeat (xを受け取ってyに代入) n*) 
  in repeat (fun y -> x) n;; 

(*3乗するcube*)
let pow2 n x =
  let rec repeat f n =
    if n = 0 then 1 
    else (repeat f (n-1)) * f n
  in repeat (fun y -> x) n;;
  
let cube x = pow2 3 x;;

(*powから定義されたcube*)
let cube x = pow x 3;;


(*3-14*)
(*1000分割した場合を考える*)(*0<=n<=999*)
(*n番目の台形1つあたりの面積*)

let area f a b n =
  (f(a +. (float_of_int n)*. (b -. a) /. 1000.) +. f(a +. (float_of_int n +. 1.)*. (b -. a) /. 1000.))*. (b -. a) /. 1000. /. 2.;;

let rec sum f n =
  if n = 0 then 0. 
  else sum f (n - 1) +. f n;;

let integral f a b = sum (area f a b) 999;;

integral sin 0. 3.1415926;;


(*3-15*)
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