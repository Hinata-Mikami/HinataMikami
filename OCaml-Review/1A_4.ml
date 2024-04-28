(*fix f x は引数xが与えられない限り展開されない*)
let rec fix f x = f (fix f) x;;
let count_up = function
  

let sum_to x =
  let loop f n =
    if n = 0 then 0
    else n + f (n - 1)
  in fix loop;;
