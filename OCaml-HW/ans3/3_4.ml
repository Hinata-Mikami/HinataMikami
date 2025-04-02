(*3-4*)
(* 1 *)
let x = 1 in let x = 3 in let x = x + 2 in x * x;;
(*  予想
    x + 2の参照は x = 3
    x * xの参照は x = 3 + 2 = 5
    結果：5 * 5 = 25
*)

(* 2 *)
let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y;;
(*  予想(誤り)
    y = xの参照は x = 2
    y = x + 2 の参照は y = 2
    結果は x * y + y = 2 * 2 + 2 = 6
*)

(*　結果　13
    y = xの参照は x = 2
    y = x + 2 の参照は y = 3
    x * y = 2 * 5 = 10
    + y の参照は y = 3
    結果　10 + 3 = 13
*)

(* 3 *)
let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z;;
(*  予想
    y = xの参照は x = 2
    z = y + 2の参照はy = 2
    結果は x * y * z = 2 * 2 * 4 = 16
*)