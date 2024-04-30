open Syntax

let string_of_position : Lexing.position -> string = fun pos -> 
  Printf.sprintf "[%s] L: %d, C: %d\n" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)
  
let repl () =

  let lexbuf = Lexing.from_channel stdin in

  let rec loop env =
    try 
      let () = print_string "> " in 
      let () = flush stdout in
      let result = Parser.command Lexer.token lexbuf in

      match result with
      (*CExp*)
      | CExp expr -> 
        (match Eval.eval env expr with
         | (v,e) -> print_string (" ― : "); 
         (match v with
         | VInt i -> print_string ("int = "); print_value v; print_newline()
         | VBool b -> print_string ("bool = "); print_value v; print_newline()
         );
         loop env)
      (*CLet: let n = e;;*)
      | CLet (n, e) -> 
        print_string ("val "); print_string n; print_string (" = "); 
          let (v,e1) = Eval.command_let env n e in print_value v; print_newline(); loop e1

    with
    | Lexer.Error msg ->
      Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
      print_endline msg 
  
    | Parsing.Parse_error ->
      Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf)
  
    in loop [];;


let read_file filename =
  let op_file = open_in filename in
  let lexbuf = Lexing.from_channel op_file in
    let rec loop env = 
    try   
        let result = Parser.command Lexer.token lexbuf in
  (*      Eval.eval_and_print_expr [] result; print_newline ();*)
    match result with
    (*CExp*)
    | CExp expr -> 
      (match Eval.eval env expr with
      | (v,e) -> print_string (" ― : "); 
      (match v with
      | VInt i -> print_string ("int = "); print_value v; print_newline()
      | VBool b -> print_string ("bool = "); print_value v; print_newline()
      );
      loop env)
    (*CLet: let n = e;;*)
    | CLet (n, e) -> 
      print_string ("val "); print_string n; print_string (" = "); 
        let (v,e1) = Eval.command_let env n e in print_value v; print_newline(); loop e1
  with
    | End_of_file -> close_in op_file
    | Lexer.Error msg ->
        Printf.printf "Lexing Errorat at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf);
        print_endline msg 
    | Parsing.Parse_error ->
        Printf.printf "Parse Error at %s" (string_of_position @@ Lexing.lexeme_start_p lexbuf); 
        Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf) 

in loop []

let eval_input () =
  (* コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    read_file file
  else repl()

let () = eval_input ()
