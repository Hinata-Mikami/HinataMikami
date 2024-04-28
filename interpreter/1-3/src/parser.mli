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
  | IF
  | THEN
  | ELSE
  | ADD
  | SUB
  | MUL
  | DIV
  | EQ
  | LT
  | LPAR
  | RPAR
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.expr
val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.expr
