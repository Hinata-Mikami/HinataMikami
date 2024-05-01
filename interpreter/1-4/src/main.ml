open Syntax

let string_of_position : Lexing.position -> string = fun pos -> 
  Printf.sprintf "[%s] L: %d, C: %d\n" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)
  
(*標準入力読み取り*)
(*エラーで再帰が止まってほしくない*)
let repl () =
  let lexbuf = Lexing.from_channel stdin in
  (*ループ部分*)
  let rec loop_stdin env =
     (*もう少し内側に*)    
    let () = print_string "> " in
    let () = flush stdout in
 
    (* let result = Parser.command Lexer.token lexbuf in ここがエラーを吐く場所 *)
    
    match Parser.command Lexer.token lexbuf with
    | r -> loop_stdin (Eval.print_command_result env r) (*ここをmatch-with-exn*)
    | exception Lexer.Error msg ->
      Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
      print_endline msg;
      loop_stdin env
    | exception Parsing.Parse_error ->
      Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env

  in loop_stdin []

(*ファイル評価*)
(*cmdのリストを受け取ってから実行*)
let read_file filename =
    let op_file = open_in filename in
    let lexbuf = Lexing.from_channel op_file in
    (*ループ部分*)
    (*try withを再帰の外側に*)
    let rec loop_file env = 
      try   
        let result = Parser.command Lexer.token lexbuf in (*この中にwith…Some/None *)
        (*入力コマンドを実行し結果などをプリント->新たな環境を受け取る*)
        loop_file (Eval.print_command_result env result) (*tryの外にあるべき*)
    with
      | End_of_file -> Printf.printf "End of File"; close_in op_file
      | Lexer.Error msg ->
          Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
          print_endline msg (*close*)
      | Parsing.Parse_error ->
          Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
          Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf) (*close*)
  in loop_file []
(*ファイルの読み込みが終わった後Parse Errorが出てしまう問題の解消ができていない*)
(*end_of_streamをとっていない*)

(*メイン関数*)
let eval_input () =
  (*コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    read_file file
  (*そうでないときは標準入力を評価read_eval_point loop*)
  else repl()

(*随時実行*)
let () = eval_input ()
