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

open Parsing
let _ = parse_error;;
# 2 "src/parser.mly"
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 36 "src/parser.ml"
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
\003\000\003\000\005\000\001\000\002\000\002\000\002\000\002\000\
\002\000\002\000\006\000\006\000\006\000\007\000\007\000\007\000\
\008\000\008\000\009\000\009\000\009\000\004\000\000\000\000\000\
\000\000"

let yylen = "\002\000\
\005\000\002\000\001\000\002\000\001\000\003\000\003\000\006\000\
\006\000\001\000\003\000\003\000\001\000\003\000\003\000\001\000\
\001\000\003\000\001\000\001\000\001\000\001\000\002\000\002\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\019\000\010\000\020\000\021\000\
\000\000\000\000\000\000\023\000\000\000\000\000\000\000\016\000\
\017\000\024\000\000\000\000\000\025\000\022\000\000\000\000\000\
\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\003\000\002\000\000\000\000\000\018\000\000\000\000\000\
\000\000\000\000\014\000\015\000\000\000\000\000\000\000\000\000\
\000\000\000\000\001\000\009\000\008\000"

let yydgoto = "\004\000\
\012\000\013\000\021\000\023\000\035\000\014\000\015\000\016\000\
\017\000"

let yysindex = "\038\000\
\003\255\003\255\020\255\000\000\000\000\000\000\000\000\000\000\
\010\255\003\255\003\255\000\000\029\000\019\255\032\255\000\000\
\000\000\000\000\010\255\015\255\000\000\000\000\028\255\029\255\
\036\255\000\000\255\254\255\254\255\254\255\254\255\254\255\254\
\051\255\000\000\000\000\003\255\003\255\000\000\037\255\032\255\
\032\255\037\255\000\000\000\000\003\255\053\255\050\255\014\255\
\003\255\003\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\037\000\001\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\042\000\014\000\
\027\000\047\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\007\000\000\000\043\000\013\000\242\255\022\000\023\000\
\000\000"

let yytablesize = 321
let yytable = "\005\000\
\013\000\007\000\008\000\005\000\006\000\007\000\008\000\009\000\
\018\000\020\000\010\000\022\000\039\000\011\000\011\000\042\000\
\024\000\025\000\011\000\049\000\005\000\006\000\007\000\008\000\
\019\000\027\000\012\000\010\000\026\000\028\000\029\000\034\000\
\034\000\030\000\036\000\011\000\005\000\037\000\001\000\002\000\
\003\000\007\000\046\000\047\000\031\000\032\000\006\000\028\000\
\029\000\040\000\041\000\048\000\038\000\043\000\044\000\052\000\
\053\000\045\000\049\000\050\000\051\000\033\000\000\000\000\000\
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
\000\000\000\000\000\000\000\000\000\000\000\000\013\000\013\000\
\000\000\013\000\013\000\013\000\013\000\000\000\000\000\013\000\
\000\000\013\000\013\000\011\000\011\000\000\000\011\000\011\000\
\011\000\011\000\000\000\000\000\011\000\000\000\011\000\011\000\
\012\000\012\000\000\000\012\000\012\000\012\000\012\000\000\000\
\000\000\012\000\005\000\012\000\012\000\005\000\005\000\007\000\
\000\000\000\000\007\000\007\000\006\000\005\000\005\000\006\000\
\006\000\000\000\007\000\007\000\000\000\000\000\000\000\006\000\
\006\000"

let yycheck = "\001\001\
\000\000\003\001\004\001\001\001\002\001\003\001\004\001\005\001\
\002\000\003\000\008\001\002\001\027\000\000\000\016\001\030\000\
\010\000\011\000\016\001\006\001\001\001\002\001\003\001\004\001\
\005\001\007\001\000\000\008\001\000\000\011\001\012\001\018\001\
\018\001\015\001\007\001\016\001\000\000\009\001\001\000\002\000\
\003\000\000\000\036\000\037\000\013\001\014\001\000\000\011\001\
\012\001\028\000\029\000\045\000\017\001\031\000\032\000\049\000\
\050\000\007\001\006\001\010\001\048\000\019\000\255\255\255\255\
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
\255\255\255\255\255\255\255\255\255\255\255\255\006\001\007\001\
\255\255\009\001\010\001\011\001\012\001\255\255\255\255\015\001\
\255\255\017\001\018\001\006\001\007\001\255\255\009\001\010\001\
\011\001\012\001\255\255\255\255\015\001\255\255\017\001\018\001\
\006\001\007\001\255\255\009\001\010\001\011\001\012\001\255\255\
\255\255\015\001\006\001\017\001\018\001\009\001\010\001\006\001\
\255\255\255\255\009\001\010\001\006\001\017\001\018\001\009\001\
\010\001\255\255\017\001\018\001\255\255\255\255\255\255\017\001\
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
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'command_end) in
    Obj.repr(
# 33 "src/parser.mly"
                                 ( CLet(_2,_4) )
# 230 "src/parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'command_end) in
    Obj.repr(
# 34 "src/parser.mly"
                                 ( CExp _1 )
# 238 "src/parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    Obj.repr(
# 38 "src/parser.mly"
         (  )
# 244 "src/parser.ml"
               : 'command_end))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 42 "src/parser.mly"
         (_1)
# 251 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 46 "src/parser.mly"
               ( _1 )
# 258 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 47 "src/parser.mly"
                             ( EBin(OpLt, _1, _3) )
# 266 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 48 "src/parser.mly"
                             ( EBin(OpEq, _1, _3) )
# 274 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 49 "src/parser.mly"
                                ( EIf(_2,_4,_6) )
# 283 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 50 "src/parser.mly"
                            ( ELet(_2, _4, _6) )
# 292 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 51 "src/parser.mly"
       ( EVar _1 )
# 299 "src/parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 56 "src/parser.mly"
                             ( EBin(OpAdd, _1, _3) )
# 307 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 57 "src/parser.mly"
                             ( EBin(OpSub, _1, _3) )
# 315 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term_expr) in
    Obj.repr(
# 58 "src/parser.mly"
              ( _1 )
# 322 "src/parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 63 "src/parser.mly"
                              ( EBin(OpMul, _1, _3) )
# 330 "src/parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 64 "src/parser.mly"
                              ( EBin(OpDiv, _1, _3) )
# 338 "src/parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 65 "src/parser.mly"
                ( _1 )
# 345 "src/parser.ml"
               : 'term_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 69 "src/parser.mly"
            ( ELiteral _1 )
# 352 "src/parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 70 "src/parser.mly"
                   ( _2 )
# 359 "src/parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 74 "src/parser.mly"
          ( LInt _1 )
# 366 "src/parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "src/parser.mly"
          ( LBool true )
# 372 "src/parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 76 "src/parser.mly"
          ( LBool false )
# 378 "src/parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 80 "src/parser.mly"
        ( _1 )
# 385 "src/parser.ml"
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
