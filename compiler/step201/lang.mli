(* The definition of the language *)

type repr                               (* representation type *)

val int  : Int64.t -> repr

val varx : repr

val neg  : repr -> repr
val succ : repr -> repr
val pred : repr -> repr

(* Ex 5 *)
val not : repr -> repr
val iszero : repr -> repr

val bool : Bool.t -> repr

type obs                                (* observation type *)
val observe : repr -> obs
