(*9-1*)
(*# #load "nums.cma";;
Cannot find file nums.cma.*)

(*教科書184ページの方法，Numライブラリのインストールをインターネットで検索したりしながら試したが上手くいかず， open Num　を実行できなかった*)


(*9-2*)
module type TABLE2 =
  sig
    type ('a, 'b) t = Empty | Entry of 'a * 'b * ('a, 'b) t
    val empty : ('a, 'b) t
    val add : 'a -> 'b -> ('a, 'b) t -> ('a, 'b) t
    val retrieve : 'a -> ('a, 'b) t -> 'b option
    val dump : ('a, 'b) t -> ('a * 'b) list
  end;;