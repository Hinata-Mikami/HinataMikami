type token =
  | INT of (
# 6 "src/parser.mly"
        int
# 6 "src/parser.ml"
)
  | ID of (
# 7 "src/parser.mly"
        string
# 11 "src/parser.ml"
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

open Parsing
let _ = parse_error;;
# 2 "src/parser.mly"
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 38 "src/parser.ml"
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
  275 (* FUN *);
  276 (* ARROW *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* ID *);
    0|]

let yylhs = "\255\255\
\003\000\003\000\001\000\002\000\002\000\002\000\002\000\002\000\
\002\000\005\000\005\000\005\000\005\000\006\000\006\000\007\000\
\007\000\007\000\008\000\008\000\008\000\009\000\009\000\009\000\
\004\000\000\000\000\000\000\000"

let yylen = "\002\000\
\005\000\002\000\002\000\004\000\001\000\003\000\003\000\006\000\
\006\000\003\000\003\000\001\000\001\000\002\000\001\000\003\000\
\003\000\001\000\001\000\001\000\003\000\001\000\001\000\001\000\
\001\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\022\000\020\000\023\000\024\000\
\000\000\000\000\000\000\000\000\026\000\000\000\000\000\000\000\
\000\000\000\000\019\000\027\000\000\000\000\000\028\000\025\000\
\000\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\
\000\000\014\000\000\000\000\000\000\000\002\000\000\000\000\000\
\021\000\000\000\000\000\015\000\000\000\018\000\000\000\000\000\
\016\000\017\000\000\000\000\000\000\000\004\000\000\000\000\000\
\000\000\001\000\009\000\008\000"

let yydgoto = "\004\000\
\013\000\014\000\023\000\025\000\015\000\016\000\017\000\018\000\
\019\000"

let yysindex = "\036\000\
\073\255\073\255\082\255\000\000\000\000\000\000\000\000\000\000\
\254\254\073\255\073\255\002\255\000\000\006\000\021\255\008\255\
\028\255\000\000\000\000\000\000\254\254\003\255\000\000\000\000\
\019\255\020\255\014\255\023\255\000\000\008\255\008\255\008\255\
\008\255\000\000\008\255\008\255\027\255\000\000\073\255\073\255\
\000\000\073\255\008\255\000\000\028\255\000\000\028\255\008\255\
\000\000\000\000\073\255\040\255\041\255\000\000\007\255\073\255\
\073\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\063\000\014\000\
\027\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\068\000\000\000\040\000\000\000\053\000\073\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\005\000\000\000\029\000\000\000\228\255\017\000\243\255\
\000\000"

let yytablesize = 347
let yytable = "\024\000\
\015\000\043\000\034\000\028\000\048\000\029\000\020\000\022\000\
\005\000\006\000\007\000\008\000\056\000\013\000\026\000\027\000\
\044\000\046\000\046\000\044\000\038\000\049\000\050\000\011\000\
\058\000\039\000\012\000\030\000\040\000\034\000\041\000\031\000\
\032\000\051\000\034\000\033\000\001\000\002\000\003\000\010\000\
\035\000\036\000\042\000\052\000\053\000\056\000\054\000\045\000\
\047\000\037\000\057\000\000\000\011\000\000\000\000\000\055\000\
\000\000\000\000\000\000\000\000\059\000\060\000\005\000\000\000\
\000\000\000\000\000\000\006\000\000\000\000\000\000\000\000\000\
\007\000\005\000\006\000\007\000\008\000\009\000\000\000\000\000\
\010\000\000\000\005\000\006\000\007\000\008\000\021\000\000\000\
\011\000\010\000\000\000\012\000\000\000\000\000\000\000\000\000\
\000\000\011\000\000\000\000\000\012\000\000\000\000\000\000\000\
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
\000\000\015\000\015\000\015\000\015\000\000\000\015\000\015\000\
\000\000\015\000\015\000\015\000\015\000\018\000\018\000\015\000\
\015\000\015\000\015\000\013\000\013\000\000\000\013\000\013\000\
\013\000\013\000\000\000\000\000\013\000\000\000\013\000\013\000\
\012\000\012\000\000\000\012\000\012\000\012\000\012\000\000\000\
\000\000\012\000\000\000\012\000\012\000\010\000\010\000\000\000\
\010\000\010\000\010\000\010\000\000\000\000\000\010\000\000\000\
\010\000\010\000\011\000\011\000\000\000\011\000\011\000\011\000\
\011\000\000\000\000\000\011\000\005\000\011\000\011\000\005\000\
\005\000\006\000\000\000\000\000\006\000\006\000\007\000\005\000\
\005\000\007\000\007\000\000\000\006\000\006\000\000\000\000\000\
\000\000\007\000\007\000"

