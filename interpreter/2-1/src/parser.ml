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

open Parsing
let _ = parse_error;;
# 2 "parser.mly"
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 38 "parser.ml"
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
\003\000\003\000\001\000\002\000\002\000\002\000\002\000\005\000\
\005\000\005\000\005\000\005\000\005\000\005\000\006\000\006\000\
\007\000\007\000\007\000\008\000\008\000\008\000\004\000\000\000\
\000\000\000\000"

let yylen = "\002\000\
\005\000\002\000\002\000\004\000\001\000\006\000\006\000\003\000\
\003\000\003\000\003\000\003\000\003\000\001\000\002\000\001\000\
\001\000\001\000\003\000\001\000\001\000\001\000\001\000\002\000\
\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\020\000\018\000\021\000\022\000\
\000\000\000\000\000\000\000\000\024\000\000\000\000\000\000\000\
\016\000\017\000\025\000\000\000\000\000\026\000\023\000\000\000\
\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\
\000\000\000\000\015\000\000\000\002\000\000\000\000\000\019\000\
\000\000\000\000\000\000\000\000\010\000\011\000\000\000\000\000\
\000\000\000\000\004\000\000\000\000\000\000\000\001\000\007\000\
\006\000"

let yydgoto = "\004\000\
\013\000\014\000\022\000\024\000\015\000\016\000\017\000\018\000"

let yysindex = "\071\000\
\002\255\002\255\027\255\000\000\000\000\000\000\000\000\000\000\
\000\255\002\255\002\255\009\255\000\000\013\000\050\255\021\255\
\000\000\000\000\000\000\000\255\253\254\000\000\000\000\019\255\
\024\255\017\255\016\255\000\000\021\255\021\255\021\255\021\255\
\021\255\021\255\000\000\031\255\000\000\002\255\002\255\000\000\
\002\255\037\255\006\255\006\255\000\000\000\000\037\255\002\255\
\033\255\032\255\000\000\250\254\002\255\002\255\000\000\000\000\
\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\055\000\001\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\040\000\014\000\027\000\000\000\000\000\053\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000"

let yygindex = "\000\000\
\000\000\006\000\000\000\021\000\037\000\000\000\036\000\000\000"

let yytablesize = 329
let yytable = "\053\000\
\014\000\023\000\005\000\006\000\007\000\008\000\009\000\019\000\
\021\000\010\000\027\000\055\000\028\000\008\000\037\000\025\000\
\026\000\011\000\032\000\033\000\012\000\005\000\006\000\007\000\
\008\000\038\000\009\000\005\000\006\000\007\000\008\000\020\000\
\039\000\040\000\010\000\041\000\011\000\048\000\053\000\012\000\
\036\000\054\000\011\000\049\000\050\000\012\000\051\000\030\000\
\031\000\032\000\033\000\035\000\013\000\052\000\005\000\000\000\
\029\000\000\000\056\000\057\000\030\000\031\000\032\000\033\000\
\034\000\042\000\043\000\044\000\045\000\046\000\047\000\001\000\
\002\000\003\000\000\000\000\000\000\000\000\000\000\000\000\000\
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
\000\000\000\000\000\000\000\000\000\000\000\000\014\000\014\000\
\000\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
\000\000\014\000\014\000\008\000\008\000\000\000\008\000\008\000\
\008\000\008\000\000\000\000\000\008\000\000\000\008\000\008\000\
\009\000\009\000\000\000\009\000\009\000\009\000\009\000\000\000\
\000\000\009\000\000\000\009\000\009\000\012\000\012\000\000\000\
\012\000\012\000\000\000\000\000\000\000\000\000\012\000\000\000\
\012\000\012\000\013\000\013\000\005\000\013\000\013\000\005\000\
\005\000\000\000\000\000\013\000\000\000\013\000\013\000\005\000\
\005\000"

let yycheck = "\006\001\
\000\000\002\001\001\001\002\001\003\001\004\001\005\001\002\000\
\003\000\008\001\002\001\018\001\000\000\000\000\018\001\010\000\
\011\000\016\001\013\001\014\001\019\001\001\001\002\001\003\001\
\004\001\007\001\000\000\001\001\002\001\003\001\004\001\005\001\
\009\001\017\001\008\001\020\001\016\001\007\001\006\001\000\000\
\020\000\010\001\016\001\038\000\039\000\019\001\041\000\011\001\
\012\001\013\001\014\001\016\000\000\000\048\000\000\000\255\255\
\007\001\255\255\053\000\054\000\011\001\012\001\013\001\014\001\
\015\001\029\000\030\000\031\000\032\000\033\000\034\000\001\000\
\002\000\003\000\255\255\255\255\255\255\255\255\255\255\255\255\
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
# 38 "parser.mly"
                         ( CLet(_2,_4) )
# 238 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 39 "parser.mly"
                         ( CExp _1 )
# 245 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 43 "parser.mly"
             (_1)
# 252 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 47 "parser.mly"
                                ( EFun(_2,_4) )
# 260 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 48 "parser.mly"
                                ( _1 )
# 267 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 49 "parser.mly"
                                ( EIf(_2,_4,_6) )
# 276 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 50 "parser.mly"
                                ( ELet(_2, _4, _6) )
# 285 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 55 "parser.mly"
                                 ( EBin(OpAdd,_1,_3) )
# 293 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 56 "parser.mly"
                                 ( EBin(OpSub,_1,_3) )
# 301 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 57 "parser.mly"
                                 ( EBin(OpMul,_1,_3) )
# 309 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 58 "parser.mly"
                                 ( EBin(OpDiv,_1,_3) )
# 317 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 59 "parser.mly"
                                 ( EBin(OpEq,_1,_3) )
# 325 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 60 "parser.mly"
                                 ( EBin(OpLt,_1,_3) )
# 333 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 61 "parser.mly"
                                 ( _1 )
# 340 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 66 "parser.mly"
                         ( EApp(_1,_2) )
# 348 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 67 "parser.mly"
                         ( _1 )
# 355 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 71 "parser.mly"
                    ( ELiteral _1 )
# 362 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 72 "parser.mly"
                    ( EVar(_1) )
# 369 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 73 "parser.mly"
                    ( _2 )
# 376 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 77 "parser.mly"
          ( LInt _1 )
# 383 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 78 "parser.mly"
          ( LBool true )
# 389 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 79 "parser.mly"
          ( LBool false )
# 395 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 83 "parser.mly"
        ( _1 )
# 402 "parser.ml"
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
