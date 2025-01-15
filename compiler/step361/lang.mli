(* Extension of the earlier language
*)

include module type of Lang_35

(* if without else *)
val if2  : repr -> repr -> repr

(* if-then-else *)
val if3  : repr -> repr -> repr -> repr

