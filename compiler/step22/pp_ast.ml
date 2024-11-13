(* (not very) Pretty-printer of the AST, just to confirm parsing *)
(* Extension *)

include Pp_ast_20

let bool : bool -> repr   = string_of_bool

let not      : repr -> repr = prepend "not "      >> paren
let is_zero  : repr -> repr = prepend "is_zero "  >> paren


