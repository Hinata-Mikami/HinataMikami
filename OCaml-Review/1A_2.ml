(*指数*)
let rec fib_1 n =
  if n = 1 || n = 2 then 1 
  else fib (n - 1) + fib (n - 2);;

(*線形*)
let rec fib_2 n =
  let rec fib_pair n =
    if n = 1 then (1, 0)
    else let (i, j) = fib_pair (n - 1) in (i + j, i)

  in let (i, _) = fib_pair n in i;;

(*対数*)
(*不明*)

(*行列 数値の部分をAとおく　Aのn乗演算は求められる*)
(*
F(n+2) = (1 1) (F(n+1))
F(n+1) = (0 0)  (F(n))
*)