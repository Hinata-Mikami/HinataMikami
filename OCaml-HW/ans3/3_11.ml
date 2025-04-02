(* 1 *)
let rec gcd (m, n) =
  if n > m then
    if n mod m = 0 then m
    else gcd (m, n - m)
  else
    if m mod n = 0 then n
    else gcd (m - n, n);;

(* 2 *)
let rec comb (n, m) =
  if m = 0 || m = n then 1
  else comb (n-1, m) + comb (n-1, m-1);;

(* 3 *)
(* フィボナッチ数列 x(n) = x(n-1) + x(n-2) *)
let iterfib n =
  let rec tailfib (p, q, n) =
    (* tailfib (1番目, 0番目, 足す回数＝求めたいインデックス) *)
    (*p + qのとき*)
    if n = 0 then q
    (*その次は (p + q) + pになる*)
    else tailfib(p + q, p, n-1)
  in
  tailfib(1,0,n);;

(* 4 *)
let max_ascii s =
  let length = String.length s - 1 in
  let rec res_max (str, len, max) =
    if len = 0 then 
      if int_of_char str.[0] >= max then int_of_char str.[0]
      else max
    else
      if int_of_char str.[len] >= max 
        then res_max (s, len-1, int_of_char str.[len])
      else res_max (s, len-1, max)
in char_of_int (res_max (s, length, 0));;