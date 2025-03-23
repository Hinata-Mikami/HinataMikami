(* 練習問題 3.7 *)

(* o1 *)
let rec pow (x,n) = 
  if n = 0 then 1.
  else pow (x, n-1) *. x;;
