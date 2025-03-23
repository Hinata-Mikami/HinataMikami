(* 練習問題 3.11 *)

(* o1 *)
let rec gcd (m,n) = (* Euclidの互除法 *)
  if m = n then m
  else if m < n then gcd(n-m,m)
  else gcd(m-n,n);;

(* o2 *)
let rec comb (n,m) = (* 組み合わせ数nCmを再帰的に計算する関数 *)
  (* 0<=m<=n という入力を期待している *)
  if m = 0 || n = m then 1
  else comb(n-1,m) + comb(n-1,m-1)
;;

(* o3 *)
let iterfib n = (* 末尾再帰のフィボナッチ数を計算する関数 *)
  (* n >= 1 *)
  let rec subiter (i, res, res_pred) =
    if i = n + 1 then res
    else subiter (i+1, res + res_pred, res)
  in
  subiter (2,1,0)
;;

(* o4 *)
let rec max_ascii s = (* 文字列からASCIIコードの最も大きい文字を返す関数 *)
  (* 長さ1以上の文字列を期待 *)
  let m = String.length s
  in
  let rec subiter (i, max) =
    if i = m then char_of_int max
    else 
    let t = int_of_char s.[i] in
    subiter (i+1, if t > max then t else max)
  in
  subiter (0,0);
;;