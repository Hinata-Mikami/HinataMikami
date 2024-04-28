open Syntax

let string_of_position : Lexing.position -> string = fun pos -> 
  Printf.sprintf "[%s] L: %d, C: %d\n" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)
  
let rec repl () =

  let () = print_string "> " in 
  let () = flush stdout in
  let input = read_line () in
  let lexbuf = Lexing.from_string input in

  try
    let expr = Parser.main Lexer.token lexbuf in
    print_value (Eval.eval [] expr); print_newline ();
    repl ()

  with
  | Lexer.Error msg ->
    Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
    print_endline msg 

  | Parsing.Parse_error ->
    Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
    Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf) 

let read_file filename =
  let op_file = open_in filename in
  try
    while true do
      let input = input_line op_file in     
      let lexbuf = Lexing.from_string input in
    try
      let expr = Parser.main Lexer.token lexbuf in
        print_value (Eval.eval [] expr); print_newline ();
    with
    | Lexer.Error msg ->
        Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p   lexbuf);
        print_endline msg 
    | Parsing.Parse_error ->
        Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
        Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf) 
    done;
  with
  | End_of_file -> close_in op_file

let eval_input () =
  (* コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    read_file file
  else repl()

let () = eval_input ()
