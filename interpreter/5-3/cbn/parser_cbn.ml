type token =
  | INT of (
# 6 "parser_cbn.mly"
        int
# 6 "parser_cbn.ml"
)
  | ID of (
# 7 "parser_cbn.mly"
        string
# 11 "parser_cbn.ml"
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

open Parsing
let _ = parse_error;;
# 2 "parser_cbn.mly"
  open Syntax_cbn
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 50 "parser_cbn.ml"
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
  275 (* SSC *);
    0 (* EOF *);
  276 (* FUN *);
  277 (* ARROW *);
  278 (* REC *);
  279 (* MATCH *);
  280 (* WITH *);
  281 (* OR *);
  282 (* COMMA *);
  283 (* LBPAR *);
  284 (* RBPAR *);
  285 (* CONS *);
  286 (* AND *);
  287 (* WILD *);
  288 (* END *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* ID *);
    0|]

let yylhs = "\255\255\
\003\000\003\000\003\000\006\000\006\000\001\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\008\000\008\000\007\000\
\007\000\007\000\007\000\007\000\007\000\007\000\010\000\010\000\
\009\000\009\000\009\000\012\000\012\000\004\000\004\000\004\000\
\004\000\004\000\004\000\004\000\004\000\013\000\013\000\011\000\
\011\000\011\000\011\000\011\000\011\000\015\000\015\000\016\000\
\016\000\014\000\014\000\014\000\005\000\000\000\000\000\000\000\
\000\000"

let yylen = "\002\000\
\005\000\007\000\002\000\006\000\001\000\002\000\004\000\001\000\
\006\000\006\000\008\000\004\000\003\000\006\000\001\000\003\000\
\003\000\003\000\003\000\003\000\003\000\001\000\002\000\001\000\
\001\000\004\000\004\000\005\000\005\000\001\000\001\000\001\000\
\001\000\005\000\002\000\003\000\001\000\003\000\001\000\001\000\
\001\000\003\000\005\000\002\000\003\000\003\000\001\000\003\000\
\001\000\001\000\001\000\001\000\001\000\002\000\002\000\002\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\050\000\041\000\051\000\
\052\000\000\000\000\000\000\000\000\000\000\000\000\000\054\000\
\000\000\000\000\000\000\024\000\040\000\000\000\000\000\000\000\
\056\000\030\000\033\000\031\000\032\000\000\000\000\000\037\000\
\000\000\053\000\000\000\000\000\000\000\000\000\000\000\000\000\
\044\000\000\000\006\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\023\000\000\000\000\000\003\000\000\000\035\000\
\000\000\000\000\000\000\000\000\042\000\000\000\000\000\000\000\
\000\000\049\000\045\000\000\000\000\000\000\000\000\000\018\000\
\019\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\025\000\000\000\012\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\047\000\000\000\043\000\
\000\000\048\000\000\000\001\000\039\000\000\000\034\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\015\000\000\000\
\000\000\046\000\000\000\027\000\026\000\005\000\000\000\002\000\
\038\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\029\000\028\000\000\000\014\000\
\004\000"

let yydgoto = "\005\000\
\016\000\017\000\025\000\033\000\036\000\120\000\018\000\113\000\
\086\000\019\000\020\000\117\000\103\000\021\000\096\000\067\000"

let yysindex = "\210\000\
\148\255\148\255\175\255\023\255\000\000\000\000\000\000\000\000\
\000\000\010\255\148\255\148\255\004\255\148\255\120\255\000\000\
\003\000\174\255\056\255\000\000\000\000\242\254\019\255\051\255\
\000\000\000\000\000\000\000\000\000\000\023\255\038\255\000\000\
\044\255\000\000\073\255\083\255\022\255\059\255\071\255\089\255\
\000\000\077\255\000\000\148\255\056\255\056\255\056\255\056\255\
\056\255\056\255\000\000\073\255\091\255\000\000\055\255\000\000\
\023\255\073\255\148\255\148\255\000\000\148\255\148\255\006\255\
\148\255\000\000\000\000\242\254\149\255\113\255\113\255\000\000\
\000\000\149\255\073\255\148\255\023\255\044\255\095\255\039\255\
\246\254\060\255\242\254\000\000\027\255\000\000\077\255\103\255\
\034\255\074\255\148\255\148\255\148\255\000\000\148\255\000\000\
\148\255\000\000\148\255\000\000\000\000\023\255\000\000\014\255\
\242\254\242\254\060\255\079\255\005\255\074\255\000\000\073\255\
\148\255\000\000\023\255\000\000\000\000\000\000\073\255\000\000\
\000\000\073\255\242\254\050\255\073\255\123\255\148\255\125\255\
\148\255\087\255\148\255\014\255\000\000\000\000\005\255\000\000\
\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\134\000\001\000\000\000\000\000\135\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\137\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\159\000\082\000\028\000\055\000\000\000\
\000\000\109\000\000\000\000\000\000\000\042\000\000\000\000\000\
\000\000\000\000\184\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\209\000\234\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\003\001\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000"

