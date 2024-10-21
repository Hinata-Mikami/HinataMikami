(*6-1*)
type figure =
    Point
  | Circle of int
  | Rectangle of int * int
  | Square of int;;

let similar x y =
  match (x, y) with
   (Point, Point) | (Circle _, Circle _) | (Square _, Square _) -> true
  | (Rectangle (l1, l2), Square _) when l1 = l2 -> true
  | (Square _, Rectangle (l1, l2)) when l1 = l2 -> true
  | (Rectangle (l1, l2), Rectangle (l3, l4)) -> (l3 * l2 - l4 * l1) = 0
  | _ -> false;;


similar (Rectangle (1, 1)) (Square 1);;
(*
   - : bool = true
*)


(*6-2*)
type figure =
    Point
  | Circle of int
  | Rectangle of int * int
  | Square of int;;

type 'a with_location = {loc_x: float; loc_y: float; body: 'a};;

(*点と円*)
let point_and_circle p c =
  match (p, c) with 
    ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Circle r}) -> if (x2 -. x1)*.(x2 -. x1) +. (y2 -. y1)*.(y2 -. y1) <= (float_of_int r) *. (float_of_int r) then true else false
  | (_, _) -> false

let point_and_rectangle p r =
  match (p, r) with 
  (*点と長方形*)
    ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Rectangle (x, y)}) -> if x1 <= x2 +. (float_of_int x) /. 2. && x2 -. (float_of_int x) /. 2. <= x1 && y1 <= y2 +. (float_of_int y)/.2. && y2 -. (float_of_int y)/. 2. <= y1 then true else false
  (*点と正方形*)
  | ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Square x}) -> if x1 <= x2 +. (float_of_int x) /. 2. && x2 -. (float_of_int x) /. 2. <= x1 && y1 <= y2 +. (float_of_int x)/.2. && y2 -. (float_of_int x)/. 2. <= y1 then true else false
  | (_, _) -> false


(*円と円*)
(*中心間の距離が半径の和以下であれば接する*)
let circle_and_circle c1 c2 =
  match (c1, c2) with
    ({loc_x = x1; loc_y = y1; body = Circle r1}, {loc_x = x2; loc_y = y2; body = Circle r2}) -> if (x1 -. x2)*.(x1 -. x2) +. (y1 -. y2)*.(y1 -. y2) <= float_of_int ((r1 + r2)*(r1 + r2)) then true else false
  |(_, _) -> false

