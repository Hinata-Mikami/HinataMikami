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
