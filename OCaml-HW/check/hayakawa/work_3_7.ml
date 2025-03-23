let rec pow_1 (x, n) = if n = 0 then 1 else (pow_1 (x, n-1)) * x;;

let rec pow_2 (x, n) = if n = 0 then 1 else if (n mod 2) == 0 then int_of_float (float_of_int ((pow_2 (x, n/2))) ** 2.) else int_of_float (float_of_int ((pow_2 (x, n/2))) ** 2. *. (float_of_int x));;

pow_1 (2, 15);;
pow_2 (2, 15);;