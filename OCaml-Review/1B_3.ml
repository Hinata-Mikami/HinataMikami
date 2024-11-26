type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree

let rec preorder = function
  Leaf -> []
  | Node (x, left, right) -> x :: (preorder left) @ (preorder right);;

let rec postorder = function
  Leaf -> []
  | Node (x, left, right) -> (postorder left) @ (postorder right) @ [x];;

  let rec inorder = function
  Leaf -> []
  | Node (x, left, right) -> (inorder left) @ (x :: inorder right);;