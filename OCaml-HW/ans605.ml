type 'a tree = Lf | Br of 'a * 'a tree * 'a tree;;

let rec comptree x n =
  match n with
    0 -> Lf
  | _ -> Br (x, comptree x (n-1), comptree x (n-1));;


let comptree' n =
  let rec make_tree a b =
    match b with 
      0 -> Lf
    | _ -> Br (a, make_tree (2*a) (b-1), make_tree (2*a+1) (b-1))
  in make_tree 1 n;;


(*Test*)
comptree 1 3;;
(*- : int tree = Br (1, Br (1, Br (1, Lf, Lf), Br (1, Lf, Lf)), Br (1, Br (1, Lf, Lf), Br (1, Lf, Lf)))*)

comptree' 3;;
(*- : int tree =
Br (1, Br (2, Br (4, Lf, Lf), Br (5, Lf, Lf)),
 Br (3, Br (6, Lf, Lf), Br (7, Lf, Lf)))*)