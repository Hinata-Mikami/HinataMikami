type token =
  | INT of (
# 6 "src/parser.mly"
        int
# 6 "src/parser.mli"
)
  | ID of (
# 7 "src/parser.mly"
        string
# 11 "src/parser.mli"
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
  | EOF
  | FUN
  | ARROW

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.expr
val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.expr
val command :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.command
