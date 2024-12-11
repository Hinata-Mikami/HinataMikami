(* Question/Answering system *)
(* Standard implementation of the Reader monad, as Free(er) monad *)

let (>>) f g x = f x |> g

module Que = Hole.Hole()

type 'd t = 
   | A : 'd  -> 'd t                      (* answer *)
   | Q : 'a Que.t * ('a -> 'd t) -> 'd t  (* question *)

let ans : 'd -> 'd t = fun v -> A v
let que : 'a Que.t -> 'd t = fun q -> Q(q,ans)

(* Also known as fmap *)
let rec lift1 : ('a->'b) -> ('a t -> 'b t) = fun op e ->
  match e with
  | A v     -> A (op v)
  | Q (n,k) -> Q (n, k >> lift1 op)

let rec lift2 : ('a->'b->'c) -> ('a t -> 'b t -> 'c t) = fun op e1 e2 ->
  match (e1,e2) with
  | (A v1, A v2) -> A (op v1 v2)
  | (Q (n,k), e2) -> Q (n, (fun v -> lift2 op (k v) e2))
  | (e1, Q (n,k)) -> Q (n, (fun v -> lift2 op e1 (k v)))

(* also known as lift *)
let rec (let*) : 'a t -> ('a -> 'b t) -> 'b t = fun d k -> 
  match d with
  | A v     -> k v
  | Q(n,k') -> Q(n, k' >> Fun.flip (let*) k)

let rec lift_list : 'a t list -> ('a list -> 'b t) -> 'b t = fun l k ->
  match l with
  | []   -> k []
  | h::t -> let* v = h in lift_list t (List.cons v >> k)

(* Handlers: mapping over the 'd t tree.  *)

let handle : Que.plug -> 'd t -> 'd t = fun {p} ->
   let rec loop = function
     | A x -> ans x
     | Q (n,k) -> match p n with 
       | Some r -> k r |> loop
       | None   -> Q (n, k>>loop)
   in loop

(* Que.plug is a handler that should print an error message, rather than
   returning 
*)
let top_hand : Que.plug -> 'd t -> 'd = fun {p} -> function
  | A v -> v
  | Q (n,_) -> match p n with
    | None ->   failwith "Unhandled"
    | Some _ -> failwith "The error handler shouln't have returned"
 
