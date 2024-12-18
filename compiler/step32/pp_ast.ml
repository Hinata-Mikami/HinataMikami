(* Extension to the pretty-printer *)

include Pp_ast_30

let sub : repr -> atom -> repr = Printf.ksprintf paren "sub %s %s"
let mul : repr -> atom -> repr = Printf.ksprintf paren "mul %s %s"

(* boolean conjunction and disjunction *)
let band : repr -> atom -> repr = Printf.ksprintf paren "band %s %s"
let bor  : repr -> atom -> repr = Printf.ksprintf paren "bor %s %s"

(* comparison *)
let eq  : repr -> atom -> repr = Printf.ksprintf paren "eq %s %s"
let neq : repr -> atom -> repr = Printf.ksprintf paren "neq %s %s"
let lt  : repr -> atom -> repr = Printf.ksprintf paren "lt %s %s"
let leq : repr -> atom -> repr = Printf.ksprintf paren "leq %s %s"
let gt  : repr -> atom -> repr = Printf.ksprintf paren "gt %s %s"
let geq : repr -> atom -> repr = Printf.ksprintf paren "geq %s %s"

