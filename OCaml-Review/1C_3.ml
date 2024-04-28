type order = LT | EQ | GT (* < , = , >*)
type 'a bst =
  | Empty
  | Node of 'a * 'a bst * 'a bst

module type ORDERED_TYPE =
  sig 
    type t 
    val compare : t -> t -> order 
  end 

module MakeSet (Order : ORDERED_TYPE) =
  struct
    type elt = Order.t
    type t = elt bst

    let empty = Empty

    let rec add x = function
      | Empty -> Node (x, Empty, Empty)
      | Node (y, left, right) ->
        match Order.compare x y with
        | EQ -> Node (y, left, right)
        | LT -> Node (y, add x left, right)
        | GT -> Node (y, left, add x right)

    let rec merge t1 t2 =
      match t1, t2 with
      | Empty, t | t, Empty -> t
      | Node (x, left, right), Node (_, _, _) ->
          Node (x, left, merge right t2)

    let rec remove x = function
      | Empty -> Empty
      | Node (y, left, right) ->
          match Order.compare x y with
          | EQ -> merge left right
          | LT -> Node (y, remove x left, right)
          | GT -> Node (y, left, remove x right)

    let rec mem x = function
      | Empty -> false
      | Node (y, left, right) ->
          match Order.compare x y with
          | EQ -> true
          | LT -> mem x left
          | GT -> mem x right

    let rec size = function
      | Empty -> 0
      | Node (_, left, right) -> 1 + size left + size right


  end;;