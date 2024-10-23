(* My common definitions, which can always be kept open *)

(* Function composition *)
let (>>) f g = fun x -> f x |> g

let map_fst : ('a -> 'b) -> (('a * 'c) -> ('b * 'c)) = fun f (x,y) ->
  (f x, y)

let map_snd : ('a -> 'b) -> (('c * 'a) -> ('c * 'b)) = fun f (x,y) ->
  (x, f y)
