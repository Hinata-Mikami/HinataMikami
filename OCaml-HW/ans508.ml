(*
let rec map f = function
  [] -> []
  | x :: rest -> f x :: map f rest;;
*)

let map2 f list=
  let rec map g l =
    match l with
      [] -> []
      | x::rest -> g x :: map g rest
  in map f list;;