let yygindex = "\000\000\
\000\000\002\000\000\000\228\255\251\255\004\000\158\000\006\000\
\000\000\000\000\123\000\014\000\035\000\000\000\039\000\067\000"

let yytablesize = 547
let yytable = "\093\000\
\022\000\055\000\043\000\022\000\024\000\039\000\026\000\027\000\
\028\000\029\000\111\000\034\000\037\000\038\000\044\000\040\000\
\042\000\053\000\044\000\111\000\034\000\030\000\118\000\026\000\
\027\000\028\000\029\000\016\000\078\000\058\000\060\000\035\000\
\031\000\044\000\119\000\085\000\032\000\084\000\030\000\092\000\
\052\000\036\000\044\000\112\000\092\000\068\000\075\000\097\000\
\090\000\031\000\044\000\100\000\079\000\032\000\017\000\057\000\
\006\000\007\000\008\000\009\000\080\000\081\000\044\000\082\000\
\083\000\056\000\087\000\044\000\054\000\088\000\127\000\012\000\
\057\000\110\000\034\000\061\000\094\000\089\000\057\000\044\000\
\077\000\020\000\015\000\057\000\062\000\095\000\124\000\044\000\
\044\000\059\000\101\000\063\000\104\000\105\000\106\000\065\000\
\107\000\076\000\108\000\102\000\109\000\091\000\057\000\115\000\
\066\000\044\000\122\000\044\000\021\000\099\000\116\000\115\000\
\064\000\125\000\123\000\044\000\126\000\044\000\133\000\128\000\
\006\000\007\000\008\000\009\000\010\000\048\000\049\000\011\000\
\130\000\129\000\132\000\131\000\135\000\008\000\055\000\012\000\
\057\000\136\000\137\000\013\000\136\000\051\000\014\000\134\000\
\121\000\114\000\015\000\041\000\006\000\007\000\008\000\009\000\
\010\000\098\000\000\000\011\000\000\000\000\000\013\000\046\000\
\047\000\048\000\049\000\012\000\000\000\000\000\000\000\013\000\
\000\000\000\000\014\000\000\000\000\000\000\000\015\000\006\000\
\007\000\008\000\009\000\023\000\045\000\000\000\011\000\007\000\
\046\000\047\000\048\000\049\000\050\000\000\000\012\000\000\000\
\000\000\000\000\013\000\000\000\000\000\014\000\000\000\000\000\
\000\000\015\000\069\000\070\000\071\000\072\000\073\000\074\000\
\010\000\000\000\001\000\002\000\003\000\004\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\009\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\011\000\000\000\000\000\000\000\022\000\022\000\
\000\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
\000\000\022\000\022\000\022\000\000\000\000\000\000\000\000\000\
\022\000\022\000\022\000\000\000\022\000\022\000\022\000\044\000\
\022\000\016\000\016\000\000\000\016\000\016\000\016\000\016\000\
\000\000\000\000\016\000\000\000\016\000\016\000\016\000\000\000\
\000\000\000\000\000\000\016\000\016\000\016\000\000\000\016\000\
\016\000\016\000\036\000\016\000\017\000\017\000\036\000\017\000\
\017\000\017\000\017\000\036\000\000\000\017\000\000\000\017\000\
\017\000\017\000\000\000\000\000\000\000\000\000\017\000\017\000\
\017\000\000\000\017\000\017\000\017\000\000\000\017\000\020\000\
\020\000\000\000\020\000\020\000\000\000\000\000\000\000\000\000\
\020\000\000\000\020\000\020\000\020\000\000\000\000\000\000\000\
\000\000\020\000\020\000\020\000\000\000\020\000\020\000\020\000\
\000\000\020\000\021\000\021\000\000\000\021\000\021\000\000\000\
\000\000\000\000\000\000\021\000\000\000\021\000\021\000\021\000\
\000\000\000\000\000\000\000\000\021\000\021\000\021\000\000\000\
\021\000\021\000\021\000\008\000\021\000\000\000\008\000\008\000\
\000\000\000\000\000\000\000\000\000\000\000\000\008\000\008\000\
\008\000\000\000\000\000\000\000\000\000\008\000\008\000\008\000\
\000\000\008\000\008\000\008\000\013\000\008\000\000\000\013\000\
\013\000\000\000\000\000\000\000\000\000\000\000\000\000\013\000\
\013\000\013\000\000\000\000\000\000\000\000\000\013\000\013\000\
\013\000\000\000\013\000\000\000\013\000\007\000\013\000\000\000\
\007\000\007\000\000\000\000\000\000\000\000\000\000\000\000\000\
\007\000\007\000\007\000\000\000\000\000\000\000\000\000\007\000\
\007\000\007\000\000\000\007\000\000\000\007\000\010\000\007\000\
\000\000\010\000\010\000\000\000\000\000\000\000\000\000\000\000\
\000\000\010\000\010\000\010\000\000\000\000\000\000\000\000\000\
\010\000\010\000\010\000\000\000\010\000\000\000\010\000\009\000\
\010\000\000\000\009\000\009\000\000\000\000\000\000\000\000\000\
\000\000\000\000\009\000\009\000\009\000\000\000\000\000\000\000\
\000\000\009\000\009\000\009\000\000\000\009\000\000\000\009\000\
\011\000\009\000\000\000\011\000\011\000\000\000\000\000\000\000\
\000\000\000\000\000\000\011\000\011\000\011\000\000\000\000\000\
\000\000\000\000\011\000\011\000\011\000\000\000\011\000\000\000\
\011\000\000\000\011\000"

