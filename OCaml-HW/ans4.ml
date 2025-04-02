(*4-1*)
let curry f x y = f (x, y);;
(*val curry : (’a * ’b -> ’c) -> ’a -> ’b -> ’c = <fun>*)
let average (x, y) = (x +. y) /. 2.0;;
(*val average : float * float -> float = <fun>*)
let curried_avg = curry average;;
(*val curried_avg : float -> float -> float = <fun>*)
average (4.0, 5.3);;
(*- : float = 4.65*)
curried_avg 4.0 5.3;;

let uncurry f (x, y) = f x y;;

let avg = uncurry curried_avg in avg (4.0, 5.3);;


(*4-2*)
(*fをn回xに適用する回数*)
let rec repeat f n x =
  if n > 0 then repeat f (n - 1) (f x) else x;;


let fib n =
  let (fibn, _) =
  (* (x1, x0) -> (x2, x1) = (x1+x0 + x1)*)
  let fib_next (x, y) = (x + y, x)
  in repeat fib_next n (1, 0)
in fibn;;


(*4-3*)
let id x = x;;

let ($) f g x = f (g x);;

let rec funny f n =
  if n = 0 then id
  else if n mod 2 = 0 then funny (f $ f) (n / 2)
  else funny (f $ f) (n / 2) $ f;;

  (* n=0のとき id,
     n=1のとき funny (f $ f) 0 $ f = id $ f = f
     n=2のとき funny (f $ f) 1 = id $ (f $ f) = (f $ f)
  のように，n個のfの合成関数を返すもの。   
  *)


(*4-4*)
s k k 1
(*
-> k 1 (k 1)
-> k 1 1
-> 1 
*)


(*4-5*)
let twice f x = f (f x);;

(*
  twice twice f x
  -> twice g x  (g = twice f とおく)
  -> g (g x)
  -> (twice f) (twice f x)
  -> twice f (f (f x))
  -> f (f (f (f x)))
*)

(*
  twice twice f x
->twice (twice f x)
->twice (f (f x))
= twice f$f x
-> f$f(f$f x)
= f$f$f$f x
= f(f(f(f x)))
*)


(*4-6*)
let k x y = x;;
let s x y z = x z (y z);;
let f x y = k (s k k) x y;;