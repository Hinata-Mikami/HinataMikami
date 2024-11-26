(*f x1 (f x2 (f x3 ...(f xn e)))*)
let rec fold_right f list e =
  match list with
  | [] -> e
  | x::rest -> f x (fold_right f rest e);;

(*f ... (f (f (f e x1) x2) x3) ... xn*)
let rec fold_left f e list =
  match list with
  | [] -> e
  | x::rest -> fold_left f (f e x) rest;;

(*
# fold_right (fun x y -> x + y) [3; 5; 7] 0;;
- : int = 15
# fold_left (fun x y -> y :: x) [] [1; 2; 3];;
- : int list = [3; 2; 1]
*)