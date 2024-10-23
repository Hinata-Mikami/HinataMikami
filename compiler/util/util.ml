(* My common utilities *)


(* Reduce: a particular case of foldl over a non-empty list *)
let reduce : ('a -> 'a -> 'a) -> 'a list -> 'a = fun f -> function
  | h::t -> List.fold_left f h t
  | _    -> Invalid_argument "reduce on empty list" |> raise

(* A general map-reduce over a monoid *)
let map_reduce : ('a -> 'b) -> 'b -> ('b -> 'b -> 'b) -> 'a list -> 'b =
  fun f empty append l -> 
    let rec loop = function
      | []   -> empty
      | [x]  -> f x
      | h::t -> append (f h) (loop t)
    in loop l

type fname = string

let with_input_file : fname -> (in_channel -> 'w) -> 'w = fun fname k ->
  let ch = open_in fname in
  match k ch with
  | res -> close_in ch; res
  | exception e -> close_in_noerr ch; raise e

let with_output_file : fname -> (out_channel -> 'w) -> 'w = fun fname k ->
  let ch = open_out fname in
  match k ch with
  | res -> close_out ch; res
  | exception e -> close_out ch; raise e

(* Unique symbol with the given base name *)
let gensym : string -> string = 
  let counter = ref 0 in
  fun base ->
    incr counter;
    base ^ "_" ^ string_of_int !counter

let fail : ('a, unit, string, 'd) format4 -> 'a = fun fmt ->
  Printf.ksprintf failwith fmt
