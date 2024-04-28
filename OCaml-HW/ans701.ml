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