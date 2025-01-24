(* Sequences, with easy concatenation and dedicated `notes'
   (side-sequence that is traversed first)
 *)

type 'a t  = 
  | I of 'a
  | J of 'a t * 'a t                    (* args have no notes attached *)
  | P of 'a t * 'a t                    (* The first arg is the note,
                                           the second arg does not contain
                                           any notes *)
  | N

let empty : 'a t = N
(* Maintaining the invariant that the arguments of J, and the second
   argument (right child) of P have no notes.
   Notes are all collected in the left child of P.
   The processing is hence not the constant-time on the nose,
   but ammortized constant time (because notes propagate up).
   Notes are relatively rare.
*)
let rec (@) : 'a t -> 'a t -> 'a t = fun x y -> match (x,y) with
  | (N,x) | (x,N) -> x
  | (P (p1,b1), P (p2,b2)) -> P(p1 @ p2,J(b1,b2)) (* rare case *)
  | (P (p,b), x) -> P (p, J(b,x))
  | (x, P (p,b)) -> P (p, J(x,b))
  | (x,y)        -> J(x,y)

(* designate a sequence as a side-sequence (note) *)
let as_note : 'a t -> 'a t = fun x -> P (x,N)
 
let one : 'a -> 'a t = fun x -> I x

let iter : ('a -> unit) -> 'a t -> unit = fun f ->
  let rec loop = function
    | N       -> ()
    | I x     -> f x
    | J (x,y) -> loop x; loop y
    | P (x,y) -> loop x; loop y
  in loop

let rec map : ('a -> 'b) -> 'a t -> 'b t = fun f -> function
  | N -> N
  | I x -> I (f x)
  | J (x,y) -> J (map f x, map f y)
  | P (x,y) -> P (map f x, map f y)

(* XXX It's better to maintain the invariant that concat_map
   is expressible in terms of map_reduce, with reducer being (@)
   Therefore, the treatment of notes should be improved.
 *)
let map_reduce : ('a -> 'b) -> 'b -> ('b -> 'b -> 'b) -> 'a t -> 'b = 
 fun f empty append sq -> 
   let rec loop = function
     | N -> empty
     | I x -> f x
     | J (x,y) -> append (loop x) (loop y)
     | P (x,y) -> append (loop x) (loop y)
   in loop sq

(*
let rec concat_map   : ('a -> 'b t) -> 'a t -> 'b t = fun f -> function
  | N -> N
  | I x -> f x
  | J (x,y) -> (concat_map f x) @ (concat_map f y)
  | P (x,y) -> as_note (concat_map f x) @ (concat_map f y)
*)
