(* Type language and type representation, extension with reading *)

include Types_impl_35

(* TODO: make it extensible! *)
let of_string = function
  | "void"   -> void
  | "int"    -> int
  | "bool"   -> bool
  | "string" -> string
  | x        -> type_error "unknown type: %s" x