let yycheck = "\010\001\
\000\000\030\000\000\000\002\000\003\000\002\001\001\001\002\001\
\003\001\004\001\006\001\002\001\011\000\012\000\029\001\014\000\
\015\000\023\000\029\001\006\001\002\001\016\001\018\001\001\001\
\002\001\003\001\004\001\000\000\057\000\035\000\009\001\022\001\
\027\001\029\001\030\001\064\000\031\001\032\001\016\001\006\001\
\022\001\000\000\029\001\030\001\006\001\044\000\052\000\021\001\
\077\000\027\001\029\001\018\001\058\000\031\001\000\000\029\001\
\001\001\002\001\003\001\004\001\059\000\060\000\029\001\062\000\
\063\000\028\001\065\000\029\001\018\001\075\000\021\001\016\001\
\029\001\102\000\002\001\017\001\017\001\076\000\029\001\029\001\
\026\001\000\000\027\001\029\001\026\001\026\001\115\000\029\001\
\029\001\007\001\017\001\021\001\091\000\092\000\093\000\019\001\
\095\000\007\001\097\000\026\001\099\000\007\001\029\001\025\001\
\028\001\029\001\112\000\029\001\000\000\007\001\032\001\025\001\
\024\001\119\000\113\000\029\001\122\000\029\001\032\001\125\000\
\001\001\002\001\003\001\004\001\005\001\013\001\014\001\008\001\
\127\000\007\001\129\000\007\001\131\000\000\000\000\000\016\001\
\000\000\132\000\135\000\020\001\135\000\019\000\023\001\130\000\
\110\000\107\000\027\001\028\001\001\001\002\001\003\001\004\001\
\005\001\087\000\255\255\008\001\255\255\255\255\000\000\011\001\
\012\001\013\001\014\001\016\001\255\255\255\255\255\255\020\001\
\255\255\255\255\023\001\255\255\255\255\255\255\027\001\001\001\
\002\001\003\001\004\001\005\001\007\001\255\255\008\001\000\000\
\011\001\012\001\013\001\014\001\015\001\255\255\016\001\255\255\
\255\255\255\255\020\001\255\255\255\255\023\001\255\255\255\255\
\255\255\027\001\045\000\046\000\047\000\048\000\049\000\050\000\
\000\000\255\255\001\000\002\000\003\000\004\000\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\000\000\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\000\000\255\255\255\255\255\255\006\001\007\001\
\255\255\009\001\010\001\011\001\012\001\013\001\014\001\015\001\
\255\255\017\001\018\001\019\001\255\255\255\255\255\255\255\255\
\024\001\025\001\026\001\255\255\028\001\029\001\030\001\029\001\
\032\001\006\001\007\001\255\255\009\001\010\001\011\001\012\001\
\255\255\255\255\015\001\255\255\017\001\018\001\019\001\255\255\
\255\255\255\255\255\255\024\001\025\001\026\001\255\255\028\001\
\029\001\030\001\017\001\032\001\006\001\007\001\021\001\009\001\
\010\001\011\001\012\001\026\001\255\255\015\001\255\255\017\001\
\018\001\019\001\255\255\255\255\255\255\255\255\024\001\025\001\
\026\001\255\255\028\001\029\001\030\001\255\255\032\001\006\001\
\007\001\255\255\009\001\010\001\255\255\255\255\255\255\255\255\
\015\001\255\255\017\001\018\001\019\001\255\255\255\255\255\255\
\255\255\024\001\025\001\026\001\255\255\028\001\029\001\030\001\
\255\255\032\001\006\001\007\001\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\015\001\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\255\255\
\028\001\029\001\030\001\006\001\032\001\255\255\009\001\010\001\
\255\255\255\255\255\255\255\255\255\255\255\255\017\001\018\001\
\019\001\255\255\255\255\255\255\255\255\024\001\025\001\026\001\
\255\255\028\001\029\001\030\001\006\001\032\001\255\255\009\001\
\010\001\255\255\255\255\255\255\255\255\255\255\255\255\017\001\
\018\001\019\001\255\255\255\255\255\255\255\255\024\001\025\001\
\026\001\255\255\028\001\255\255\030\001\006\001\032\001\255\255\
\009\001\010\001\255\255\255\255\255\255\255\255\255\255\255\255\
\017\001\018\001\019\001\255\255\255\255\255\255\255\255\024\001\
\025\001\026\001\255\255\028\001\255\255\030\001\006\001\032\001\
\255\255\009\001\010\001\255\255\255\255\255\255\255\255\255\255\
\255\255\017\001\018\001\019\001\255\255\255\255\255\255\255\255\
\024\001\025\001\026\001\255\255\028\001\255\255\030\001\006\001\
\032\001\255\255\009\001\010\001\255\255\255\255\255\255\255\255\
\255\255\255\255\017\001\018\001\019\001\255\255\255\255\255\255\
\255\255\024\001\025\001\026\001\255\255\028\001\255\255\030\001\
\006\001\032\001\255\255\009\001\010\001\255\255\255\255\255\255\
\255\255\255\255\255\255\017\001\018\001\019\001\255\255\255\255\
\255\255\255\255\024\001\025\001\026\001\255\255\028\001\255\255\
\030\001\255\255\032\001"

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
  SSC\000\
  EOF\000\
  FUN\000\
  ARROW\000\
  REC\000\
  MATCH\000\
  WITH\000\
  OR\000\
  COMMA\000\
  LBPAR\000\
  RBPAR\000\
  CONS\000\
  AND\000\
  WILD\000\
  END\000\
  "

