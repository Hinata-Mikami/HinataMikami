let rec pow_n_x n x = if n = 0 then 1 else (pow_n_x (n - 1) x) * x;;

let rec pow_x_n x n = if n = 0 then 1 else (pow_x_n x (n - 1)) * x;;

pow_n_x 15 2;;
pow_x_n 2 15;;