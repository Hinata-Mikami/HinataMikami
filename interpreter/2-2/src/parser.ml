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
  | FUN
  | ARROW
  | REC

open Parsing
let _ = parse_error;;
# 2 "parser.mly"
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 39 "parser.ml"
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
  277 (* REC *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* ID *);
    0|]

let yylhs = "\255\255\
\003\000\003\000\001\000\002\000\002\000\002\000\002\000\002\000\
\002\000\006\000\006\000\005\000\005\000\005\000\005\000\005\000\
\005\000\005\000\007\000\007\000\008\000\008\000\008\000\009\000\
\009\000\009\000\004\000\000\000\000\000\000\000"

let yylen = "\002\000\
\005\000\002\000\002\000\004\000\001\000\006\000\006\000\006\000\
\007\000\002\000\002\000\003\000\003\000\003\000\003\000\003\000\
\003\000\001\000\002\000\001\000\001\000\001\000\003\000\001\000\
\001\000\001\000\001\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\024\000\022\000\025\000\026\000\
\000\000\000\000\000\000\000\000\028\000\000\000\000\000\000\000\
\020\000\021\000\029\000\000\000\000\000\030\000\027\000\000\000\
\000\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\
\000\000\000\000\000\000\019\000\000\000\002\000\000\000\000\000\
\000\000\023\000\000\000\000\000\000\000\000\000\014\000\015\000\
\000\000\000\000\000\000\000\000\000\000\004\000\000\000\000\000\
\000\000\000\000\000\000\000\000\001\000\022\000\000\000\010\000\
\008\000\011\000\000\000\007\000\006\000\009\000"

let yydgoto = "\004\000\
\013\000\064\000\022\000\057\000\015\000\058\000\016\000\017\000\
\018\000"

let yysindex = "\023\000\
\055\255\055\255\074\255\000\000\000\000\000\000\000\000\000\000\
\000\255\055\255\055\255\008\255\000\000\032\000\073\255\034\255\
\000\000\000\000\000\000\000\255\036\255\000\000\000\000\049\255\
\057\255\056\255\050\255\046\255\000\000\034\255\034\255\034\255\
\034\255\034\255\034\255\000\000\061\255\000\000\049\255\055\255\
\055\255\000\000\055\255\251\254\033\255\033\255\000\000\000\000\
\251\254\055\255\026\255\064\255\062\255\000\000\023\255\015\255\
\037\255\067\255\055\255\055\255\000\000\000\000\055\255\000\000\
\000\000\000\000\055\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\055\000\001\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\040\000\014\000\027\000\000\000\000\000\
\053\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\002\000\000\000\247\255\064\000\248\255\000\000\065\000\
\000\000"

let yytablesize = 329
let yytable = "\025\000\
\018\000\023\000\014\000\019\000\021\000\031\000\032\000\033\000\
\034\000\028\000\037\000\026\000\027\000\012\000\039\000\005\000\
\062\000\007\000\008\000\009\000\024\000\063\000\010\000\001\000\
\002\000\003\000\013\000\023\000\059\000\051\000\011\000\029\000\
\056\000\012\000\005\000\006\000\007\000\008\000\023\000\016\000\
\061\000\052\000\053\000\063\000\054\000\033\000\034\000\065\000\
\066\000\011\000\023\000\055\000\017\000\038\000\005\000\005\000\
\006\000\007\000\008\000\009\000\068\000\069\000\010\000\040\000\
\041\000\043\000\042\000\050\000\070\000\059\000\011\000\060\000\
\067\000\012\000\005\000\006\000\007\000\008\000\020\000\030\000\
\036\000\010\000\000\000\031\000\032\000\033\000\034\000\035\000\
\000\000\011\000\000\000\000\000\012\000\044\000\045\000\046\000\
\047\000\048\000\049\000\000\000\000\000\000\000\000\000\000\000\
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
\000\000\000\000\000\000\000\000\000\000\000\000\018\000\018\000\
\000\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
\000\000\018\000\018\000\012\000\012\000\000\000\012\000\012\000\
\012\000\012\000\000\000\000\000\012\000\000\000\012\000\012\000\
\013\000\013\000\000\000\013\000\013\000\013\000\013\000\000\000\
\000\000\013\000\000\000\013\000\013\000\016\000\016\000\000\000\
\016\000\016\000\000\000\000\000\000\000\000\000\016\000\000\000\
\016\000\016\000\017\000\017\000\005\000\017\000\017\000\005\000\
\005\000\000\000\000\000\017\000\000\000\017\000\017\000\005\000\
\005\000"

