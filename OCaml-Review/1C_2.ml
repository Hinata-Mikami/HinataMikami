(*型の隠蔽*)
(*mliファイルに入れる*)
module type Stack = 
sig
  type 'a stack
  val pop : 'a stack -> 'a * 'a stack
  val push : 'a -> 'a stack -> 'a stack
  val empty : 'a stack
  val size : 'a stack -> int
end

(*モジュールの実装*)
(*mlファイル*)
module Stackmod : Stack = 
struct
  type 'a stack = 'a list

  let pop = function
    | [] -> failwith "Empty stack"
    | x :: rest -> (x, rest)

  let push x s = x :: s
  let empty = []
  let size s = List.length s
end;;

(*Test*)
let s = Stackmod.empty;;
Stackmod.size s;;
(*- : int = 0*)
let s1 = Stackmod.push 1 s;;
let s2 = Stackmod.push 2 s1;;
let s3 = Stackmod.push 3 s2;;
Stackmod.size s3;;
(*- : int = 3*)
Stackmod.pop s3;;
(*- : int * int Stackmod.stack = (3, <abstr>)*)
