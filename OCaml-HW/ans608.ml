type 'a tree = Lf | Br of 'a * 'a tree * 'a tree;;
type 'a rosetree = RLf | RBr of 'a * 'a rosetree list;;

(*p.132*)
let rec tree_of_rtree = function
    RLf -> Br (None, Lf, Lf)
  | RBr (a, rtrees) 
        -> Br (Some a, tree_of_rtreelist rtrees, Lf)

  and tree_of_rtreelist = function
    [] -> Lf
  | rtree :: rest 
      -> let Br (a, left, Lf) = tree_of_rtree rtree in 
      Br (a, left, tree_of_rtreelist rest);;

(*逆関数*)
let rec rtree_of_tree = function
    Br (None, Lf, Lf) -> RLf
  | Br (Some a, left, Lf) -> RBr (a, [rtree_of_tree left]) 
  | Br (Some a, left, right) -> RBr (a, [rtree_of_tree left; rtree_of_tree right]);;

(*Test*)
let rtree =
RBr ("a", [
  RBr ("b", [
    RBr ("c", [RLf]);
    RLf;
    RBr ("d", [RLf])]);
  RBr ("e", [RLf]);
  RBr ("f", [RLf])]);;

  rtree_of_tree (tree_of_rtree rtree);;

  (*val rtree : string rosetree =
  RBr ("a",
   [RBr ("b", [RBr ("c", [RLf]); RLf; RBr ("d", [RLf])]); RBr ("e", [RLf]);
    RBr ("f", [RLf])])
  *)