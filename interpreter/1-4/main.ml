open Syntax

let string_of_position : Lexing.position -> string = fun pos -> 
  Printf.sprintf "[%s] L: %d, C: %d\n" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)
  
let repl () =

  let () = print_string "> " in 
  let () = flush stdout in
  let lexbuf = Lexing.from_channel stdin in

  let rec loop env =
    (try 
    let result = Parser.command Lexer.token lexbuf in
    let (_,result_env) = Eval.eval_command env result in 
    Eval.eval_and_print_command env result; print_newline (); 
    loop result_env
    with 
    | Lexer.Error msg ->
      Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
      print_endline msg 
  
    | Parsing.Parse_error ->
      Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf))
  
    in loop [];;


let read_file filename =
  let op_file = open_in filename in
  let lexbuf = Lexing.from_channel stdin in
  try   
      let result = Parser.main Lexer.token lexbuf in
      Eval.eval_and_print_expr [] result; print_newline ();
  with
    | Lexer.Error msg ->
        Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
        print_endline msg 
    | Parsing.Parse_error ->
        Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
        Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf) 

    | End_of_file -> close_in op_file

let eval_input () =
  (* コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    read_file file
  else repl()

let () = eval_input ()
