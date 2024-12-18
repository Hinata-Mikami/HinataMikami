(* Extension of the earlier language
*)

include module type of Lang_33

val empty : repr                         (* empty is not an atom! *)

val seq : repr -> repr -> repr

val local : ?mut:bool -> vname * repr  -> repr -> repr

val assign : vname -> repr -> repr

(* call with no arguments *)
val call0 : vname -> repr

(* Call with at least one argument *)
val call : vname -> repr -> atom list -> repr
