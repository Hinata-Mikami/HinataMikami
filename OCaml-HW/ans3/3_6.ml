(* 1 *)
let geo_mean (x, y) =  sqrt (x *. y);;

(* 2 *)
let bmi (n, l, m) = 
    let b = m /. ((l /. 100.) *. (l /. 100.)) in 
    if b < 18.5 then n ^ "さんは やせ です"
    else if b < 25. then n ^ "さんは 標準 です"
    else if b < 30. then n ^ "さんは 肥満 です"
    else n ^ "さんは 高度肥満 です";;

(* 3 *) 
(* x -> x+y , y -> x-y なので， (x, y)を返すには...*)
let sum_and_diff (x, y) = (x + y, x - y);;
let f (x,y) = ((x + y)/2, (x - y)/2);;