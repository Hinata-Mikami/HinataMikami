include Pp_ast_300

let equal : repr -> atom -> repr = Printf.ksprintf paren "equal %s %s"

let ne : repr -> atom -> repr = Printf.ksprintf paren "ne %s %s"

let lt : repr -> atom -> repr = Printf.ksprintf paren "lt %s %s"

let le : repr -> atom -> repr = Printf.ksprintf paren "le %s %s"

let mt : repr -> atom -> repr = Printf.ksprintf paren "mt %s %s"

let me : repr -> atom -> repr = Printf.ksprintf paren "me %s %s"

let minus : repr -> atom -> repr = Printf.ksprintf paren "minus %s %s"

let times : repr -> atom -> repr = Printf.ksprintf paren "times %s %s"

let div : repr -> atom -> repr = Printf.ksprintf paren "div %s %s"