(* 1 *)
let pow (x, n) = 
  let rec pow_rec(v, m, acc) = 
    if m = 0 then acc
    else pow_rec(v, m-1, v * acc)
  in pow_rec(x, n, 1)
  
(* 2 *)
let pow2 (x, n) =
  let rec pow_rec2(v, m, acc) = 
    if m = 0 then acc
    else if (m mod 2) == 0 then pow_rec2(v * v, m/2, acc)
    else pow_rec2(v, m-1, v * acc)
  in pow_rec2(x, n, 1)