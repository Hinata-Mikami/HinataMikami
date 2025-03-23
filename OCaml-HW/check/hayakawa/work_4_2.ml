let rec repeat f n x =
  if n > 0 then repeat f (n - 1) (f x) else x;;

let fib n =
  let (fibn, _) =
    let sum (a, b) = (a + b, a) in
    repeat sum n (0, 1) in
  fibn;;

fib 10;;