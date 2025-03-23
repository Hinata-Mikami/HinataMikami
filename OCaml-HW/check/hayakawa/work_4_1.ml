let uncurry f (x, y) = f x y;;

let curried_average x y = (x +. y) /. 2.;;

let avg = uncurry curried_average;;

avg (4.0, 5.3);;