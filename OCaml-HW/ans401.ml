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