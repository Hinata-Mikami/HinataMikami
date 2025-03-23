(* 練習問題 3.13 *)

let rec pow n x =
  if n = 0 then 1.
  else pow (n-1) x *. x;;

let cube = pow 3;;

(*
pow x n と定義されていた場合,

let cube = fun x -> pow x 3;;

でよい. 
*)