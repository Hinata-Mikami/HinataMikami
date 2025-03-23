let and_and b_1 b_2 = if b_1 == true then (if b_2 == true then true else false) else false;;

let or_or b_1 b_2 = if b_1 == false then (if b_2 == true then true else false) else true;;

and_and true true;;
and_and true false;;
or_or true false;;
or_or false false;;