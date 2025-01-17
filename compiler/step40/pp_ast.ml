(* Extending the pretty-printer  *)

include Pp_ast_3

type tname = string

let fundecl : vname -> ((vname*tname) list * tname) -> repr -> repr -> repr =
  fun name (args,ret) exp body ->
    Printf.ksprintf paren "letfun (%s(%s):%s %s) %s"
      name 
      (args |> List.map (fun (arg,typ) -> arg ^ ":" ^ typ) |> String.concat ",")
      ret exp body
