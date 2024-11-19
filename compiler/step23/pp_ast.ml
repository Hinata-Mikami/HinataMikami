(* Extension to the pretty-printer *)

include Pp_ast_22

type atom = string                               (* representation type *)

let atomic : atom -> repr = Fun.id

let add : repr -> atom -> repr = Printf.kprintf paren "add %s %s"


