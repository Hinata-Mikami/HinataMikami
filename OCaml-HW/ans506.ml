(*改前後のクイックソート*)
let rec quick_sort = function
    ([] | [_]) as l -> l
  | pivot :: rest 
  -> let rec partition left right = function
        [] -> let rec merge l1 l2 =
          match l1 with
            [] -> l2
            | x::rest -> x::(merge rest l2)
          in merge (quick_sort left) (pivot :: quick_sort right)
      
        | y :: ys -> if pivot < y then partition left (y :: right) ys else partition (y :: left) right ys
    in partition [] [] rest;;

(*
quick_sort [7;6;5;4;3;2;1;0];;
- : int list = [0; 1; 2; 3; 4; 5; 6; 7]   
*)

(* 改善前のクイックソート *)
let rec quick_sort_p105 = function
  (*パターン1*)
    (*空リストor1要素リスト->*)
    (*l には[]か[_]のどちらかが束縛される*)
    ([] | [_]) as l -> l

  (*パターン2*)
    (*2要素以上->先頭がpivot*)
  | pivot :: rest 

    (*partition関数を局所定義*)
  -> let rec partition left right = function

      (*パターン2-1*)
        (*[]に適用->left rightに2分割してソートした結果を結合して返す*)
        [] -> (quick_sort_p105 left) @ (pivot :: quick_sort_p105 right)

      (*パターン2-2*)
        (*要素/リストに適用->先頭がpivotより大きいときrightに結合，そうでないときはleftに結合。ここここまでの操作を要素数が1以下になるまで繰り返す*)

      | y :: ys -> if pivot < y then partition left (y :: right) ys else partition (y :: left) right ys

      (*はじめはleftもrightも空リスト*)
    in partition [] [] rest;;