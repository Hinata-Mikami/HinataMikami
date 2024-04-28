type nat = Z | S of nat

let rec add m n =
  match m with 
  | Z -> n 
  | S m' -> S (add m' n);;

  let rec sub m n =
  match n with
  | Z -> m
  | S n' -> 
    match m with
    | Z -> Z
    | S m' -> sub m' n';;  

let rec mul m n =
  match m with
  | Z -> Z
  | S m' -> add (mul m' n) n;;

let rec pow m n =
  if n = Z then S Z
  else match n with
    | S n' when n' = Z -> m
    | S n' -> mul m (pow m n');;

exception Minus_input;;

let rec i2n m =
  match m with
  | x when x < 0 -> raise Minus_input
  | 0 -> Z
  | x -> S (i2n (x-1));;

let rec n2i m =
  match m with
  | Z -> 0
  | S m' -> 1 + n2i m';;

let zero = Z;;
let one = S Z;;
let two = S (S Z);;
let three = S (S (S Z));;

(*
# pow two three;;
- : nat = S (S (S (S (S (S (S (S Z)))))))
# pow two two;;
- : nat = S (S (S (S Z)))
# pow one two;;
- : nat = S Z
# pow two zero;;
- : nat = S Z
# i2n (-1);;
Exception: Minus_input.
# i2n 0;;
- : nat = Z
# i2n 5;;
- : nat = S (S (S (S (S Z))))
# n2i zero;;
- : int = 0
# n2i three;;
- : int = 3
*)