let yynames_block = "\
  INT\000\
  ID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 52 "parser_cbn.mly"
                                          ( CLet (_2, _4) )
# 368 "parser_cbn.ml"
               : Syntax_cbn.command))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 53 "parser_cbn.mly"
                                          ( CRLetAnd ((_3, _4, _6) :: _7) )
# 378 "parser_cbn.ml"
               : Syntax_cbn.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 54 "parser_cbn.mly"
                                          ( CExp _1 )
# 385 "parser_cbn.ml"
               : Syntax_cbn.command))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 58 "parser_cbn.mly"
                                          ( (_2,_3,_5) :: _6 )
# 395 "parser_cbn.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "parser_cbn.mly"
                                          ( [] )
# 401 "parser_cbn.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 63 "parser_cbn.mly"
                                          ( _1 )
# 408 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 68 "parser_cbn.mly"
                                          ( EFun(_2,_4) )
# 416 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 70 "parser_cbn.mly"
                                          ( _1 )
# 423 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 72 "parser_cbn.mly"
                                          ( EIf(_2, _4, _6) )
# 432 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 74 "parser_cbn.mly"
                                          ( ELet(_2, _4, _6) )
# 441 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : 'and_expr) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 76 "parser_cbn.mly"
                                          ( ERLetAnd (((_3, _4, _6) :: _7), _8) )