(*円と長方形/円と正方形*)
let circle_and_rectangle c re =
  match (c, re) with
  (*円と長方形*)
    ({loc_x = x1; loc_y = y1; body = Circle r}, {loc_x = x2; loc_y = y2; body = Rectangle (x, y)}) 
    (*長方形の頂点を定義*)
    ->let left_x = x2 -. float_of_int (x/2) in
      let right_x = x2 +. float_of_int (x/2) in
      let upper_y = y2 +. float_of_int (y/2) in  
      let bottom_y = y2 -. float_of_int (y/2) in
    (*left<=x1<=right, bottom<=y1<=upper　でない部分*)
    (*円の中心と頂点との距離が半径以下であればよい*)
      if ((x1 >= left_x) && (x1 <= right_x)) || ((y1 <= upper_y) && (y1 >= bottom_y)) = false 
        then 
          if 
            ((x1 -. left_x)*.(x1 -. left_x) +. (y1 -. upper_y)*.(y1 -. upper_y) <= float_of_int (r*r)) || 
            ((x1 -. left_x)*.(x1 -. left_x) +. (y1 -. bottom_y)*.(y1 -. bottom_y) <= float_of_int (r*r)) ||
            ((x1 -. right_x)*.(x1 -. right_x) +. (y1 -. upper_y)*.(y1 -. upper_y) <= float_of_int (r*r)) ||
            ((x1 -. right_x)*.(x1 -. right_x) +. (y1 -. bottom_y)*.(y1 -. bottom_y) <= float_of_int (r*r)) then true else false
    (*left<=x1<=right の部分 y1-upper または bottom-y1が0以上r以下ならよい*)
      else if (x1 >= left_x) && (x1 <= right_x) 
        then 
          if ((y1 -. float_of_int r) <= upper_y && (y1 -. upper_y) >= 0.) || (y1 +. float_of_int r >= bottom_y && bottom_y -. y1 >= 0.) 
            then true else false
    (*bottom<=y1<=upper の部分 x1-right または left-x1が0以上r以下ならよい*)
      else if (x1 -. float_of_int r <= right_x && x1 -. right_x >= 0.) || (x1 +. float_of_int r >= left_x && left_x -. x1 >= 0.)
        then true 
      else false

  (*円と正方形*)
  |({loc_x = x1; loc_y = y1; body = Circle r}, {loc_x = x2; loc_y = y2; body = Square x})
  ->let left_x = x2 -. float_of_int (x/2) in
      let right_x = x2 +. float_of_int (x/2) in
      let upper_y = y2 +. float_of_int (x/2) in  
      let bottom_y = y2 -. float_of_int (x/2) in
    (*left<=x1<=right, bottom<=y1<=upper　でない部分*)
    (*円の中心と頂点との距離が半径以下であればよい*)
      if ((x1 >= left_x) && (x1 <= right_x)) || ((y1 <= upper_y) && (y1 >= bottom_y)) = false 
        then 
          if 
            ((x1 -. left_x)*.(x1 -. left_x) +. (y1 -. upper_y)*.(y1 -. upper_y) <= float_of_int (r*r)) || 
            ((x1 -. left_x)*.(x1 -. left_x) +. (y1 -. bottom_y)*.(y1 -. bottom_y) <= float_of_int (r*r)) ||
            ((x1 -. right_x)*.(x1 -. right_x) +. (y1 -. upper_y)*.(y1 -. upper_y) <= float_of_int (r*r)) ||
            ((x1 -. right_x)*.(x1 -. right_x) +. (y1 -. bottom_y)*.(y1 -. bottom_y) <= float_of_int (r*r)) then true else false
    (*left<=x1<=right の部分 y1-upper または bottom-y1が0以上r以下ならよい*)
      else if (x1 >= left_x) && (x1 <= right_x) 
        then 
          if ((y1 -. float_of_int r) <= upper_y && (y1 -. upper_y) >= 0.) || (y1 +. float_of_int r >= bottom_y && bottom_y -. y1 >= 0.) 
            then true else false
    (*bottom<=y1<=upper の部分 x1-right または left-x1が0以上r以下ならよい*)
      else if (x1 -. float_of_int r <= right_x && x1 -. right_x >= 0.) || (x1 +. float_of_int r >= left_x && left_x -. x1 >= 0.)
        then true 
      else false

  | (_, _) -> false


(*長方形と長方形/正方形と正方形/長方形と正方形*)
let rectangle_and_rectangle r1 r2 =
  match (r1, r2) with
  (*長方形＊長方形*)
    ({loc_x = x1; loc_y = y1; body = Rectangle (a, b)}, {loc_x = x2; loc_y = y2; body = Rectangle (c, d)}) 
    (*長方形の頂点を定義*)
    ->let left_x1 = x1 -. float_of_int (a/2) in
      let right_x1 = x1 +. float_of_int (a/2) in
      let upper_y1 = y1 +. float_of_int (b/2) in  
      let bottom_y1 = y1 -. float_of_int (b/2) in
      let left_x2 = x2 -. float_of_int (c/2) in
      let right_x2 = x2 +. float_of_int (c/2) in
      let upper_y2 = y2 +. float_of_int (d/2) in  
      let bottom_y2 = y2 -. float_of_int (d/2) in
    (*重なりを持つ条件*)
      if ((left_x1 <= left_x2 && left_x2 <= right_x2)||(left_x1<=right_x2 && right_x2 <= right_x1)) && ((bottom_y1<=upper_y2 && upper_y2 <= upper_y1)||(bottom_y1<=bottom_y2 && bottom_y2<=upper_y1)) then true else false

  (*長方形*正方形*)
  | ({loc_x = x1; loc_y = y1; body = Rectangle (a, b)}, {loc_x = x2; loc_y = y2; body = Square c}) 
    (*各図形のの頂点を定義*)
    ->let left_x1 = x1 -. float_of_int (a/2) in
      let right_x1 = x1 +. float_of_int (a/2) in
      let upper_y1 = y1 +. float_of_int (b/2) in  
      let bottom_y1 = y1 -. float_of_int (b/2) in
      let left_x2 = x2 -. float_of_int (c/2) in
      let right_x2 = x2 +. float_of_int (c/2) in
      let upper_y2 = y2 +. float_of_int (c/2) in  
      let bottom_y2 = y2 -. float_of_int (c/2) in
      if ((left_x1 <= left_x2 && left_x2 <= right_x2)||(left_x1<=right_x2 && right_x2 <= right_x1)) && ((bottom_y1<=upper_y2 && upper_y2 <= upper_y1)||(bottom_y1<=bottom_y2 && bottom_y2<=upper_y1)) then true else false

  (*正方形*正方形*)
  | ({loc_x = x1; loc_y = y1; body = Square a}, {loc_x = x2; loc_y = y2; body = Square c}) 
    (*各図形のの頂点を定義*)
    ->let left_x1 = x1 -. float_of_int (a/2) in
      let right_x1 = x1 +. float_of_int (a/2) in
      let upper_y1 = y1 +. float_of_int (a/2) in  
      let bottom_y1 = y1 -. float_of_int (a/2) in
      let left_x2 = x2 -. float_of_int (c/2) in
      let right_x2 = x2 +. float_of_int (c/2) in
      let upper_y2 = y2 +. float_of_int (c/2) in  
      let bottom_y2 = y2 -. float_of_int (c/2) in
      if ((left_x1 <= left_x2 && left_x2 <= right_x2)||(left_x1<=right_x2 && right_x2 <= right_x1)) && ((bottom_y1<=upper_y2 && upper_y2 <= upper_y1)||(bottom_y1<=bottom_y2 && bottom_y2<=upper_y1)) then true else false
  
  | (_, _) -> false


