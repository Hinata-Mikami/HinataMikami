(* The definition of the language: extension *)

include module type of Lang_20

val bool : bool -> repr

val not     : repr -> repr
val is_zero : repr -> repr

(* Ex 9 *)
val add : repr -> repr -> repr