let yycheck = "\002\001\
\000\000\030\000\016\000\002\001\033\000\000\000\002\000\003\000\
\001\001\002\001\003\001\004\001\006\001\000\000\010\000\011\000\
\030\000\031\000\032\000\033\000\018\001\035\000\036\000\016\001\
\018\001\007\001\000\000\007\001\009\001\043\000\017\001\011\001\
\012\001\007\001\048\000\015\001\001\000\002\000\003\000\000\000\
\013\001\014\001\020\001\039\000\040\000\006\001\042\000\031\000\
\032\000\021\000\010\001\255\255\000\000\255\255\255\255\051\000\
\255\255\255\255\255\255\255\255\056\000\057\000\000\000\255\255\
\255\255\255\255\255\255\000\000\255\255\255\255\255\255\255\255\
\000\000\001\001\002\001\003\001\004\001\005\001\255\255\255\255\
\008\001\255\255\001\001\002\001\003\001\004\001\005\001\255\255\
\016\001\008\001\255\255\019\001\255\255\255\255\255\255\255\255\
\255\255\016\001\255\255\255\255\019\001\255\255\255\255\255\255\
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
\255\255\001\001\002\001\003\001\004\001\255\255\006\001\007\001\
\255\255\009\001\010\001\011\001\012\001\013\001\014\001\015\001\
\016\001\017\001\018\001\006\001\007\001\255\255\009\001\010\001\
\011\001\012\001\255\255\255\255\015\001\255\255\017\001\018\001\
\006\001\007\001\255\255\009\001\010\001\011\001\012\001\255\255\
\255\255\015\001\255\255\017\001\018\001\006\001\007\001\255\255\
\009\001\010\001\011\001\012\001\255\255\255\255\015\001\255\255\
\017\001\018\001\006\001\007\001\255\255\009\001\010\001\011\001\
\012\001\255\255\255\255\015\001\006\001\017\001\018\001\009\001\
\010\001\006\001\255\255\255\255\009\001\010\001\006\001\017\001\
\018\001\009\001\010\001\255\255\017\001\018\001\255\255\255\255\
\255\255\017\001\018\001"

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
  FUN\000\
  ARROW\000\
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
# 39 "src/parser.mly"
                         ( CLet(_2,_4) )
# 244 "src/parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 40 "src/parser.mly"
                         ( CExp _1 )
# 251 "src/parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 44 "src/parser.mly"
         (_1)
# 258 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 48 "src/parser.mly"
                      ( EFun(_2,_4) )
# 266 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 49 "src/parser.mly"
               ( _1 )
# 273 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 50 "src/parser.mly"
                           ( EBin(OpEq, _1, _3) )
# 281 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 51 "src/parser.mly"
                           ( EBin(OpLt, _1, _3) )
# 289 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 52 "src/parser.mly"
                                ( EIf(_2,_4,_6) )
# 298 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 53 "src/parser.mly"
                            ( ELet(_2, _4, _6) )
# 307 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 59 "src/parser.mly"
                             ( EBin(OpAdd, _1, _3) )
# 315 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 60 "src/parser.mly"
                             ( EBin(OpSub, _1, _3) )
# 323 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 61 "src/parser.mly"
              ( _1 )
# 330 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 62 "src/parser.mly"
             ( _1 )
# 337 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 66 "src/parser.mly"
                         ( EApp(_1,_2) )
# 345 "src/parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 67 "src/parser.mly"
                ( _1 )
# 352 "src/parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 71 "src/parser.mly"
                              ( EBin(OpMul, _1, _3) )
# 360 "src/parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 72 "src/parser.mly"
                              ( EBin(OpDiv, _1, _3) )
# 368 "src/parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 73 "src/parser.mly"
                ( _1 )
# 375 "src/parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 77 "src/parser.mly"
            ( ELiteral _1 )
# 382 "src/parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 78 "src/parser.mly"
                   ( EVar(_1) )
# 389 "src/parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 79 "src/parser.mly"
                   ( _2 )
# 396 "src/parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 83 "src/parser.mly"
          ( LInt _1 )
# 403 "src/parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 84 "src/parser.mly"
          ( LBool true )
# 409 "src/parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 85 "src/parser.mly"
          ( LBool false )
# 415 "src/parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 89 "src/parser.mly"
        ( _1 )
# 422 "src/parser.ml"
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
