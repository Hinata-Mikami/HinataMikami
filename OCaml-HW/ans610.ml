type arith =
  Const of int | Add of arith * arith | Mul of arith * arith;;

let rec eval a =
  match a with
   Const x -> x
  | Add (x, y) -> (eval x) + (eval y)
  | Mul (x, y) -> (eval x) * (eval y);;

(*Test*)
let exp = Mul (Add (Const 3, Const 4), Add (Const 2, Const 5));;

eval exp;;
(*- : int = 49*)