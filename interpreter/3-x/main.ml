exception Eval_error
exception Zero_Division
exception Unexpected_Expression_at_binOp
exception Unexpected_Expression_at_eval_if
exception Variable_Not_Found

(*標準入力読み取り*)
(*エラーで再帰が止まってほしくない*)
let repl () =

  let lexbuf = Lexing.from_channel stdin in
  (*ループ部分*)
  let rec loop_stdin env =

    let () = print_string "# " in
    let () = flush stdout in

    match Parser.command Lexer.token lexbuf with
    | r -> (match Eval.print_command_result env r with
            | env' -> loop_stdin env'
            | exception Eval_error -> Printf.printf "exception: Eval_error\n"; loop_stdin env
            | exception Zero_Division -> Printf.printf "exception: Zero_Division\n"; loop_stdin env
            | exception Unexpected_Expression_at_binOp 
                   -> Printf.printf "exception: Unexpected_Expression_at_binOp\n"; loop_stdin env 
            | exception Unexpected_Expression_at_eval_if
                   -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; loop_stdin env
            | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; loop_stdin env
            )

    | exception Lexer.Error msg ->
      Printf.printf "Lexing Error\n" ;
      print_endline msg;
      loop_stdin env
    | exception Parsing.Parse_error ->
      Printf.printf "Parse Error"; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env

  in loop_stdin []

(*ファイル評価*)
let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
  
    (*ループ部分*)
  let rec loop_file env= 
    match Parser.command Lexer.token lexbuf with 
    (*入力コマンドを実行し結果などをプリント->新たな環境を受け取る*)
    | r -> 
      (match Eval.print_command_result env r with
        | env' -> loop_file env'
        | exception Eval_error -> Printf.printf "exception: Eval_error\n";
        | exception Zero_Division -> Printf.printf "exception: Zero_Division\n";
        | exception Unexpected_Expression_at_binOp 
                -> Printf.printf "exception: Unexpected_Expression_at_binOp\n";
        | exception Unexpected_Expression_at_eval_if
                -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; 
        | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; 
      )
    | exception Lexer.Error msg ->
          Printf.printf "Lexing Error\n";
          print_endline msg;
    | exception Parsing.Parse_error ->
          Printf.printf "Parse Error"; 
          Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf);

    in loop_file []


(*メイン関数*)
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

