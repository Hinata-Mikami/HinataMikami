(*2-1*)
(*エラーになる式はなし*)

(*2-2*)
(* 
1.  float 5.5
2.  int 0
3.  char 'U'
4.  int 255
5.  float 25
*)

(*2-3*)
(*
1.  *- は未定義の中置演算子と解釈されると予想される

2.  文字列はASCIIコードに変換できない
    ->そもそも”0xfg”は16進数表記でない

3.  int_of_float - 0.7 と解析された。「-」演算子は2個の引数を受け取ることができ，その場合はint->int->int型であり，int_of_floatの引数に当たる部分がintになってしまった。
*)

(*2-4*)
(*1*)
float_of_int (int_of_float 5.0);;

(*2*)
(sin (3.14 /. 2.0)) ** 2.0 +. (cos (3.14 /. 2.0)) ** 2.0;;

(*3*)
int_of_float(sqrt (float_of_int (3 * 3 + 4 * 4)));;

(*2-5*)
(*エラーにならないもの*)
let a_2' : int = 5;;

let ____ : int = 5;;

let _'_'_ : int = 5;;

let _ : int = 5;;

(*エラーになるもの*)
(*let Cat : int = 5;;*)

(*let 7eleven : int = 5;;*)

(*let '_ab2_ : int = 5;;*)