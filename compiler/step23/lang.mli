(* The definition of the language *)

include module type of Lang_22

(* extension *)
type atom

val int  : int64 -> atom
val bool : bool -> atom

val varx : atom

val atomic : atom -> repr

val add : repr -> atom -> repr

