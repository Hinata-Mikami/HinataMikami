(*insert関数・・・リスト内のいろいろな場所に入れ込むという発想*)

(* f (f (f ( f e))) *)
let rec fold_right f list e =
  match list with
  | [] -> e
  | x::rest -> f x (fold_right f rest e);;

let rec remove x = function
  | [] -> []
  | y :: rest when x = y -> remove x rest
  | y :: rest -> y :: remove x rest;;


let perm list =
  (*aは使用済み bは完成したリスト*)
  let rec make_perm n l a b =
    if n = 0 then a::b
    else fold_right (fun x y -> make_perm (n-1) 
    (remove x l) (x::a) y) l b
  in
    make_perm (List.length list) list [] [];;

(*http://www.nct9.ne.jp/m_hiroi/func/ocaml05.html*)
(*flow*)
(*
perm [1;2]
-> make_perm 2 [1;2] [] []
-> f 1 (fold_right f [2] [])
-> f 1 (f 2 (fold_right f [] []))
-> f 1 (f 2 [])
-> f 1 (make_perm 1 [1] [2] [])
-> f 1 (fold_right f [1] [])
-> f 1 (f 1 (fold_right f [] []))
-> f 1 (f 1 [])
-> f 1 (make_perm 0 [] [1;2] [])
-> f 1 [[1;2]]
-> make_perm 1 [2] [1] [[1;2]]
-> fold_right f 2 [] [[1;2]]
-> f 2 [[1;2]]
-> make perm 0 [] [2;1] [[1;2]]
-> [[2;1] [1;2]]
*)