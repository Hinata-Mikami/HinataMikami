let r = 114.32;;

let round_up x = if x -. (floor x) >= 0.5 then (floor x) +. 1. else x;;

let dollar_to_yen x = int_of_float(round_up(r *. x));;

let yen_to_dollar x = (round_up(100. *. float_of_int(x) /. r)) /. 100.;;

let print_exchange x = print_string(string_of_float(x) ^ " dollars are " ^ string_of_int(dollar_to_yen(x)) ^ " yen.");;

let capitalize c = if (int_of_char c) > 64 && 123 > (int_of_char c) then char_of_int ((int_of_char c) - 32) else c;;

dollar_to_yen 100.;;
yen_to_dollar 100;;
print_exchange 100.;;
capitalize 'c';;
capitalize '/';;