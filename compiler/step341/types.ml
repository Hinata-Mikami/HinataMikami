(* Type language and type representation *)

include Types_impl_23

let void = "void"

(* Function type: a pair of arg types and the result type.
   Functions are not first-class, so function
   types are separate from value/variable types
 *)
type function_t = t list * t
