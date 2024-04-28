(*1000分割した場合を考える*)(*0<=n<=999*)
(*n番目の台形1つあたりの面積*)

let area f a b n =
  (f(a +. (float_of_int n)*. (b -. a) /. 1000.) +. f(a +. (float_of_int n +. 1.)*. (b -. a) /. 1000.))*. (b -. a) /. 1000. /. 2.;;

let rec sum f n =
  if n = 0 then 0. 
  else sum f (n - 1) +. f n;;

let integral f a b = sum (area f a b) 999;;

integral sin 0. 3.1415926;;
