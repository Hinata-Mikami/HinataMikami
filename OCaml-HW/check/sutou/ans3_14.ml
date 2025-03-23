(* 練習問題 3.14 *)

let integral f a b = (* 台形公式による近似積分 *)
  let n = 10000 (* 分割数である *)
  in
  let d = (b -. a) /. float_of_int n
  in
  let rec sum i res =
    if i = n then res
    else sum (i+1) (res +. 2. *. f (a +. d *. float_of_int i))
  in 
  sum 1 (f a +. f b) *. d /. 2.
  ;;

integral sin 0. 3.14159265;;
(*
- : float = 1.99999998355066388
S(0~pi) sin x dx は 
(-cos pi) - (-cos 0) = -(-1) - -(1) =2 である

*)