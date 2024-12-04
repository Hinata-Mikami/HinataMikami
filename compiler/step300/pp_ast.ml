(* Extension to the pretty-printer *)

include Pp_ast_23

type vname = string                               (* representation type *)

let var : vname -> atom = Fun.id

let local : vname * repr -> repr -> repr = fun (name,exp) body ->
  Printf.kprintf paren "let [%s,%s] %s" name exp body
