(* 練習問題 3.7 *)

(* o2 *)
let rec pow (x,n) = 
  if n = 0 then 1.
  else if n = 1 then x
  else (* n >= 2 *)
  let x_2 = pow (x, n/2)
  in
  x_2 *. x_2 *. (if n mod 2 = 0 then 1. else x)
;;
