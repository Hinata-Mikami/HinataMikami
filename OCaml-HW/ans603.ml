type nat = Zero | OneMoreThan of nat;;

let rec add m n =
  match m with 
    Zero -> n 
  | OneMoreThan m' -> OneMoreThan (add m' n);;

let rec mul m n =
  match m with
    Zero -> Zero
  | OneMoreThan m' -> add (mul m' n) n;;

let rec monus m n =
  match n with
    Zero -> m
    | OneMoreThan n' -> match m with
                          Zero -> Zero
                        | OneMoreThan m' -> monus m' n';;  

(*Test*)
let two = OneMoreThan (OneMoreThan Zero)
and three = OneMoreThan (OneMoreThan (OneMoreThan Zero));;

mul three two;;
(*- : nat = OneMoreThan (OneMoreThan (OneMoreThan (OneMoreThan (OneMoreThan (OneMoreThan Zero)))))*)

monus three two;;
(*- : nat = OneMoreThan Zero*)

monus two three;;
(*- : nat = Zero*)

monus three Zero;;
(*- : nat = OneMoreThan (OneMoreThan (OneMoreThan Zero))*)