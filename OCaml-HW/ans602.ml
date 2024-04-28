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