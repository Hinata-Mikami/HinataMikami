let geo_mean x y = sqrt (x *. y);;

let bmi (n, h, w) = let x = w /. (h *. h) in if x < 18.5 then (print_string (n ^ "さんはやせています")) else (if x < 25. then (print_string(n ^ "さんは標準です")) else if x < 30. then print_string (n ^ "さんは肥満です") else print_string (n ^ "さんは高度肥満です"));;

let sum_and_diff (x, y) = (x + y, x - y);;

let f_c (x, y) = ((x + y) / 2, (x - y) / 2);; 

bmi ("早川", 1.84, 70.);;
f_c (sum_and_diff (3, 5));;