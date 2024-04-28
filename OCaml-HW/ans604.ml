type nat = Zero | None | OneMoreThan of nat;;

let rec minus m n =
  match n with
    Zero -> m
    | OneMoreThan n' -> match m with
                          Zero -> None
                        | OneMoreThan m' -> minus m' n';;  


let two = OneMoreThan (OneMoreThan Zero)
and three = OneMoreThan (OneMoreThan (OneMoreThan Zero));;

minus three two;;
(*- : nat = OneMoreThan Zero*)

minus two three;;
(*- : nat = None*)
