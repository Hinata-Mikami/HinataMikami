let rec pos n = 
  let rec pos_rec(k, acc) =
    if k < 0 then acc
    else pos_rec(k-1, acc +. 1. /. (float_of_int (4 * k + 1))
    -. 1. /. (float_of_int (4 * k + 3)))
  in pos_rec(n, 0.)
