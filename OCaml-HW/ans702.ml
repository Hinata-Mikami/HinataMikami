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