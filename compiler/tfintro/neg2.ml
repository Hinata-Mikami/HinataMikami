(* The negation transformer *)

module Neg2(F:module type of Lang2) = struct
  type repr = F.repr
  let int x     = F.int (-x)
  let add e1 e2 = F.add e1 e2

  (*Exercise 1*)
  let sub e1 e2 = F.sub e1 e2
end
