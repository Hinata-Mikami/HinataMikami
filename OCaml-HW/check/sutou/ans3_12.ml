(* 練習問題 3.12 *)

let rec pos n = (* arctan 1 の級数近似計算 *)
  (if n < 1 then 0. else pos (n-1) -. 1. /. (float_of_int (4 * n - 1)))
  +. 1. /. (float_of_int (4 * n + 1))
;;