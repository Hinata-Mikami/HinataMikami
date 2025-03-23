let rec iterpow (x, i, res, n) = if i == n then res else iterpow(x, i+1, res * x, n);;

iterpow (2, 0, 1, 15);;