type 'a tree = Leaf 
             | Node of 'a * 'a tree * 'a tree

let rec fold_left f e list =
  match list with
  | [] -> e
  | x::rest -> fold_left f (f e x) rest;;

let reverse list =
  fold_left (fun x y -> y :: x) [] list;;

let level_order tree =
  let rec make_list queue list =
    match queue with
    | [] -> reverse list (*逆順で現れてしまうため出力時に反転*)
    | Leaf :: rest -> make_list rest list
    (*走査の順番を変更 Nodeが出ている間はleft，rightのqueue優先順位を後に*)
    | Node (x, left, right) :: rest -> make_list (rest @ [left; right]) (x :: list)
    in make_list [tree] [];; 

(*Test*)
let tree = Node(1, Node(2, Node(3, Leaf, Leaf), Node(4, Leaf, Leaf)), Node(5, Node(6, Leaf, Leaf), Node(7, Leaf, Leaf)));;
    
(*
1 - 2 - 3
      - 4
  - 5 - 6
      - 7
*)

level_order tree;;