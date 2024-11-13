(* (not very) Pretty-printer of the AST, just to confirm parsing *)
(* Extension *)
(* This is the pretty-printer from step 22! Needs to be extended *)

include Pp_ast_20

let bool : bool -> repr   = string_of_bool

let not      : repr -> repr = prepend "not "      >> paren
let is_zero  : repr -> repr = prepend "is_zero "  >> paren
let add : repr -> repr -> repr = fun x y ->
  "(" ^ x ^ " + " ^ y ^ ")"


