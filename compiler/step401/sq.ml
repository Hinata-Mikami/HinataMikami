(* The sequence with annotations *)

type annot = int list

type 'a t  = 
  | B of 'a Sq_base.t
  | A of annot * 'a Sq_base.t

let empty : 'a t = B Sq_base.empty

let (@) : 'a t -> 'a t -> 'a t = fun x y -> match (x,y) with
  | (B s1,B s2) -> B Sq_base.(s1 @ s2)
  | (A (a,s1),B s2) 
  | (B s1,A (a,s2)) -> A (a, Sq_base.(s1 @ s2))
  | (A (a1,s1), A (a2,s2)) -> A (a1 @ a2, Sq_base.(s1 @ s2))

let as_note : 'a t -> 'a t = function
  | B s -> B (Sq_base.as_note s)
  | A (a,s) -> A (a, Sq_base.as_note s)

let one : 'a -> 'a t = fun x -> B (Sq_base.one x)

let iter : ('a -> unit) -> 'a t -> unit = fun f -> function
  | A (_,s) | B s -> Sq_base.iter f s

let rec map : ('a -> 'b) -> 'a t -> 'b t = fun f -> function
  | B s -> B (Sq_base.map f s)
  | A (a,s) -> A (a, Sq_base.map f s)

let map_reduce : ('a -> 'b) -> 'b -> ('b -> 'b -> 'b) -> 'a t -> 'b = 
  fun m z r -> function
  | A (_,s) | B s -> Sq_base.map_reduce m z r s

let add_annot : int -> 'a t -> 'a t = fun n -> function
  | B s -> A ([n],s)
  | A (a,s) -> A(n::a,s)

let get_annot : 'a t -> annot = function
  | B _     -> []
  | A (a,_) -> a

let set_annot : annot -> 'a t -> 'a t = fun a -> function
  | A (_,s) | B s -> if a = [] then B s else A (a,s)

