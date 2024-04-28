type 'a ref = { mutable contents : 'a };;

(*ef 関数で行います。ref 関数は参照先に格納する初期値を引数としてとり，そこへの参照（その値を指す矢印）を返します*)
let ref n = { contents = n };;

(*。参照から格納された値を取出すには前
置演算子! を使用します*)
let (!) a =  a.contents;;

(*，参照の書き換え（代入（assignment）と呼ぶことが多い
です）は，中置演算子:=*)
let (:=) a b = a.contents <- b;;