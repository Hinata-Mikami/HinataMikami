(* 練習問題 3.4 *)

(* o1 *)
let x = 1 in let x = 3 in let x = x + 2 in x * x;;
(*
書き方が難しかったが異なる変数について変数名を x_1 のように変更して示すことにした
let x_1 = 1 in let x_2 = 3 in let x_3 = x_2 + 2 in x_3 * x_3;;
result:
- : int = 25
*)

(* o2 *)
let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y;;
(*
let x_1 = 2 and y_1 = 3 in (let y_2 = x_1 and x_2 = y_1 + 2 in x_2 * y_2) + y_1;;
result:
- : int = 13
*)

(* o3 *)
let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z;;
(*
let x_1 = 2 in let y_1 = 3 in let y_2 = x_1 in let z_1 = y_2 + 2 in x_1 * y_2 * z_1;;
result:
- : int = 16
*)

print_endline "Warning unused-var が出るが問題ない";;