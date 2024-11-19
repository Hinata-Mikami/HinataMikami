(* A language of types *)
type t                                  (* type representation: abstract *)

val int  : t
val bool : t

val eq : t -> t -> bool
val to_string : t -> string

exception Type_error of string
val type_error : ('a, unit, string, 'd) format4 -> 'a
val check_type : ?msg:string -> t -> t -> unit

