(* Extension to the pretty-printer *)
include Pp_ast_23



type vname = string                               (* representation type *)

let var : vname -> atom = Fun.id


(* Ex 14 *)
(* 複数のdeclに対応 *)
let local : (vname * repr) list -> repr -> repr =
  let counter = ref 0 in (* カウンタを保持 *)
  fun decls body ->
    let rename name =
      if name = "x" then name (* グローバル変数 x はそのまま *)
      else
        let unique_name = Printf.sprintf "%s_%d" name !counter in
        incr counter;
        unique_name
    in
    let renamed_decls = 
      List.map (fun (name, exp) -> (rename name, exp)) decls
    in
    let body_str =
      List.fold_left
        (fun acc (name, _) -> Str.global_replace acc name (rename name))
        body
        renamed_decls
    in
    let decl_str =
      List.fold_right
        (fun (name, exp) acc -> Printf.sprintf "[%s,%s] %s" name exp acc)
        renamed_decls
        body_str
    in
    Printf.sprintf "(let %s)" decl_str
