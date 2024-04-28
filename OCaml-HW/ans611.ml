type arith =
  Const of int | Add of arith * arith | Mul of arith * arith;;

let rec string_of_arith a =
  match a with
    Const x -> string_of_int x
  | Add (x, y) -> "("^(string_of_arith x)^"+"^(string_of_arith y)^")"
  | Mul (x, y) -> "("^(string_of_arith x)^"*"^(string_of_arith y)^")";;


let expand a =
  match a with
    Mul (Add (x, y), Add (v, w))
    -> Add (Add (Mul (x, v), Mul (x, w)), Add (Mul (y, v), Mul (y, w)))

(*Test*)
let exp = Mul (Add (Const 3, Const 4), Add (Const 2, Const 5));;

string_of_arith exp;;
string_of_arith (expand exp);;
(*- : string = "(((3*2)+(3*5))+((4*2)+(4*5)))"*)