type 'a tree = Lf | Br of 'a * 'a tree * 'a tree;;

let rec reflect t =
  match t with 
    Lf -> Lf
  | Br(x, left, right) -> Br(x, reflect right, reflect left);;

(*Test*)
let comptree = Br(1, Br(2, Br(4, Lf, Lf), Br(5, Lf, Lf)), Br(3, Br(6, Lf, Lf), Br(7, Lf, Lf)));;

reflect comptree;;
(*- : int tree =
Br (1, Br (3, Br (7, Lf, Lf), Br (6, Lf, Lf)),
 Br (2, Br (5, Lf, Lf), Br (4, Lf, Lf)))
*)

(*二分木tに対する方程式について*)
let rec preorder = function
Lf -> []
| Br (x, left, right) -> x :: (preorder left) @ (preorder right);;

let rec inorder = function
Lf -> []
| Br (x, left, right) -> (inorder left) @ (x :: inorder right);;

let rec postorder = function
Lf -> []
| Br (x, left, right) -> (postorder left) @ (postorder right) @ [x];;

(*preorder(reflect(t)) = ?*)
preorder (reflect comptree);;
(*- : int list = [1; 3; 7; 6; 2; 5; 4] ... postorder の reverse*)
(*preorder comptree = [1; 2; 4; 5; 3; 6; 7]*)

(*inorder(reflect(t)) = ?*)
inorder (reflect comptree);;
(*- : int list = [7; 3; 6; 1; 5; 2; 4]*)
(*inorder comptree = [4; 2; 5; 1; 6; 3; 7] ... reverse*)

(*postorder(reflect(t)) = ?*)
postorder (reflect comptree);;
(*- : int list = [7; 6; 3; 5; 4; 2; 1] ... preorder の reverse*)
(*postorder comptree = [4; 5; 2; 6; 7; 3; 1] *)

(*以上から，*)
(*preorder(reflect(t)) = reverse (postorder(t))*)
(*inorder(reflect(t)) = reverse (inorder(t))*)
(*postorder(reflect(t)) = reverse (preorder(t))*)