(* 練習問題 3.1 *)

(* o1 *)
(* 四捨五入は0.5を足してから切り捨てることで行う (負の場合は厳密には四捨五入にならない) *)
let jpy_of_usd usd = let rate = 114.32 in 
  usd *. rate +. 0.5 |> floor |> int_of_float;;

(* o2 *)
let usd_of_jpy jpy = let rate = 114.32 in 
  floor ((float_of_int jpy) /. rate *. 100. +. 0.5) /. 100.;;

(* o3 *)
let discription_as_jpy_of_usd usd = 
  (string_of_float usd) ^ " dollars are " ^ (jpy_of_usd usd |> string_of_int) ^ " yen.";;

(* o4 *)
let capitalize c = 
  let cint = int_of_char c
  in if (int_of_char 'a') <= cint && cint <= (int_of_char 'z')
  then cint + (int_of_char 'A') - (int_of_char 'a') |> char_of_int
  else c
;;
