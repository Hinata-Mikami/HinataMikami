(* 1 *)
let rec mem a s =
  match s with
    [] -> false
  | x::rest when x = a -> true
  | x::rest -> mem a rest;;

(*
# mem 1 [0; 1; 3; 7];;
- : bool = true
# mem 0 [7; 5; 8];;
- : bool = false
# mem 2 [];;  
- : bool = false
*)


(* 2 *)
let rec intersect s1 s2 =
  match s1 with
    [] -> []
  | x::rest when mem x s2 -> x::(intersect rest s2)
  | x::rest -> intersect rest s2;;

(*
# intersect [1;2;3;4;5] [6;7;8;9;10];;
- : int list = []
# intersect [0;1;2] [1;2;3];;
- : int list = [1; 2]
# intersect [0;1;2] [8;9;0;1];;
- : int list = [0; 1]
# intersect [11;22;33] [11;22;33];;
- : int list = [11; 22; 33]
*)


(* 3 *)
let rec union s1 s2 =
  match s1 with
  [] -> s2
  | x::rest when mem x s2 -> union rest s2
  | x::rest -> x::(union rest s2);; 

(*
# union [0;1;2] [3;4;5];;
- : int list = [0; 1; 2; 3; 4; 5]
# union [0;1;2] [1;2;3];;
- : int list = [0; 1; 2; 3]
# union [1;2;3] [0;1;2];;
- : int list = [3; 0; 1; 2]
# union [0;1;2] [0;1;2];;
- : int list = [0; 1; 2]
*)


(* 4 *)
(*s1とs2の差集合 = s1には属するがs2には属さない*)

let rec diff s1 s2 =
    match s1 with 
      [] -> []
    | x::rest when (mem x s2) = false -> x::(diff rest s2)
    | x::rest -> diff rest s2;;

(*
# diff [0;1;2] [0;1;2];;
- : int list = []
# diff [0;1;2] [1;2;3];;
- : int list = [0]
# diff [0] [1;2;3];;
- : int list = [0]
# diff [0;1;2] [3];;  
- : int list = [0; 1; 2]
*)
