(* Extending the pretty-printer  *)

include Pp_ast_36

let while_ : repr -> repr -> repr = Printf.ksprintf paren "while %s %s"

let for_  : (vname*repr) -> atom -> repr -> repr = fun (name,lwb) upb body ->
  Printf.ksprintf paren "for (%s %s %s) %s" name lwb upb body


