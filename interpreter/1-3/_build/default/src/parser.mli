
(* The type of tokens. *)

type token = 
  | TRUE
  | THEN
  | SUB
  | RPAR
  | MUL
  | LT
  | LPAR
  | INT of (int)
  | IF
  | ID of (string)
  | FALSE
  | EQ
  | EOF
  | ELSE
  | DIV
  | ADD

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.expr)

val expr: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.expr)
