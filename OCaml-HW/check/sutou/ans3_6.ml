(* 練習問題 3.6 *)

(* o1 *)
(* 負の数が入力されるとまずい *)
let geo_mean (x,y) = x *. y |> sqrt;;

(* o2 *)
(* ubuntu 上のvscodeから確認できないのが面倒 *)
let bmi (name, height, weight) =
  name ^ "さんは" ^
  (let index = weight /. height /. height in
  if index < 18.5 then "やせ"
  else if index < 25. then "標準"
  else if index < 30. then "肥満"
  else "高度肥満")
  ^ "です"
  ;;

(* o3 *)
(* 要するにsum_and_diff の逆関数 *)
let f (s,d) = ((s + d) / 2, (s - d) / 2);;