let overlap x y =
  match (x, y) with
  (*点と点→同じ座標かどうか*)
    ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Point}) when x1 = x2 && y1 = y2 -> true
  (*点と円*)
  | ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Circle _}) -> point_and_circle x y
  | ({loc_x = x1; loc_y = y1; body = Circle _}, {loc_x = x2; loc_y = y2; body = Point}) -> point_and_circle y x
  (*点と長方形*)
  | ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Rectangle (_, _)}) -> point_and_rectangle x y
  | ({loc_x = x1; loc_y = y1; body = Rectangle (_, _)}, {loc_x = x2; loc_y = y2; body = Point}) -> point_and_rectangle y x
  (*点と正方形*)
  | ({loc_x = x1; loc_y = y1; body = Point}, {loc_x = x2; loc_y = y2; body = Square _}) -> point_and_rectangle x y
  | ({loc_x = x1; loc_y = y1; body = Square _}, {loc_x = x2; loc_y = y2; body = Point}) -> point_and_rectangle y x
  (*円と円*)
  | ({loc_x = x1; loc_y = y1; body = Circle _}, {loc_x = x2; loc_y = y2; body = Circle _}) -> circle_and_circle x y
  (*円と長方形*)
  | ({loc_x = x1; loc_y = y1; body = Circle _}, {loc_x = x2; loc_y = y2; body = Rectangle (_, _)}) -> circle_and_rectangle x y
  | ({loc_x = x1; loc_y = y1; body = Rectangle (_, _)}, {loc_x = x2; loc_y = y2; body = Circle _}) -> circle_and_rectangle y x
  (*円と正方形*)
  | ({loc_x = x1; loc_y = y1; body = Circle _}, {loc_x = x2; loc_y = y2; body = Square _}) -> circle_and_rectangle x y
  | ({loc_x = x1; loc_y = y1; body = Square _}, {loc_x = x2; loc_y = y2; body = Circle _}) -> circle_and_rectangle y x
  (*長方形と長方形*)
  | ({loc_x = x1; loc_y = y1; body = Rectangle (_, _)}, {loc_x = x2; loc_y = y2; body = Rectangle (_, _)}) -> rectangle_and_rectangle x y
  (*正方形と長方形*)
  | ({loc_x = x1; loc_y = y1; body = Rectangle (_, _)}, {loc_x = x2; loc_y = y2; body = Square _}) -> rectangle_and_rectangle x y
  | ({loc_x = x1; loc_y = y1; body = Square _}, {loc_x = x2; loc_y = y2; body = Rectangle (_, _)}) -> rectangle_and_rectangle y x
  (*正方形と正方形*)
  | ({loc_x = x1; loc_y = y1; body = Square _}, {loc_x = x2; loc_y = y2; body = Square _}) -> rectangle_and_rectangle x y

  | (_, _) -> false


(*Test*)
overlap {loc_x=0.; loc_y=0.; body=Point} {loc_x=0.; loc_y=0.; body=Point};;
(*- : bool = true*)

overlap {loc_x=0.; loc_y=0.; body=Point} {loc_x=0.; loc_y=1.; body=Point};;
(*- : bool = false*)

overlap {loc_x=0.; loc_y=0.; body=Circle 1} {loc_x=0.; loc_y=1.; body=Point};;
(*- : bool = true*)

