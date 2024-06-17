open Syntax_cbn

exception Error of string
(*メイン関数*)

let rec print_command_value (env : env) (cmd : Syntax_cbn.command) (t_e : ty_env) : env * ty_env =
  let t_e' = Functions_cbn.print_command_type t_e cmd in
  match cmd with
  | CExp expr -> Eval_cbn.print_value (Eval_cbn.value_of_exp expr env); print_newline(); (env, t_e')
  | CLet (n, e) ->  print_string (" = "); 
    let command_let (env : env) (n : name) (e : expr) : (value * env) =
      (match Eval_cbn.value_of_exp e env with | v1 -> (v1, ((n, Thunk (e, env)) :: env))) in
    let (v,e') = command_let env n e in Eval_cbn.print_value v; print_newline();
    (e', t_e')
  | _ -> raise (Error "Main_cbn Error : Unexpected command at print_command_value")
  (* | CRLetAnd l ->
    let rec and_env (i: int) (l1: (name * name * expr) list) : env =
    match l1 with
    | [] -> env
    (* | (f, x, e) :: rest -> (f, VRLetAnd(i, l, env)) :: (and_env (i + 1) rest) in *)
    let nenv = and_env 0 l in
      (nenv, t_e') *)


let repl () =

  let lexbuf = Lexing.from_channel stdin in

  let rec loop_stdin (env:env) (t_e : ty_env) =  
    let () = print_string "# " in
    let () = flush stdout in
  
    match Parser_cbn.command Lexer_cbn.token lexbuf with
    | r ->
      (match print_command_value env r t_e with
      | (env', t_e') -> print_newline(); loop_stdin env' t_e'
      | exception Error s -> print_endline s; print_newline(); loop_stdin env t_e
      )
    | exception Lexer_cbn.Error msg ->
      Printf.printf "Lexing Error\n" ;
      print_endline msg;
      loop_stdin env t_e
    | exception Parsing.Parse_error ->
      Printf.printf "Parse Error "; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env t_e
  
  in loop_stdin [] []


let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
    
  let rec loop_file (env : env) (t_e : ty_env) = 
    match Parser_cbn.command Lexer_cbn.token lexbuf with 
    | r -> 
      (match print_command_value env r t_e with
      | (env', t_e') -> loop_file env' t_e'
      | exception Error s -> print_endline s; print_newline()
      )
    | exception Lexer_cbn.Error msg -> Printf.printf "Lexing Error\n"; print_endline msg;
    | exception Parsing.Parse_error 
      ->  Printf.printf "Parse Error "; 
          Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf);
  
  in loop_file [] []

let eval_input () =
  (*コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    let op_file = open_in file 
    in read_file op_file;
    close_in op_file;

  (*そうでないときは標準入力を評価read_eval_point loop*)
  else repl()

(*随時実行*)
let () = eval_input ()