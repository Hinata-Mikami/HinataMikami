type token =
  | INT of (
# 6 "parser.mly"
        int
# 6 "parser.ml"
)
  | ID of (
# 7 "parser.mly"
        string
# 11 "parser.ml"
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

open Parsing
let _ = parse_error;;
# 2 "parser.mly"
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 36 "parser.ml"
let yytransl_const = [|
  259 (* TRUE *);
  260 (* FALSE *);
  261 (* LET *);
  262 (* IN *);
  263 (* EQ *);
  264 (* IF *);
  265 (* THEN *);
  266 (* ELSE *);
  267 (* ADD *);
  268 (* SUB *);
  269 (* MUL *);
  270 (* DIV *);
  271 (* LT *);
  272 (* LPAR *);
  273 (* RPAR *);
  274 (* DSC *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* ID *);
    0|]

let yylhs = "\255\255\
\003\000\003\000\001\000\002\000\002\000\002\000\002\000\002\000\
\005\000\005\000\005\000\006\000\006\000\006\000\007\000\007\000\
\008\000\008\000\008\000\004\000\000\000\000\000\000\000"

let yylen = "\002\000\
\005\000\002\000\002\000\001\000\003\000\006\000\006\000\001\000\
\003\000\003\000\001\000\003\000\003\000\001\000\001\000\003\000\
\001\000\001\000\001\000\001\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\017\000\008\000\018\000\019\000\
\000\000\000\000\000\000\021\000\000\000\000\000\000\000\014\000\
\015\000\022\000\000\000\000\000\023\000\020\000\000\000\000\000\
\000\000\003\000\000\000\000\000\000\000\000\000\000\000\000\000\
\002\000\000\000\000\000\016\000\000\000\000\000\000\000\012\000\
\013\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\
\007\000\006\000"

let yydgoto = "\004\000\
\012\000\013\000\021\000\023\000\014\000\015\000\016\000\017\000"

let yysindex = "\007\000\
\014\255\014\255\024\255\000\000\000\000\000\000\000\000\000\000\
\000\255\014\255\014\255\000\000\020\000\248\254\010\255\000\000\
\000\000\000\000\000\255\017\255\000\000\000\000\039\255\042\255\
\035\255\000\000\038\255\038\255\038\255\038\255\038\255\046\255\
\000\000\014\255\014\255\000\000\010\255\010\255\022\255\000\000\
\000\000\014\255\049\255\047\255\250\254\014\255\014\255\000\000\
\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\031\000\001\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\011\000\021\000\036\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000"

let yygindex = "\000\000\
\000\000\003\000\000\000\037\000\029\000\016\000\017\000\000\000"

let yytablesize = 310
let yytable = "\046\000\
\011\000\022\000\027\000\028\000\018\000\020\000\029\000\001\000\
\002\000\003\000\009\000\048\000\024\000\025\000\005\000\006\000\
\007\000\008\000\009\000\026\000\010\000\010\000\030\000\031\000\
\005\000\006\000\007\000\008\000\019\000\011\000\004\000\010\000\
\027\000\028\000\033\000\005\000\043\000\044\000\005\000\011\000\
\007\000\008\000\037\000\038\000\045\000\034\000\040\000\041\000\
\049\000\050\000\035\000\036\000\042\000\011\000\046\000\032\000\
\047\000\039\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\011\000\000\000\
\000\000\011\000\011\000\011\000\011\000\000\000\000\000\011\000\
\009\000\011\000\011\000\009\000\009\000\009\000\009\000\000\000\
\000\000\009\000\010\000\009\000\009\000\010\000\010\000\010\000\
\010\000\000\000\000\000\010\000\004\000\010\000\010\000\004\000\
\004\000\005\000\000\000\000\000\005\000\005\000\000\000\004\000\
\004\000\000\000\000\000\000\000\005\000\005\000"

let yycheck = "\006\001\
\000\000\002\001\011\001\012\001\002\000\003\000\015\001\001\000\
\002\000\003\000\000\000\018\001\010\000\011\000\001\001\002\001\
\003\001\004\001\005\001\000\000\000\000\008\001\013\001\014\001\
\001\001\002\001\003\001\004\001\005\001\016\001\000\000\008\001\
\011\001\012\001\018\001\000\000\034\000\035\000\001\001\016\001\
\003\001\004\001\027\000\028\000\042\000\007\001\030\000\031\000\
\046\000\047\000\009\001\017\001\007\001\016\001\006\001\019\000\
\010\001\029\000\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\006\001\255\255\
\255\255\009\001\010\001\011\001\012\001\255\255\255\255\015\001\
\006\001\017\001\018\001\009\001\010\001\011\001\012\001\255\255\
\255\255\015\001\006\001\017\001\018\001\009\001\010\001\011\001\
\012\001\255\255\255\255\015\001\006\001\017\001\018\001\009\001\
\010\001\006\001\255\255\255\255\009\001\010\001\255\255\017\001\
\018\001\255\255\255\255\255\255\017\001\018\001"

let yynames_const = "\
  TRUE\000\
  FALSE\000\
  LET\000\
  IN\000\
  EQ\000\
  IF\000\
  THEN\000\
  ELSE\000\
  ADD\000\
  SUB\000\
  MUL\000\
  DIV\000\
  LT\000\
  LPAR\000\
  RPAR\000\
  DSC\000\
  EOF\000\
  "

let yynames_block = "\
  INT\000\
  ID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 33 "parser.mly"
                         ( CLet(_2,_4) )
# 221 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 34 "parser.mly"
                         ( CExp _1 )
# 228 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 38 "parser.mly"
         (_1)
# 235 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 42 "parser.mly"
               ( _1 )
# 242 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 43 "parser.mly"
                             ( EBin(OpLt, _1, _3) )
# 250 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 44 "parser.mly"
                                ( EIf(_2,_4,_6) )
# 259 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 45 "parser.mly"
                            ( ELet(_2, _4, _6) )
# 268 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 46 "parser.mly"
       ( EVar _1 )
# 275 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 51 "parser.mly"
                             ( EBin(OpAdd, _1, _3) )
# 283 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 52 "parser.mly"
                             ( EBin(OpSub, _1, _3) )
# 291 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 53 "parser.mly"
              ( _1 )
# 298 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 58 "parser.mly"
                              ( EBin(OpMul, _1, _3) )
# 306 "parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 59 "parser.mly"
                              ( EBin(OpDiv, _1, _3) )
# 314 "parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 60 "parser.mly"
                ( _1 )
# 321 "parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 64 "parser.mly"
            ( ELiteral _1 )
# 328 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 65 "parser.mly"
                   ( _2 )
# 335 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 69 "parser.mly"
          ( LInt _1 )
# 342 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 70 "parser.mly"
          ( LBool true )
# 348 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "parser.mly"
          ( LBool false )
# 354 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 75 "parser.mly"
        ( _1 )
# 361 "parser.ml"
               : 'var))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry expr *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry command *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Syntax.expr)
let expr (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : Syntax.expr)
let command (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 3 lexfun lexbuf : Syntax.command)