type token =
  | INT of (
# 6 "parser.mly"
        int
# 6 "parser.mli"
)
  | ID of (
# 7 "parser.mly"
        string
# 11 "parser.mli"
)
  | TRUE
  | FALSE
  | LET
  | IN
  | EQ
  | IF
  | THEN
  | ELSE
  | ADD
  | SUB
  | MUL
  | DIV
  | LT
  | LPAR
  | RPAR
  | DSC
  | SSC
  | EOF
  | FUN
  | ARROW
  | REC
  | MATCH
  | WITH
  | OR
  | COMMA
  | LBPAR
  | RBPAR
  | CONS
  | AND
  | WILD
  | END

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.expr
val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.expr
val command :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.command
val pattern :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.pattern
