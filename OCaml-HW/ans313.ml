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