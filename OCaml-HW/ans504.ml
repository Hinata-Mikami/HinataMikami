(*
map 関数は，リスト処理には欠かせない汎用的な関数です。
関数fとリスト[a1; a2;...; an] から，
f を各要素に適用したようなリスト
[f a1; f a2; ...; f an] 
を計算します。
map は関数を引数に取る高階関数です。

map の定義は以下のように与えられます。
# let rec map f = function
[] -> []
| x :: rest -> f x :: map f rest;;
val map : (’a -> ’b) -> ’a list -> ’b list = <fun>
*)

(* map f (map g l) -> map (fun x -> ...) l*)

map (fun x -> f (g x)) l;;



