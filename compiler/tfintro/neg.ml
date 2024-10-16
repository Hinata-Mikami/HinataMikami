(* The negation transformer *)

module Neg(F:module type of Lang) = struct
  type repr = F.repr
  let int x     = F.int (-x)
  let add e1 e2 = F.add e1 e2
end
