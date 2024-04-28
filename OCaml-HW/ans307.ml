(* 1 *)
let pow (x, n) = 
  let rec repeat(variable, attempt) = 
    if attempt = 0 then 1 
    else variable * repeat(variable, attempt - 1)
  in
  repeat(x, n);;
  
(* 2 *)
let pow2 (x, n) =
  let rec repeat2(variable, attempt) = 
    if attempt = 0 then 1
    else if attempt mod 2 = 0
      then let result = repeat2(variable, attempt/2)
      in result * result
    else  variable * repeat2(variable, attempt-1)
  in repeat2(x, n);;

