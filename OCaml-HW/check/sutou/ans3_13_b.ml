(* 練習問題 3.13 *)

(*
pow x n と定義されていた場合,
*)
let rec pow x n  =
  if n = 0 then 1.
  else pow x (n-1) *. x;;

let cube = fun x -> pow x 3;;
(*
でよい. 
*)