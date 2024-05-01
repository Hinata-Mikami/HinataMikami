(*変更なし*)
open Syntax

let string_of_position : Lexing.position -> string = fun pos -> 
  Printf.sprintf "[%s] L: %d, C: %d\n" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)
  
(*標準入力読み取り*)
let repl () =
  let lexbuf = Lexing.from_channel stdin in
  let rec loop_stdin env =
    try 
      let () = print_string "> " in 
      let () = flush stdout in
      let result = Parser.command Lexer.token lexbuf in

      loop_stdin (Eval.print_command_result env result)

    with
    | Lexer.Error msg ->
      Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
      print_endline msg 
  
    | Parsing.Parse_error ->
      Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf)
    in loop_stdin [];;

(*ファイル評価*)
let read_file filename =
    let op_file = open_in filename in
    let lexbuf = Lexing.from_channel op_file in

    let rec loop_file env = 
      try   
        let result = Parser.command Lexer.token lexbuf in

        loop_file (Eval.print_command_result env result)
    with
      | End_of_file -> Printf.printf "End of File"; close_in op_file
      | Lexer.Error msg ->
          Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
          print_endline msg 
      | Parsing.Parse_error ->
          Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
          Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf) 

  in loop_file []


let eval_input () =
  (* コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    read_file file
  (*そうでないときは標準入力を評価read_eval_point loop*)
  else repl()


let () = eval_input ()
