let and_and_1 b_1 b_2 = not(not(b_1) || not(b_2));;

let or_or_1 b_1 b_2 = not(not(b_1) && not(b_2));;

and_and_1 true true;;
and_and_1 true false;;
or_or_1 true false;;
or_or_1 false false;;