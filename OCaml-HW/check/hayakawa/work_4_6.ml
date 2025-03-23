let k x y = x;;
let s x y z = x z (y z);;

k (s k k) 3 4;;