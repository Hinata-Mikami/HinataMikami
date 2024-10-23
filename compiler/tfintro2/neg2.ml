(* The negation transformer: extended *)
(* NOTE passing the extended F to the old interpreter transformer Neg.Neg! *)

module type Lang2 = module type of Lang2

module Neg(F:Lang2) = struct
  include Neg.Neg(F)
  let twice = F.twice
end
