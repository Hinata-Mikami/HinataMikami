(* Simple language of additions *)

type repr                            (* representation type (abstract) *)

(* Two operations of the language *)

val int: int -> repr
val add: repr -> repr -> repr

(*Exercise1*)
val sub: repr -> repr -> repr