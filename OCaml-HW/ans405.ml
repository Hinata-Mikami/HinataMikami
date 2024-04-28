let twice f x = f (f x);;

(*
  twice twice f x
->twice (twice f x)
->twice (f (f x))
= twice f$f x
-> f$f(f$f x)
= f$f$f$f x
= f(f(f(f x)))
*)