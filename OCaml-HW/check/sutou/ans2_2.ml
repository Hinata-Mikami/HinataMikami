(* 練習問題 2.2 *)
(* o1 *)
float_of_int 3 +. 2.5;;
(*
- : float = 5.5
*)

(* o2 *)
int_of_float 0.7;;
(*
- : int = 0
*)

(* o3 *)
char_of_int ((int_of_char 'A') + 20);;
(*
- : char = 'U'
*)

(* o4 *)
int_of_string "0xFF";;
(*
- : int = 255
*)

(* o5 *)
5.0 ** 2.0;;
(*
- : float = 25.
*)
(* 中値演算子としての ( ** ) はfloat->float->float型の関数で, 冪乗を表している *)
