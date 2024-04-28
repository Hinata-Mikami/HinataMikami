(* f(x) = a ^ x　のとき，*)
let rec iterpow (a, x) =
  if x=0 then 1
  else a * iterpow (a, x-1);;
