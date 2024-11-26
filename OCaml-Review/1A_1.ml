let rec sum_to n =
  match n with
  | 0 -> 0
  | _ -> n + sum_to (n-1);;

(*
# sum_to 10;;
- : int = 55
*)

let is_prime n =
  let rec is_prime_checker x c =
    if c=1 then false
    else
    match x with
    | 1 -> true
    | _ when c mod x = 0 -> false
    | _ -> is_prime_checker (x-1) c
  in is_prime_checker (n-1) n;;
    
(*
# is_prime 1;;
- : bool = false
# is_prime 2;;
- : bool = true
# is_prime 3;;
- : bool = true
# is_prime 4;;
- : bool = false
# is_prime 100;;
- : bool = false
# is_prime 101;;
- : bool = true
*)

let gcd m n =
  let rec euclid x y =
    match (x, y) with
    | (a, b) when a mod b = 0 -> b
    | (a, b) -> euclid b (a mod b)
  in 
  if m > n then euclid m n
  else euclid n m;;

(*
# gcd 3 27;;
- : int = 3
# gcd 9 27;;
- : int = 9
# gcd 1 2;;
- : int = 1
*)
