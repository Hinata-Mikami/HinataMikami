(* Extending the pretty-printer  *)

include Pp_ast_35

(* if without else *)
let if2  : repr -> repr -> repr = Printf.ksprintf paren "if %s %s"

(* if-then-else *)
let if3  : repr -> repr -> repr -> repr = Printf.ksprintf paren "if %s %s %s"


let while_loop : repr -> repr -> repr = Printf.ksprintf paren "while %s do %s"
