(* Extending the pretty-printer with local_atom *)

include Pp_ast_32

let local_atom : vname * atom -> repr -> repr = local
