let cond (b, e1, e2) : int = if b then e1 else e2;;
(*val cond : bool * int * int -> int = <fun>*)
let rec fact n = cond ((n = 1), 1, n * fact (n-1));;
(*val fact : int -> int = <fun>*)
fact 4;;
(*????*)

(* Stack overflow during evaluation *)
(* 
  fact関数において，cond関数の第3引数が再帰呼び出しになっており，
  この再帰呼び出しの評価が終わって初めてcond関数の評価が行われるが，
  再帰呼び出しを終了する処理がないため無限に計算され続けてしまう
*）