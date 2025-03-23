let cond (b, e_1, e_2) = if b then e_1 else e_2;;

let rec fact n = cond ((n == 1), 1, n * fact(n - 1));;

fact 4;;
(*再起関数内にcondを使用した場合、無限ループが発生して定義できなくなってしまう*)
