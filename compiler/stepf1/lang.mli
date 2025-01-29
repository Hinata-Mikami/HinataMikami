(* Extension of the earlier language
*)

include module type of Lang_3

type tname = string

val fundecl : vname -> ((vname*tname) list * tname) -> repr -> repr -> repr
