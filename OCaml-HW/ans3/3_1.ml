(* 1 *)
let yen_of_dollar x =
  let y = x *. 114.32 in
  if y -. (floor y) >= 0.5 then int_of_float(floor y +. 1.0) 
  else int_of_float (floor y);;

(* 2 *)
let dollar_of_yen (x : int) =
  let y = float_of_int x /. 114.32 *. 100. in
  if y -. (floor y) >= 0.5 then (floor y +. 1.0) /. 100.
  else (floor y) /. 100.;;

(* 3 *)
let exchange x =
  let y = yen_of_dollar x in
  (string_of_float x) ^ " dollars are " ^ (string_of_int y) ^ " yen.";;

(* 4 *)
let capitalize (x : char) =
  let y = int_of_char x in
  if 97 <= y && y <= 122
    then char_of_int (y - 32)
    else x;;