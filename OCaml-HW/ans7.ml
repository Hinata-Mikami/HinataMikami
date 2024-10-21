let find x list = 
  let rec search y l =
    match l with 
      [] -> raise Not_found
    | a :: l when a = y -> 1
    | _ :: l -> 1 + search y l
  in try Some (search x list) with Not_found -> None;;

(* Test *)
find 7 [0; 8; 7; 3];;
(*- : int option = Some 3*)

find 9 [0; 8; 7; 3];;
(*- : int option = None*)


(*7-2*)
exception Zero_found;;

let prod_list list =
  let rec calculate l =
    match l with
      [] -> 1
    | x :: rest when x = 0 -> raise Zero_found
    | x :: rest -> x * calculate rest
  in try calculate list with Zero_found -> 0;;

(* Test *)
prod_list [1;2;3;4;5;6;7;8;9;10];;
(*- : int = 3628800*)

prod_list [7;8;9;10;0;1;2;3;4;5;6];;
(*- : int = 0*)


(*7-3*)
let rec change coins amount =
  match (coins, amount) with
    (_, 0) -> []
  | ((c :: rest) as coins, total) ->
    if c > total then change rest total
    else
    (try c :: change coins (total - c) with Failure "change" -> change rest total)
  | _ -> raise (Failure "change")

(* Test *)
change [5; 2] 16;;
(*- : int list = [5; 5; 2; 2; 2]*)