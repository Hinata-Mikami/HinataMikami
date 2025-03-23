(* 練習問題 3.9 *)

(*
if式を関数で表現した
let cond (b, e1, e2) : int = if b then e1 else e2;;
let rec fact n = cond ((n = 1), 1, n * fact (n-1));;
がうまくいかない理由

関数に渡しているのは式ではなくその式が持つ値であるから
と説明すれば十分だとは思うが, 問題文に従ってfact 4の評価ステップを考える.

何を1ステップとするかは(自分が読んだ限り)明言されていないので厳密さに欠けるかもしれない.

fact 4
-> cond ((4 = 1), 1, 4 * fact (4-1))
-> cond (false, 1, 4 * fact (3))
(* 値呼びなので先に引数が計算される*)
-> cond (false, 1, 4 * cond ((3 = 1), 1, 3 * fact (3-1)))
-> cond (false, 1, 4 * cond (false, 1, 3 * fact (2)))
-> cond (false, 1, 4 * cond (false, 1, 3 * cond ((2 = 1), 1, 2 * fact (2-1))))
-> cond (false, 1, 4 * cond (false, 1, 3 * cond (false, 1, 2 * fact (1))))
-> cond (false, 1, 4 * cond (false, 1, 3 * cond (false, 1, 2 * cond ((1 = 1), 1, n * fact (1-1)))))
-> cond (false, 1, 4 * cond (false, 1, 3 * cond (false, 1, 2 * cond (true, 1, n * fact (0)))))
-> ...(前略) (true, 1, n * cond ((0 = 1), 1, n * fact (0-1)))

となるわけだが, 条件式bがtrueであっても先にfact(n-1)を計算されてしまうため, 永遠に引数の値が求められずに実行できない,

これを実現させるためには, e1,e2に与えるものを式ではなく関数に変えればおそらく可能である. 
但し普通にif式で書いた方が良いと思う.
次に例を示す.実行して意図通りに動作することは確認したが改めて普通にif式で書いた方が良いと思った. 
 ** 後の章で言及されているが, unitを引数にとる関数にすることで評価されるタイミングを指定できるようになるので特殊な状況においては意味があるかもしれない

*)

(* 関数であることを明示する必要はない*)
let cond ((b: bool), (f1: unit -> int), (f2: unit -> int)): int =
  if b then f1 () else f2 ();;

let rec fact n = cond ((n=1), (fun _ -> 1), (fun _ -> n * (fact (n-1))));;

