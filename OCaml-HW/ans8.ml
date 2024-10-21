(*8-1*)
type 'a ref = { mutable contents : 'a };;

(*ef 関数で行います。ref 関数は参照先に格納する初期値を引数としてとり，そこへの参照（その値を指す矢印）を返します*)
let ref n = { contents = n };;

(*。参照から格納された値を取出すには前
置演算子! を使用します*)
let (!) a =  a.contents;;

(*，参照の書き換え（代入（assignment）と呼ぶことが多い
です）は，中置演算子:=*)
let (:=) a b = a.contents <- b;;


(*8-2*)
let incr x =
  let tmp = !x in
  x.contents <- (tmp + 1);;

(* Test *)
let x = ref 3;;
incr x;;
!x;;
(*- : int = 4*)


(*8-3*)
let f = ref (fun y -> y + 1)
(*f = {contents : fun y -> y + 1}*)

let funny_fact x = 
  if x = 1 then 1 
  else x * (!f (x - 1));;
(*!f でf.contentsを呼び出す*)

f := funny_fact;;
(*fをfunny_factに書き換え*)

(*fはfunny_fact関数中でfunny_factに置き換わるため，else 以降は実質 x * (funny_fact (x-1))となり，再帰計算的役割を果たしている。
*)


(*8-4*)
let fib n =
  let xn = ref 1 in
  let xn_1 = ref 1 in
  let xn_2 = ref 0 in
  for k = 1 to n - 1 do
    xn := !xn_1 + !xn_2;
    xn_2 := !xn_1;
    xn_1 := !xn
  done;
  !xn;;

(* Test *)
let fib_list = [fib 1; fib 2; fib 3; fib 4; fib 5; fib 6; fib 7];;
(*val fib_list : int list = [1; 1; 2; 3; 5; 8; 13]*)


(*8-5*)
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


(*8-6*)
(* while (condition) do body done*)
let rec whle condition body =
  if condition () then
  begin 
    body(); whle condition body 
  end;;

(* for ()*)
let rec fr k up_or_down k_end body =
  if up_or_down = "up" then
    if (k = k_end) = false then
      begin 
        body(); fr (k+1) up_or_down k_end body
      end
    else body()
  else
    if (k = k_end) = false then
      begin 
        body(); fr (k-1) up_or_down k_end body
      end
    else body();;


(*8-7*)
let rec iter f = function
   [] -> ()
  | a :: rest -> begin f a; iter f rest end;;

let array_iter f array =
  let index = ref 0 in
  let condition = ref true in
  while !condition = true do
    begin
        try f array.(!index); index := !index + 1
        with Invalid_argument "index out of bounds" -> condition := false
    end
  done;;  

(*Test*)
array_iter (fun s -> print_string "Station: "; print_endline s)
[|"Tokyo"; "Shinagawa"; "Shin-Yokohama";
"Nagoya"; "Kyoto"; "Shin-Osaka"|];;

(*
Station: Tokyo
Station: Shinagawa
Station: Shin-Yokohama
Station: Nagoya
Station: Kyoto
Station: Shin-Osaka
- : unit = ()
*)


(*8-8*)
let array_iteri f array =
  let i = ref 0 in
  let condition = ref true in
  while !condition = true do
    begin
      try f !i array.(!i); i := !i + 1 
      with Invalid_argument "index out of bounds" -> condition := false
    end
  done;;  

(* Test *)
array_iteri (fun i s -> print_string "Station #"; print_int i;
print_string ": "; print_endline s) [|"Tokyo"; "Shinagawa"; "Shin-Yokohama"; "Nagoya"; "Kyoto"; "Shin-Osaka"|];;

(*
Station #0: Tokyo
Station #1: Shinagawa
Station #2: Shin-Yokohama
Station #3: Nagoya
Station #4: Kyoto
Station #5: Shin-Osaka
- : unit = ()
*)


(*8-9*)
type 'a mlist = MNil | MCons of 'a * 'a mlist ref;;
type 'a queue = {mutable head : 'a mlist; mutable tail : 'a mlist};;

let create () = {head = MNil; tail = MNil};;
let q : int queue = create();;

let add a = function
    {head = MNil; tail = MNil} as q ->
    let c = MCons (a, ref MNil) in q.head <- c; q.tail <- c
  | {tail = MCons(_, next)} as q ->
    let c = MCons (a, ref MNil) in next := c; q.tail <- c
  | _ -> failwith "enqueue: input queue broken";;



let peek = function
    {head = MNil; tail = MNil} -> failwith "hd: queue is empty"
  | {head = MCons(a, _)} -> a
  | _ -> failwith "hd: queue is broken";;

let take = function
    {head = MNil; tail = MNil} -> failwith "dequeue: queue is empty"
  | {head = MCons(a, next)} when next.contents = MNil -> q.head <- MNil; q.tail <- MNil; a
  | {head = MCons(a, next)} as q -> q.head <- !next; a
  | _ -> failwith "dequeue: queue is broken";;

ignore(take q); add 5 q; peek q;;

(*
  add 5 q -> {head = MCons(5, MNil), tail = MCons(5, MNil)}
  peek = 
*)


(*8-10*)
let print_int n =
  output_string stdout (string_of_int n);;


(*8-11*)
let display_file file =
  let open_file = open_in file in
  let rec display_line i =
     begin print_int i;
           print_string " ";
           print_endline file;
           try display_line (i + 1) 
           with End_of_file -> close_in open_file
     end
  in display_line 1;;


(*8-12*)
let cp fl1 fl2 =
  let open_fl1 = open_in fl1 in
  let open_fl2 = open_out fl2 in
  let rec copy_line ()=
      try 
        output_string open_fl2 ((input_line open_fl1) ^ "\n"); 
        copy_line()
      with End_of_file -> 
        close_in open_fl1; 
        close_out open_fl2
  in copy_line ();;