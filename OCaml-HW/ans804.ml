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