let incr x =
  let tmp = !x in
  x.contents <- (tmp + 1);;

(* Test *)
let x = ref 3;;
incr x;;
!x;;
(*- : int = 4*)