type 'a tree = Lf | Br of 'a * 'a tree * 'a tree;;

let rec preord t l =
  match t with
    Lf -> l
  | Br(x, left, right) -> x :: (preord left (preord right l));;

(*通りがけ順*)
let rec inord t l =
  match t with 
    Lf -> l
  | Br(x, left, right) -> inord left (x::(inord right l));;


(*帰りがけ順*)
let rec postord t l =
  match t with
    Lf -> l
  | Br(x, left, right) -> (postord left (postord right (x::l)));;


(*Test*)
let comptree' n =
  let rec make_tree a b =
    match b with 
      0 -> Lf
    | _ -> Br (a, make_tree (2*a) (b-1), make_tree (2*a+1) (b-1))
  in make_tree 1 n;;


inord (comptree' 3) [];;
(*- : int list = [4; 2; 5; 1; 6; 3; 7]*)

postord (comptree' 3) [];;
(*- : int list = [4; 5; 2; 6; 7; 3; 1]*)