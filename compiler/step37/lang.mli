(* Extension of the earlier language
*)

include module type of Lang_36

val while_ : repr -> repr -> repr

val for_  : (vname*repr) -> atom -> repr -> repr
