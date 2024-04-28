type intseq = Cons of int * (int -> intseq);;

let fib = 
  let rec fib1 x0 x1 = Cons(x0, fun _ -> fib1 x1 (x0+x1))
in fib1 1 1;;

let rec nthseq n (Cons(x, f)) =
if n = 1 then x
else nthseq (n-1) (f x);;

(*Test*)
nthseq 10 fib;;
(*- : int = 55*)