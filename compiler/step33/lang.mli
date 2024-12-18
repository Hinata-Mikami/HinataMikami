(* Extension with local_atom: when the RHS os a binding is known to be
   an atom
*)

include module type of Lang_32

val local_atom : vname * atom  -> repr -> repr
