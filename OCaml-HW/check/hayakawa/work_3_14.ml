let integral f a b = 
  let trapzoid f a_1 a_2 h = ((f a_1) +. (f a_2)) *. h /. 2. in
  let n = 1000 in
  let s = (b -. a) /. (float_of_int n) in
  let rec sum_of_trapezoid f a s n res i =
    if i = n then res
    else sum_of_trapezoid f a s n (res +. trapzoid f (a +. (float_of_int (i - 1)) *. s) (a +. (float_of_int i) *. s) s) (i + 1) in
  sum_of_trapezoid f a s n 0. 1;;

integral sin 0. 3.14;;