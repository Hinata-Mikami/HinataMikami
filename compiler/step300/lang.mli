(* The definition of the language *)
(* For easier overview, we collect here all the extensions *)

type repr                               (* representation type *)

type atom

type vname = string

val int  : int64 -> atom
val bool : bool -> atom

val var : vname -> atom                 (* instead of varx *)

val local : vname * repr  -> repr -> repr

val atomic : atom -> repr


val neg  : repr -> repr
val succ : repr -> repr
val pred : repr -> repr
val not  : repr -> repr
val is_zero : repr -> repr

val add : repr -> atom -> repr

type obs                                (* observation type *)
val observe : repr -> obs


