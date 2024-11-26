let rec twice f x = f (f x);;

let rec repeat n f x =
  match n with
  | 0 -> x
  | a -> f(repeat (n-1) f x);;

twice (fun x -> x + 1) 0;;
(*- : int = 2*)
repeat 5 (fun x -> x + 1) 0;;
(*- : int = 5*)