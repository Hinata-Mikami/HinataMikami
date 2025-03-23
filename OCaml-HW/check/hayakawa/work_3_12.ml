let rec pos n = 
  if n = 0 then 1. -. (1. /. 3.)
  else pos (n - 1) +. (1. /. float_of_int (4 * n + 1)) -. (1. /. float_of_int (4 * n + 3));;

4. *. pos 200;;
4. *. pos 800;;