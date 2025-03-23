(* 練習問題 2.3 *)

(* o1 *)
(* 8*-2;; *)
(*
predict:
  ( *- )　の値が束縛されていない
result:
Error: Unbound value *-
*)

(* o2 *)
(* int_of_string "0xfg";; *)
(*
predict:
  "0xfg" から int への変換に失敗した
result:
Exception: Failure "int_of_string".
*)

(* o3 *)
(* int_of_float -0.7;; *)
(*
predict:
  - の型が float でない
result:
Error: This expression has type float -> int
       but an expression was expected of type int
reason:
  中値演算子としての (-)の型は int->int->int であり,
  この(-)の両側にint型が来ることが想定されたが
  関数int_of_floatは float->int 型だったことによって
  type error が吐き出されていた
*)
