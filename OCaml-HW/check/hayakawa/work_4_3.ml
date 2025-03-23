let id x = x;;

let ($) f g x = f (g x);;

let rec funny f n =
  if n = 0 then id
  else if n mod 2 = 0 then funny (f $ f) (n / 2)
  else (funny (f $ f) (n / 2)) $ f;;

let mul x = x * x;;

let pow = funny mul;;

pow 2 2;;
pow 3 2;;
pow 4 2;;

(*funny関数はfを2^n-1回行うような関数を出力する*)