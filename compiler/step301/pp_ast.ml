(* Extension to the pretty-printer *)

include Pp_ast_23

type vname = string                               (* representation type *)

let var : vname -> atom = Fun.id

(* 
let local : vname * repr -> repr -> repr = fun (name,exp) body ->
  Printf.kprintf paren "let [%s,%s] %s" name exp body *)

(* Ex 13 *)
(* 複数のdeclに対応 *)
let local : (vname * repr) list -> repr -> repr = fun decls body ->
  let decl_str =
    List.fold_right (fun (name, exp) acc ->
      Printf.sprintf "[%s,%s] %s" name exp acc
    ) decls body
  in
  Printf.sprintf "(let %s)" decl_str

  