let iterpow (a, n) =
  let rec iterpow_rec(v, m, acc) =
  if m == 0 then acc
  else iterpow_rec(v, m-1, v * acc)
in iterpow_rec(a, n, 1)