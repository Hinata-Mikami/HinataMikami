(* Sequences, with easy concatenation *)

type 'a t  = 
  | I of 'a
  | J of 'a t * 'a t
  | N

let empty : 'a t = N
let (@) : 'a t -> 'a t -> 'a t = fun x y -> J (x,y)

let one : 'a -> 'a t = fun x -> I x

let iter : ('a -> unit) -> 'a t -> unit = fun f ->
  let rec loop = function
    | N       -> ()
    | I x     -> f x
    | J (x,y) -> loop x; loop y
  in loop

let map_reduce : ('a -> 'b) -> 'b -> ('b -> 'b -> 'b) -> 'a t -> 'b = 
 fun f empty append sq -> 
   let rec loop = function
     | N -> empty
     | I x -> f x
     | J (x,y) -> append (loop x) (loop y)
   in loop sq
