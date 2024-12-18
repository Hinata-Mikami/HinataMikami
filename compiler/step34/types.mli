(* Extended types *)

include module type of Types_23

val void : t

(* Function type: a pair of arg types and the result type.
   Functions are not first-class, so function
   types are separate from value/variable types
 *)
type function_t = t list * t