let yycheck = "\009\000\
\000\000\002\001\001\000\002\000\003\000\011\001\012\001\013\001\
\014\001\002\001\020\000\010\000\011\000\000\000\024\000\001\001\
\002\001\003\001\004\001\005\001\021\001\007\001\008\001\001\000\
\002\000\003\000\000\000\002\001\006\001\039\000\016\001\000\000\
\007\001\019\001\001\001\002\001\003\001\004\001\002\001\000\000\
\018\001\040\000\041\000\007\001\043\000\013\001\014\001\056\000\
\057\000\016\001\002\001\050\000\000\000\018\001\000\000\001\001\
\002\001\003\001\004\001\005\001\059\000\060\000\008\001\007\001\
\009\001\020\001\017\001\007\001\067\000\006\001\016\001\010\001\
\006\001\019\001\001\001\002\001\003\001\004\001\005\001\007\001\
\016\000\008\001\255\255\011\001\012\001\013\001\014\001\015\001\
\255\255\016\001\255\255\255\255\019\001\030\000\031\000\032\000\
\033\000\034\000\035\000\255\255\255\255\255\255\255\255\255\255\
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
\255\255\255\255\255\255\255\255\255\255\255\255\006\001\007\001\
\255\255\009\001\010\001\011\001\012\001\013\001\014\001\015\001\
\255\255\017\001\018\001\006\001\007\001\255\255\009\001\010\001\
\011\001\012\001\255\255\255\255\015\001\255\255\017\001\018\001\
\006\001\007\001\255\255\009\001\010\001\011\001\012\001\255\255\
\255\255\015\001\255\255\017\001\018\001\006\001\007\001\255\255\
\009\001\010\001\255\255\255\255\255\255\255\255\015\001\255\255\
\017\001\018\001\006\001\007\001\006\001\009\001\010\001\009\001\
\010\001\255\255\255\255\015\001\255\255\017\001\018\001\017\001\
\018\001"

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
  REC\000\
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
# 39 "parser.mly"
                         ( CLet(_2,_4) )
# 246 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 40 "parser.mly"
                         ( CExp _1 )
# 253 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 44 "parser.mly"
             (_1)
# 260 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 48 "parser.mly"
                                ( EFun(_2,_4) )
# 268 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 49 "parser.mly"
                                ( _1 )
# 275 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 50 "parser.mly"
                                ( EIf(_2,_4,_6) )
# 284 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 51 "parser.mly"
                                ( ELet(_2, _4, _6) )
# 293 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'rec_expr) in
    Obj.repr(
# 52 "parser.mly"
                                ( ERLet(_3, _4, _6) )
# 302 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'rec_expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 53 "parser.mly"
                                     (ERILet(_3,_4,_5,_7) )
# 312 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 58 "parser.mly"
            (_2)
# 319 "parser.ml"
               : 'rec_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'var) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'rec_expr) in
    Obj.repr(
# 59 "parser.mly"
                 ( EFun(_1, _2) )
# 327 "parser.ml"
               : 'rec_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 63 "parser.mly"
                                 ( EBin(OpAdd,_1,_3) )
# 335 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 64 "parser.mly"
                                 ( EBin(OpSub,_1,_3) )
# 343 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 65 "parser.mly"
                                 ( EBin(OpMul,_1,_3) )
# 351 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 66 "parser.mly"
                                 ( EBin(OpDiv,_1,_3) )
# 359 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 67 "parser.mly"
                                 ( EBin(OpEq,_1,_3) )
# 367 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 68 "parser.mly"
                                 ( EBin(OpLt,_1,_3) )
# 375 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 69 "parser.mly"
                                 ( _1 )
# 382 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 74 "parser.mly"
                         ( EApp(_1,_2) )
# 390 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 75 "parser.mly"
                         ( _1 )
# 397 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 79 "parser.mly"
                    ( ELiteral _1 )
# 404 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 80 "parser.mly"
                    ( EVar(_1) )
# 411 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 81 "parser.mly"
                    ( _2 )
# 418 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 85 "parser.mly"
          ( LInt _1 )
# 425 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "parser.mly"
          ( LBool true )
# 431 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 87 "parser.mly"
          ( LBool false )
# 437 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 91 "parser.mly"
        ( _1 )
# 444 "parser.ml"
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