overlap {loc_x=1.; loc_y=1.; body=Point} {loc_x=0.; loc_y=0.; body=Circle 1};;
(*- : bool = false*)

overlap {loc_x=1.; loc_y=1.; body=Point} {loc_x=0.; loc_y=0.; body=Rectangle (2, 2)};;
(*- : bool = true*)

overlap {loc_x=1.; loc_y=1.; body=Rectangle (2, 2)} {loc_x = -1.0; loc_y = -1.0; body=Point};;
(*- : bool = false*)

overlap {loc_x=1.; loc_y=1.; body=Point} {loc_x=0.; loc_y=0.; body=Square 2};;
(*- : bool = true*)

overlap {loc_x=0.; loc_y=0.; body=Circle 1} {loc_x=2.; loc_y=0.; body=Circle 1};;
(*- : bool = true*)

overlap {loc_x=0.; loc_y=0.; body=Circle 1} {loc_x=1.; loc_y=1.; body= Rectangle (2, 2)};;
(*- : bool = true*)

overlap {loc_x=0.; loc_y=0.; body=Square 2} {loc_x=3.; loc_y=0.; body= Circle 1};;
(*- : bool = false*)

overlap {loc_x=0.; loc_y=0.; body=Rectangle (2, 2)} {loc_x = 2.; loc_y = 2.; body=Rectangle (2, 2)};;
(*- : bool = true*)

overlap {loc_x=0.; loc_y=0.; body=Rectangle (2, 2)} {loc_x = 2.; loc_y = 2.; body=Square 1};;
(*- : bool = false*)

overlap {loc_x=0.; loc_y=0.; body=Square 1} {loc_x = 2.; loc_y = 2.; body=Square 1};;
(*- : bool = false*)


(*6-3*)
type nat = Zero | OneMoreThan of nat;;

let rec add m n =
  match m with 
    Zero -> n 
  | OneMoreThan m' -> OneMoreThan (add m' n);;

let rec mul m n =
  match m with
    Zero -> Zero
  | OneMoreThan m' -> add (mul m' n) n;;

let rec monus m n =
  match n with
    Zero -> m
    | OneMoreThan n' -> match m with
                          Zero -> Zero
                        | OneMoreThan m' -> monus m' n';;  

(*Test*)
let two = OneMoreThan (OneMoreThan Zero)
and three = OneMoreThan (OneMoreThan (OneMoreThan Zero));;

mul three two;;
(*- : nat = OneMoreThan (OneMoreThan (OneMoreThan (OneMoreThan (OneMoreThan (OneMoreThan Zero)))))*)

monus three two;;
(*- : nat = OneMoreThan Zero*)

monus two three;;
(*- : nat = Zero*)

monus three Zero;;
(*- : nat = OneMoreThan (OneMoreThan (OneMoreThan Zero))*)


(*6-4*)
type nat = Zero | None | OneMoreThan of nat;;

let rec minus m n =
  match n with
    Zero -> m
    | OneMoreThan n' -> match m with
                          Zero -> None
                        | OneMoreThan m' -> minus m' n';;  


let two = OneMoreThan (OneMoreThan Zero)
and three = OneMoreThan (OneMoreThan (OneMoreThan Zero));;

minus three two;;
(*- : nat = OneMoreThan Zero*)

minus two three;;
(*- : nat = None*)


(*6-5*)
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


(*6-6*)
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


(*6-7*)
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


(*6-8*)
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


(*6-9*)
type ('a, 'b) xml = XLf of 'b option | XBr of 'a * ('a, 'b) xml list;;
type token = PCDATA of string | Open of string | Close of string;;


let rec xml_of_tokens list =
  match list with 
    [] -> "" 
  | (Open s)::rest -> "<"^s^">"^(xml_of_tokens rest)
  | (Close s)::rest -> "</"^s^">"^(xml_of_tokens rest)
  | (PCDATA s)::rest ->s^(xml_of_tokens rest);;

let l = [Open "a"; Open "b"; Close "b";
Open "c"; PCDATA "Hello"; Close "c"; Close "a"];;

xml_of_tokens l;;


(*6-10*)
type arith =
  Const of int | Add of arith * arith | Mul of arith * arith;;

let rec eval a =
  match a with
   Const x -> x
  | Add (x, y) -> (eval x) + (eval y)
  | Mul (x, y) -> (eval x) * (eval y);;

(*Test*)
let exp = Mul (Add (Const 3, Const 4), Add (Const 2, Const 5));;

