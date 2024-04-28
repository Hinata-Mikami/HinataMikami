(*
let rec pos n =
  neg (n-1) +. 1.0 /. (float_of_int (4 * n + 1))
  and neg n =
  if n < 0 then 0.0
  else pos n -. 1.0 /. (float_of_int (4 * n + 3));;
*)

let pos n = 
  let rec repeat x = 
    if x = 0 then 1. -. 1. /. 3.
    else repeat (x-1) +. 1. /. float_of_int (4 * x + 1) -. 1. /. float_of_int (4 * x + 3)
  in
  if n mod 2 = 0 then repeat (n/2)
  else let y = (n - 1) / 2 in repeat y +. 1. /. float_of_int (4* y + 1);;
