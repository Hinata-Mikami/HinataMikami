(* 練習問題 4.5 *)

(*
twice twice f x の評価ステップ

twice twice f x
-> (twice (twice f)) x
-> (twice (fun x -> f (f x))) x
-> (fun x -> f (f x)) ((fun x -> f (f x)) x)
-> (fun x -> f (f x)) (f (f x))
-> f (f (f (f x)))

1つ目の twice が高階関数としてふるまってくれているおかげで f(f(f(f x)))として働いている.

*)