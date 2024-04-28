(*[] への参照の例を実際に対話式コンパイラで試し，本文
中に書いた挙動との違い，特に，参照の型を説明し，どのようにしてtrue を[1] にコン
スしてしまうような事態の発生が防がれているか説明しなさい。*)

(*
# (2 :: !x, true :: !x);;
Error: This expression has type int list
       but an expression was expected of type bool list
       Type int is not compatible with type bool

空リストであるxに2を結合していることから!!xはint listと判定された。
その後bool型であるtrueを結合し用としたことでエラーとなった。
*)

(*
# let (get, set) =
let r = ref [] in
((fun () -> !r)    , (fun x -> r:=x));;
val get : unit -> '_weak3 list = <fun>
val set : '_weak3 list -> unit = <fun>
# 1 :: get ();;
- : int list = [1]
# "abc" :: get ();;
Error: This expression has type int list
       but an expression was expected of type string list
       Type int is not compatible with type string

前例と同様にint listにstringを結合しようとして型が競合した
*)