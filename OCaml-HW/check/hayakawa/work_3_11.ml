let rec gcd (m, n) =
  if n > m then
    if n mod m = 0 then m
    else gcd (m, n - m)
  else
    if m mod n = 0 then n
    else gcd (m - n, n);;

let rec comb (n, m) =
  if n = m || m = 0 then 1 
  else 
    comb (n-1, m) + comb (n-1, m-1);;

let rec iterfib (i, res_1, res_2, n) =
  if i = n then
    if i = 1 || i = 2 then 1
    else res_1 + res_2
  else
    if i = 1 then
      iterfib (i + 1, 0, 1, n)
    else
      iterfib (i + 1, res_2, res_1 + res_2, n);;

let rec max_ascii (i, res, s) = 
  let l = String.length s in
    if i = l then res
    else 
      let c = String.get s i in
        let x = int_of_char c in
          if x > res then max_ascii (i + 1, x, s)
          else max_ascii (i + 1, res, s);;

gcd (36, 42);;
comb (5, 2);;
iterfib (1, 0, 1, 5);;
max_ascii(0, 0, "Hello");;