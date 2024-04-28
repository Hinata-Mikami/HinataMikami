(* 1 *)
let rec downto1 n =
  match n with 
    1 -> [1];
  | _ -> n :: downto1 (n - 1);;

downto1 6;;


(* 2 *)
let rec roman l n =
  match l with
    [] -> ""
  | (x, y)::rest when x <= n -> y ^ (roman ((x, y)::rest)  (n-x)) 
  | (x, y)::rest when x > n -> roman rest n;;

roman [(1000, "M"); (500, "D"); (100, "C"); (50, "L"); (10, "X"); (5, "V"); (1, "I")] 1984;;
roman [(1000, "M"); (900, "CM"); (500, "D"); (400, "CD"); (100, "C"); (90, "XC"); (50, "L"); (40, "XL"); (10, "X"); (9, "IX"); (5, "V"); (4, "IV"); (1, "I")] 1984;;


(* 3 *)
let nested_length list =
  let rec num_of_list l = 
    match l with
      [] -> 0
    | _::[] -> 1
    | _::rest -> 1 + (num_of_list rest)
  in 
  let rec length l = 
    match l with
      [] -> 0
    | x::rest -> (num_of_list x) + (length rest)
in length list;;

nested_length [[1; 2; 3]; [4; 5]; [6]; [7; 8; 9; 10]];;


(* 4 *)
let rec concat list =
  match list with 
    [] -> []
  | x::rest -> x @ (concat rest);;

concat [[0; 3; 4]; [2]; []; [5; 0]];;


(* 5 *)
let rec zip la lb =
  match (la, lb) with
    ([], _) -> []
  | (_, []) -> []
  | (a::rest, b::rest') -> (a, b)::(zip rest rest');;

zip [2; 3; 4; 5; 6; 7; 8; 9; 10; 11] [true; true; false; true; false; true; false; false; false; true];;


(* 6 *)
let rec unzip list =
  let rec unzip_a l =
    match l with
      [] -> []
    | (a, b)::rest -> a::(unzip_a rest)
  in
  let rec unzip_b l =
    match l with
      [] -> []
    | (a, b)::rest -> b::(unzip_b rest)
  in (unzip_a list, unzip_b list);;

unzip (zip [2; 3; 4; 5; 6; 7; 8; 9; 10; 11] [true; true; false; true; false; true; false; false; false; true]);;


(* 7 *)
let rec filter f list =
  match list with
    [] -> []
  | x::rest when f x -> x::(filter f rest)
  | x::rest -> filter f rest;;

let is_positive x = (x > 0);;

let rec length = function (*p.90より*)
  [] -> 0
  | _ :: rest -> 1 + length rest;;

filter is_positive [-9; 0; 2; 5; -3];;
filter (fun l -> length l = 3) [[1; 2; 3]; [4; 5]; [6; 7; 8]; [9]];;


(* 8 *)
let rec take n list =
  match list with
    [] -> []
  | x::rest when n > 0 -> x::take (n-1) rest
  | x::rest -> [];;

let rec drop n list =
  match list with
    [] -> []
  | x::rest when n > 0 -> drop (n-1) rest
  | x::rest -> x::(drop (n-1) rest);; 

let ten_to_zero = downto1 10;;
take 8 ten_to_zero;;
drop 7 ten_to_zero;;


(* 9 *)
let max_list list =
  let rec search n l = 
    match l with
      [] -> n
    | x::rest when x >= n -> search x rest
    | x::rest -> search n rest
  in search 0 list;;




  

