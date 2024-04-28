(*fをn回xに適用する回数*)
let rec repeat f n x =
  if n > 0 then repeat f (n - 1) (f x) else x;;

let fib n =
  let (fibn, _) =
  (* (x1, x0) -> (x2, x1) = (x1+x0 + x1)*)
  let fib_next (x, y) = (x + y, x)
  in repeat fib_next n (1, 0)
in fibn;;