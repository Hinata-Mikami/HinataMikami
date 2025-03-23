(* 練習問題 4.6 *)

(*
fun x y -> y
をs, kのみで表すと

k (s k k)

で表せる. 以下評価ステップによる説明(?)

k (s k k) x y
->...-> k (fun x -> x) x y
-> (fun w x -> x) x y
-> (fun x -> x) y
-> y

*)