eval exp;;
(*- : int = 49*)


(*6-11*)
type arith =
  Const of int | Add of arith * arith | Mul of arith * arith;;

let rec string_of_arith a =
  match a with
    Const x -> string_of_int x
  | Add (x, y) -> "("^(string_of_arith x)^"+"^(string_of_arith y)^")"
  | Mul (x, y) -> "("^(string_of_arith x)^"*"^(string_of_arith y)^")";;


let expand a =
  match a with
    Mul (Add (x, y), Add (v, w))
    -> Add (Add (Mul (x, v), Mul (x, w)), Add (Mul (y, v), Mul (y, w)))

(*Test*)
let exp = Mul (Add (Const 3, Const 4), Add (Const 2, Const 5));;

string_of_arith exp;;
string_of_arith (expand exp);;
(*- : string = "(((3*2)+(3*5))+((4*2)+(4*5)))"*)


(*6-12*)
type 'a tree = Lf | Br of 'a * 'a tree * 'a tree;;

(*1-2-3-4*)
let t1 = Br(1, Lf, Br(2, Lf, Br(3, Lf, Br(4, Lf, Lf))));;

(*1-2-4-3*)
let t2 = Br(1, Lf, Br(2, Lf, Br(4, Br(3, Lf, Lf), Lf)));;

(*1-3-2-4*)
let t3 = Br(1, Lf, Br(3, Br(2, Lf, Lf), Br(4, Lf, Lf)));;

(*1-4-2-3*)
let t4 = Br(1, Lf, Br(4, Br(2, Lf, Br(3, Lf, Lf)), Lf));;

(*1-4-3-2*)
let t5 = Br(1, Lf, Br(4, Br(3, Br(2, Lf, Lf), Lf), Lf));;

(*2-1-3-4*)
let t6 = Br(2, Br(1, Lf, Lf), Br(3, Lf, Br(4, Lf, Lf)));;

(*2-1-4-3*)
let t7 = Br(2, Br(1, Lf, Lf), Br(4, Br(3, Lf, Lf), Lf));;

(*3-1-2-4*)
let t8 = Br(3, Br(1, Lf, Br(2, Lf, Lf)), Br(4, Lf, Lf));;

(*3-2-1-4*)
let t9 = Br(3, Br(2, Br(1, Lf, Lf), Lf), Br(4, Lf, Lf));;

(*4-1-2-3*)
let t10 = Br(4, Br(1, Lf, Br(2, Lf, Br(3, Lf, Lf))), Lf);;

(*4-1-3-2*)
let t11 = Br(4, Br(1, Lf, Br(3, Br(2, Lf, Lf), Lf)), Lf);;

(*4-2-1-3*)
let t12 = Br(4, Br(2, Br(1, Lf, Lf), Br(3, Lf, Lf)), Lf);;

(*4-3-1-2*)
let t13 = Br(4, Br(3, Br(1, Lf, Br(2, Lf, Lf)), Lf), Lf);;

(*4-3-2-1*)
let t14 = Br(4, Br(3, Br(2, Br(1, Lf, Lf), Lf), Lf), Lf);;


(*6-13*)
type intseq = Cons of int * (int -> intseq);;

let fib = 
  let rec fib1 x0 x1 = Cons(x0, fun _ -> fib1 x1 (x0+x1))
in fib1 1 1;;

let rec nthseq n (Cons(x, f)) =
if n = 1 then x
else nthseq (n-1) (f x);;

(*Test*)
nthseq 10 fib;;
(*- : int = 55*)


(*6-14*)
(*無限列ヴァリアント*)
type intseq = Cons of int * (int -> intseq);;

(*intseqからn番目の要素を取り出す関数*)
let rec nthseq n (Cons(x, f)) =
  if n = 1 then x
  else nthseq (n-1) (f x);;

(*⌊√k⌋を計算する関数*)
let floor_of_sqrt k = int_of_float (floor (sqrt (float_of_int k)));;

(*以下は数字xが素数かどうかを判定する関数*)
(* 0 *)
let is_prime x =
  let rec is_divisible_from_2_to n =
    (n > 1) && 
    ((x mod n = 0) || is_divisible_from_2_to (n-1))
in not (is_divisible_from_2_to (x-1));;

(* 1 *)
let is_prime_1 x =
  let rec is_divisible_1 m n =
    (m < n) &&
    ((x mod m = 0) || is_divisible_1 (m+1) n)
  in not (is_divisible_1 2 x);;

