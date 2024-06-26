let rec change coins amount =
  match (coins, amount) with
    (_, 0) -> []
  | ((c :: rest) as coins, total) ->
    if c > total then change rest total
    else
    (try c :: change coins (total - c) with Failure "change" -> change rest total)
  | _ -> raise (Failure "change")

(* Test *)
change [5; 2] 16;;
(*- : int list = [5; 5; 2; 2; 2]*)