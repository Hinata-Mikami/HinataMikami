open Syntax

exception Eval_error
exception Zero_Division
exception Unexpected_Expression_at_binOp
exception Unexpected_Expression_at_eval_if
exception Variable_Not_Found

let rec print_value (v: value) : unit =
  match v with
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b)
  | VFun (x, e, env) -> print_string "<fun>"
  | VRFun (f, x, e, env) -> print_string "<fun>"
  | VCons (v, rest) -> 
    (match rest with
    | VNil -> print_value v; print_string " :: "; print_string "[]"
    | _ -> print_value v; print_string " :: ("; print_value rest; print_string ")" )
  | VNil -> print_string "[]"
  | VTuple vlist ->
      (*組を表示する関数*)
      let rec print_tuple (vl : value list) : unit =
      match vl with
        | [] -> print_char ')'
        | v :: rest -> print_string ", "; print_value v; print_tuple rest; in
      (match vlist with
        | [] -> raise Eval_error
        | v :: rest -> print_char '('; print_value v; print_tuple rest)
  | VRFunAnd (_, l, _) -> print_string "<fun>"


(*CLet (n, e) : let n = e;;*)
let command_let (env : env) (n : name) (e : expr) : (value * env) =
  match Eval.eval env e with
  | v1 -> (v1, ((n,v1) :: env))



let print_types_of_tuple (l : value list) : unit =
  match l with
  | [] -> ()
  | v :: rest ->
    let rec string_of_value_type (l' :value list) : unit =
      (match l' with
      | [] -> ()
      | v' :: rest' ->
        (match v' with
        | VInt _ -> print_string(" * int");(string_of_value_type rest')
        | VBool _ -> print_string(" * bool");(string_of_value_type rest')
        | _ -> print_string(" *  ");(string_of_value_type rest')
        )
      )
      in 
        (match v with
        | VInt _ -> print_string("int");(string_of_value_type rest)
        | VBool _ -> print_string("bool");(string_of_value_type rest)
        | _ -> print_string(" ");(string_of_value_type rest)
        )

  

(*対話型シェル：実行＋新たな環境envを返す関数*)
(*main.mlの再帰部分の引数に*)
(*env -> command -> env*)
let print_command_result (env : env) (cmd : command) : env =
  match cmd with
  | CExp expr -> 
    (match Eval.eval env expr with
     | v -> print_string (" ― : "); 
     (match v with
     | VInt _ -> print_string ("int = "); print_value v; print_newline()
     | VBool _ -> print_string ("bool = "); print_value v; print_newline()
     | VCons _ -> print_string ("list = "); print_value v; print_newline()
     | VNil -> print_string ("list = "); print_value v; print_newline()
     | VTuple l -> print_types_of_tuple l; print_string (" = "); print_value v; print_newline()
     | _ -> print_value v; print_newline()
     );
     env)
  | CLet (n, e) -> 
    print_string ("val "); print_string n; print_string (" = "); 
    let (v,e') = command_let env n e in print_value v; print_newline();
    e'
  (* (f, x, e) list*)
  | CRLetAnd l ->
      (*リストから環境を作成*)
      let rec and_env (i: int) (l1: (name * name * expr) list) : env =
      match l1 with
        | [] -> env
        | (f, x, e) :: rest -> (f, VRFunAnd(i, l, env)) :: (and_env (i + 1) rest) in
      let nenv = and_env 0 l in
      (*コマンドラインに変数を表示*)
      let rec printfun (l2 : (name * name * expr) list) : unit =
        match l2 with
        | [] -> ()
        | (f, x, e) :: rest ->
            print_endline (f ^ " = <fun>"); printfun rest;
        in printfun l;
      nenv


let repl () =

  let lexbuf = Lexing.from_channel stdin in
  (*ループ部分*)
  let rec loop_stdin env =
  
  let () = print_string "# " in
  let () = flush stdout in
  
  match Parser.command Lexer.token lexbuf with
  | r -> 
    (match print_command_result env r with
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
      Printf.printf "Parse Error "; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env
  
  in loop_stdin []


let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
    
  (*ループ部分*)
  let rec loop_file env= 
  match Parser.command Lexer.token lexbuf with 
  (*入力コマンドを実行し結果などをプリント->新たな環境を受け取る*)
  | r -> 
    (match print_command_result env r with
      | env' -> loop_file env'
      | exception Eval_error -> Printf.printf "exception: Eval_error\n";
      | exception Zero_Division -> Printf.printf "exception: Zero_Division\n";
      | exception Unexpected_Expression_at_binOp 
        -> Printf.printf "exception: Unexpected_Expression_at_binOp\n";
      | exception Unexpected_Expression_at_eval_if
        -> Printf.printf "exception: Unexpected_Expression_at_eval_if\n"; 
      | exception Variable_Not_Found -> Printf.printf "exception: Variable_Not_Found\n"; 
    )
  | exception Lexer.Error msg -> Printf.printf "Lexing Error\n"; print_endline msg;
  | exception Parsing.Parse_error 
    ->  Printf.printf "Parse Error "; 
        Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf);
  
  in loop_file []
  