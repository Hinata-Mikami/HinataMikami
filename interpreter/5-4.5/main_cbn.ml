open Syntax_cbn

exception Error of string
(*メイン関数*)

let repl () =

  let lexbuf = Lexing.from_channel stdin in

  let rec loop_stdin (env:env) (t_e : ty_env) =  
    let () = print_string "# " in
    let () = flush stdout in
  
    match Parser_cbn.command Lexer_cbn.token lexbuf with
    | r ->
      (match Eval_cbn.print_command_value env r t_e with
      | (env', t_e') -> print_newline(); loop_stdin env' t_e'
      | exception Eval_cbn.Error msg -> print_newline(); print_endline msg; loop_stdin env t_e
      | exception Functions_cbn.Error msg -> print_newline(); print_endline msg; loop_stdin env t_e
      | exception Error s -> print_newline(); print_endline s; print_newline(); loop_stdin env t_e
      )
 
    | exception Lexer_cbn.Error msg ->
      Printf.printf "\nLexing Error\n" ;
      print_endline msg;
      loop_stdin env t_e
    | exception Parsing.Parse_error ->
      Printf.printf "\nParse Error "; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env t_e
  
  in loop_stdin [] []


let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
    
  let rec loop_file (env : env) (t_e : ty_env) = 
    match Parser_cbn.command Lexer_cbn.token lexbuf with 
    | r -> 
      (match Eval_cbn.print_command_value env r t_e with
      | (env', t_e') -> loop_file env' t_e'
      | exception Error s -> print_endline s; print_newline()
      )
    | exception Lexer_cbn.Error msg -> Printf.printf "\nLexing Error\n"; print_endline msg;
    | exception Parsing.Parse_error 
      ->  Printf.printf "\nParse Error "; 
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