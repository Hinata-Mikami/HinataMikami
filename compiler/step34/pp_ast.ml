(* Extending the pretty-printer  *)

include Pp_ast_33

let empty : repr = "()"

let seq : repr -> repr -> repr = Printf.ksprintf paren "seq %s %s"

let local ?(mut=false) ((name:vname),(be:repr)) (body:repr) : repr =
  local ((if mut then "*" ^ name else name),be) body

let assign : vname -> repr -> repr = Printf.ksprintf paren "assign %s %s" 

(* call with no arguments *)
let call0 : vname -> repr = Printf.ksprintf paren "call0 %s"


(* Call with at least one argument *)
let call : vname -> repr -> atom list -> repr = fun n e atoms ->
  Printf.ksprintf paren "call %s %s%s" n e 
    (List.map ((^) " ") atoms |> String.concat "")



