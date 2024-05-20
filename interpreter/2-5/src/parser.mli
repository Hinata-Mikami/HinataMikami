
(* The type of tokens. *)

type token = 
  | WITH
  | WILD
  | TRUE
  | THEN
  | SUB
  | SSC
  | RPAR
  | REC
  | RBPAR
  | OR
  | MUL
  | MATCH
  | LT
  | LPAR
  | LET
  | LBPAR
  | INT of (int)
  | IN
  | IF
  | ID of (string)
  | FUN
  | FALSE
  | EQ
  | EOF
  | END
  | ELSE
  | DSC
  | DIV
  | CONS
  | COMMA
  | ARROW
  | AND
  | ADD

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val pattern: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.pattern)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.expr)

val expr: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.expr)

val command: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.command)
