(* 練習問題 3.2 *)

(*
b1 && b2 ;;
の書き換え
*)
let and2 b1 b2 =
  if b1
  then b2
  else false
  ;;

(*
b1 || b2 ;;
の書き換え
*)
let or2 b1 b2 = 
  if b1
  then true
  else b2
  ;;