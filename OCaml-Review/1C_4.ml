(*連想配列...?*)
(*以下，ChatGPT 3.5*)

type order = LT | EQ | GT (* < , = , >*)

module type ORDERED_TYPE =
  sig 
    type t 
    val compare : t -> t -> order 
  end 

  (*
module type PAIR =
  sig
    type key
    type value
  end
*)

module MakeMap (Key : ORDERED_TYPE) =
  struct
    type key = Key.t
(*    type value = Value.value*)
    type pair = key * value
    type map = Node of pair * map * map | Empty

    let empty = Empty

    let rec add k v = function
      | Empty -> Node ((k, v), Empty, Empty)
      | Node ((k', _), left, right) ->
        match Key.compare k k' with
        | EQ -> Node ((k, v), left, right)
        | LT -> Node ((k', v), add k v left, right)
        | GT -> Node ((k', v), left, add k v right)

    let rec find k = function
      | Empty -> None
      | Node ((k', v), left, right) ->
        match Key.compare k k' with
        | EQ -> Some v
        | LT -> find k left
        | GT -> find k right

    let rec remove k = function
      | Empty -> Empty
      | Node ((k', v), left, right) ->
        match Key.compare k k' with
        | EQ -> merge left right
        | LT -> Node ((k', v), remove k left, right)
        | GT -> Node ((k', v), left, remove k right)

    and merge t1 t2 =
      match t1, t2 with
      | Empty, t | t, Empty -> t
      | Node (pair, left, right), Node (_, _, _) ->
          Node (pair, left, merge right t2)

    let rec mem k = function
      | Empty -> false
      | Node ((k', _), left, right) ->
        match Key.compare k k' with
        | EQ -> true
        | LT -> mem k left
        | GT -> mem k right

    let rec size = function
      | Empty -> 0
      | Node (_, left, right) -> 1 + size left + size right
  end;;
