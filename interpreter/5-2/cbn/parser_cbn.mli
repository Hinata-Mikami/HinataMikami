type token =
  | INT of (
# 6 "parser_cbn.mly"
        int
# 6 "parser_cbn.mli"
)
  | ID of (
# 7 "parser_cbn.mly"
        string
# 11 "parser_cbn.mli"
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
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax_cbn.expr
val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax_cbn.expr
val command :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax_cbn.command
val pattern :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax_cbn.pattern