(* 2 *)
let is_prime_2 x =
  let rec is_divisible_2 n =
    (n > 1) &&
    ((x mod n = 0) || is_divisible_2 (n-1))
in not (is_divisible_2 (floor_of_sqrt x));;

(* 3 *)
let rec is_prime_3 primes x =
  match primes with
   [] -> true
  | a::rest when (a > 1) && (x mod a = 0) -> false
  | a::rest -> is_prime_3 rest x

let rec prime_seq_3 primes x =
  if is_prime_3 primes (x+1) 
    then Cons (x+1, prime_seq_3 (x+1::primes))
  else prime_seq_3 primes (x+1);; 


(* 4 *)
let rec is_prime_4 primes x =
  let rec filter l =
    match l with
      [] -> []
    | a::rest when a <= floor_of_sqrt x
      -> a::(filter rest)
    | a::rest -> filter rest
  in let list = filter primes
in  
  match list with
   [] -> true
  | b::rest when (x mod b = 0) -> false
  | b::rest -> is_prime_4 rest x

let rec prime_seq_4 primes x =
  if is_prime_4 primes (x+1) 
    then Cons (x+1, prime_seq_4 (x+1::primes))
  else prime_seq_4 primes (x+1);;


(*0・1・2用　素数の無限列を作る関数*)
let rec prime_seq x =
  if is_prime (x+1) then Cons(x+1, prime_seq) 
  else prime_seq (x+1);;

let rec prime_seq_1 x =
  if is_prime_1 (x+1) then Cons(x+1, prime_seq_1) 
  else prime_seq_1 (x+1);;

let rec prime_seq_2 x =
  if is_prime_2 (x+1) then Cons(x+1, prime_seq_2) 
  else prime_seq_2 (x+1);;

(* Test *)
nthseq 3000 (prime_seq 1);;
(*- : int = 27449 約5秒*)
nthseq 3000 (prime_seq_1 1);;
(*- : int = 27449 約1秒*)
nthseq 3000 (prime_seq_2 1);;
(*- : int = 27449 約0.1秒*)
nthseq 3000 (prime_seq_3 [] 1);;
(*- : int = 27449 約0.8秒*)
nthseq 3000 (prime_seq_4 [] 1);;
(*- : int = 27449 約1.2秒*)


(*6-15*)
type ('a, 'b) sum = Left of 'a | Right of 'b;;

(*① f1: 'a * ('b, 'c) sum -> ('a * 'b, 'a * 'c) sum*)
let f1 (a, sum) =
  match sum with
    Left b -> Left (a, b)
  | Right c -> Right (a, c);;


(*② f2: ('a * 'b, 'a * 'c) sum -> 'a * ('b, 'c) sum*)
let f2 sum =
  match sum with
    Left (a, b) -> (a, Left b)
  | Right (a, c) -> (a, Right c);;

(*③ f3: ('a, 'b) sum * ('c, 'd) sum -> (('a * 'c, 'b * 'c) sum, ('a * 'd, 'b * 'd) sum) sum*)
let f3 (sum1, sum2) =
  match (sum1, sum2) with
    (Left a, Left c) -> Left (Left (a, c))
  | (Left a, Right d) -> Right (Left (a, d))
  | (Right b, Left c) -> Left (Right (b, c))
  | (Right b, Right d) -> Right (Right (b, d));;

(*④ f4: (('a * 'c, 'b * 'c) sum, ('a * 'd, 'b * 'd) sum) sum -> ('a, 'b) sum * ('c, 'd) sum*)
let f4 sum =
  match sum with
    Left (Left (a, b)) -> (Left a, Left b)
  | Right (Left (a, b)) -> (Left a, Right b)
  | Right (Right (a, b)) -> (Right a, Right b)
  | Left (Right (a, b)) -> (Right a, Left b);;

(*⑤ f5: ('a -> 'b) * ('c -> 'b) -> ('a, 'c) sum -> 'b*)
let f5 (f1, f2) sum =
  match sum with
    Left a -> f1 a
  | Right c -> f2 c;;

(*⑥ f6: (('a, 'b) sum -> 'c) -> ('a -> 'c) * ('b -> 'c)*)
let f6 f = (fun a -> f (Left a)), (fun b -> f (Right b))

(*⑦ f7: ('a -> 'b, 'a -> 'c) sum -> 'a -> ('b,'c) sum*)
let f7 sum =
  match sum with
    Left (a, b) -> fun a -> Left a  
  | Right (a, b) -> fun b -> Right b;;


