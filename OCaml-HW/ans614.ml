(*無限列ヴァリアント*)
type intseq = Cons of int * (int -> intseq);;

(*intseqからn番目の要素を取り出す関数*)
let rec nthseq n (Cons(x, f)) =
  if n = 1 then x
  else nthseq (n-1) (f x);;

(*⌊√k⌋を計算する関数*)
let floor_of_sqrt k = int_of_float (floor (sqrt (float_of_int k)));;

(*以下は数字xが素数かどうかを判定する関数*)
(* 0 *)
let is_prime x =
  let rec is_divisible_from_2_to n =
    (n > 1) && 
    ((x mod n = 0) || is_divisible_from_2_to (n-1))
in not (is_divisible_from_2_to (x-1));;

(* 1 *)
let is_prime_1 x =
  let rec is_divisible_1 m n =
    (m < n) &&
    ((x mod m = 0) || is_divisible_1 (m+1) n)
  in not (is_divisible_1 2 x);;

(* 2 *)
let is_prime_2 x =
  let rec is_divisible_2 n =
    (n > 1) &&
    ((x mod n = 0) || is_divisible_2 (n-1))
in not (is_divisible_2 (floor_of_sqrt x));;

(* 3 *)
let rec is_prime_3 primes x =
  match primes with
   [] -> true
  | a::rest when (a > 1) && (x mod a = 0) -> false
  | a::rest -> is_prime_3 rest x

let rec prime_seq_3 primes x =
  if is_prime_3 primes (x+1) 
    then Cons (x+1, prime_seq_3 (x+1::primes))
  else prime_seq_3 primes (x+1);; 


(* 4 *)
let rec is_prime_4 primes x =
  let rec filter l =
    match l with
      [] -> []
    | a::rest when a <= floor_of_sqrt x
      -> a::(filter rest)
    | a::rest -> filter rest
  in let list = filter primes
in  
  match list with
   [] -> true
  | b::rest when (x mod b = 0) -> false
  | b::rest -> is_prime_4 rest x

let rec prime_seq_4 primes x =
  if is_prime_4 primes (x+1) 
    then Cons (x+1, prime_seq_4 (x+1::primes))
  else prime_seq_4 primes (x+1);;


(*0・1・2用　素数の無限列を作る関数*)
let rec prime_seq x =
  if is_prime (x+1) then Cons(x+1, prime_seq) 
  else prime_seq (x+1);;

let rec prime_seq_1 x =
  if is_prime_1 (x+1) then Cons(x+1, prime_seq_1) 
  else prime_seq_1 (x+1);;

let rec prime_seq_2 x =
  if is_prime_2 (x+1) then Cons(x+1, prime_seq_2) 
  else prime_seq_2 (x+1);;

(* Test *)
nthseq 3000 (prime_seq 1);;
(*- : int = 27449 約5秒*)
nthseq 3000 (prime_seq_1 1);;
(*- : int = 27449 約1秒*)
nthseq 3000 (prime_seq_2 1);;
(*- : int = 27449 約0.1秒*)
nthseq 3000 (prime_seq_3 [] 1);;
(*- : int = 27449 約0.8秒*)
nthseq 3000 (prime_seq_4 [] 1);;
(*- : int = 27449 約1.2秒*)
