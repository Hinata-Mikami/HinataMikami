(* 練習問題 4.3 *)

let ($) f g x = f (g x);;

let rec funny f n =
  if n = 0 then Fun.id
  else if n mod 2 = 0 then funny (f $ f) (n / 2)
  else funny (f $ f) (n / 2) $ f;; 

(* 
の働きは, 関数fをn回合成した関数を返すことである.
つまり, repeat関数と同じであるが, 再帰構造を工夫して再帰呼び出し回数がlog_2 n 回になるようになっている. 

*)
