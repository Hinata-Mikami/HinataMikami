let rec append l1 l2 =
  match l1 with
    [] -> l2
  | v :: l1' -> v :: (append l1' l2);;

let rec last list =
  match list with
  | a::[] -> a
  | a::rest -> last rest;;

let rec map f xs =
  match xs with
  | [] -> []
  | x :: rest -> f x :: map f rest;;