# 452 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'match_pattern) in
    Obj.repr(
# 78 "parser_cbn.mly"
                                          ( EMatch (_2, _4) )
# 460 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 80 "parser_cbn.mly"
                                          ( ECons (_1, _3) )
# 468 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_expr) in
    Obj.repr(
# 85 "parser_cbn.mly"
                                          ( (_2, _3, _5) :: _6 )
# 478 "parser_cbn.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "parser_cbn.mly"
                                          ( [] )
# 484 "parser_cbn.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 91 "parser_cbn.mly"
                                          ( EBin(OpAdd,_1,_3) )
# 492 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 92 "parser_cbn.mly"
                                          ( EBin(OpSub,_1,_3) )
# 500 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 93 "parser_cbn.mly"
                                          ( EBin(OpMul,_1,_3) )
# 508 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 94 "parser_cbn.mly"
                                          ( EBin(OpDiv,_1,_3) )
# 516 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 95 "parser_cbn.mly"
                                          ( EBin(OpEq,_1,_3) )
# 524 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 96 "parser_cbn.mly"
                                          ( EBin(OpLt,_1,_3) )
# 532 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 98 "parser_cbn.mly"
                                          ( _1 )
# 539 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 103 "parser_cbn.mly"
                                          ( EApp(_1,_2) )
# 547 "parser_cbn.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 104 "parser_cbn.mly"
                                          ( _1 )
# 554 "parser_cbn.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 109 "parser_cbn.mly"
                                          ( [] )
# 560 "parser_cbn.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 110 "parser_cbn.mly"
                                          ( (_1,_3) :: _4 )
# 569 "parser_cbn.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 111 "parser_cbn.mly"
                                          ( [(_1,_3)] )
# 577 "parser_cbn.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 115 "parser_cbn.mly"
                                          ( (_2,_4) :: _5 )
# 586 "parser_cbn.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 116 "parser_cbn.mly"
                                          ( (_2,_4) :: [] )
# 594 "parser_cbn.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 123 "parser_cbn.mly"
                                          ( PInt _1 )
# 601 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 124 "parser_cbn.mly"
                                          ( PBool true )
# 607 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 125 "parser_cbn.mly"
                                          ( PBool false )
# 613 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 127 "parser_cbn.mly"
                                          ( PVar (_1) )
# 620 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.pattern) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 129 "parser_cbn.mly"
                                          ( PTuple (_2 :: _4 :: _5) )
# 629 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 131 "parser_cbn.mly"
                                          ( PNil )
# 635 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.pattern) in
    Obj.repr(
# 133 "parser_cbn.mly"
                                          ( PCons (_1, _3) )
# 643 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 134 "parser_cbn.mly"
                                          ( PWild )
# 649 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 138 "parser_cbn.mly"
                                          ( _2 :: _3 )
# 657 "parser_cbn.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 139 "parser_cbn.mly"
                                          ( [] )
# 663 "parser_cbn.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 144 "parser_cbn.mly"
                                          ( ELiteral _1 )
# 670 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 145 "parser_cbn.mly"
                                          ( EVar (_1) )
# 677 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 146 "parser_cbn.mly"
                                          ( _2 )
# 684 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 148 "parser_cbn.mly"
                                          ( ETuple (_2 :: _4 :: _5) )
# 693 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 150 "parser_cbn.mly"
                                          ( ENil )
# 699 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 152 "parser_cbn.mly"
                                          ( ECons (_2, _3) )
# 707 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 156 "parser_cbn.mly"
                                          ( _2 :: _3 )
# 715 "parser_cbn.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 157 "parser_cbn.mly"
                                          ( [] )
# 721 "parser_cbn.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 161 "parser_cbn.mly"
                                          ( ECons(_2,_3) )
# 729 "parser_cbn.ml"
               : 'lists))
; (fun __caml_parser_env ->
    Obj.repr(
# 162 "parser_cbn.mly"
                                          ( ENil )
# 735 "parser_cbn.ml"
               : 'lists))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 166 "parser_cbn.mly"
                                          ( LInt _1 )
# 742 "parser_cbn.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 167 "parser_cbn.mly"
                                          ( LBool true )
# 748 "parser_cbn.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 168 "parser_cbn.mly"
                                          ( LBool false )
# 754 "parser_cbn.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 172 "parser_cbn.mly"
                                          ( _1 )
# 761 "parser_cbn.ml"
               : 'var))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry expr *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry command *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry pattern *)
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
   (Parsing.yyparse yytables 1 lexfun lexbuf : Syntax_cbn.expr)
let expr (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : Syntax_cbn.expr)
let command (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 3 lexfun lexbuf : Syntax_cbn.command)
let pattern (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 4 lexfun lexbuf : Syntax_cbn.pattern)
