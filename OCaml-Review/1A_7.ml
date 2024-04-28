let rec fold_left f e list =
  match list with
  | [] -> e
  | x::rest -> fold_left f (f e x) rest;;

let reverse list =
  fold_left (fun x y -> y :: x) [] list;;

reverse [1; 2; 3; 4; 5];;
