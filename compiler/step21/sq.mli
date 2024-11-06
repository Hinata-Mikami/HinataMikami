(* Sequences *)

type 'a t                               (* abstract *)

(* Hence a sequence is a monoid *)
val empty : 'a t 
val (@)   : 'a t -> 'a t -> 'a t

val one   : 'a -> 'a t

val iter  : ('a -> unit) -> 'a t -> unit

val map_reduce : ('a -> 'b) -> 'b -> ('b -> 'b -> 'b) -> 'a t -> 'b 

(* other useful operations, which we don't care about now:
  val all   : ('a -> bool) -> 'a t -> bool
  val concat     : 'a t list -> 'a t
  val fold_right : ('a -> 'z -> 'z) -> 'z -> 'a t -> 'z

  At least the first two are expressible as map_reduce.
*)
