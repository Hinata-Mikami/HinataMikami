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
\005\000\006\000\002\000\005\000\001\000\002\000\004\000\001\000\
\006\000\006\000\007\000\004\000\003\000\005\000\001\000\003\000\
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
\000\000\048\000\000\000\001\000\039\000\000\000\034\000\015\000\
\000\000\000\000\000\000\000\000\000\000\000\000\005\000\000\000\
\002\000\000\000\000\000\000\000\046\000\000\000\027\000\026\000\
\000\000\038\000\000\000\000\000\000\000\000\000\000\000\000\000\
\014\000\000\000\004\000\029\000\028\000"

let yydgoto = "\005\000\
\016\000\017\000\025\000\033\000\036\000\113\000\018\000\106\000\
\086\000\019\000\020\000\120\000\103\000\021\000\096\000\067\000"

let yysindex = "\185\000\
\138\255\138\255\147\255\029\255\000\000\000\000\000\000\000\000\
\000\000\021\255\138\255\138\255\018\255\138\255\110\255\000\000\
\003\000\109\255\047\255\000\000\000\000\249\254\035\255\040\255\
\000\000\000\000\000\000\000\000\000\000\029\255\016\255\000\000\
\041\255\000\000\071\255\069\255\050\255\054\255\065\255\107\255\
\000\000\056\255\000\000\138\255\047\255\047\255\047\255\047\255\
\047\255\047\255\000\000\071\255\086\255\000\000\248\254\000\000\
\029\255\098\255\138\255\138\255\000\000\138\255\138\255\008\255\
\138\255\000\000\000\000\249\254\179\255\131\255\131\255\000\000\
\000\000\179\255\100\255\138\255\029\255\041\255\138\255\009\255\
\058\255\074\255\249\254\000\000\077\255\000\000\056\255\138\255\
\048\255\075\255\252\254\138\255\138\255\000\000\138\255\000\000\
\138\255\000\000\023\255\000\000\000\000\029\255\000\000\000\000\
\071\255\138\255\249\254\249\254\074\255\103\255\000\000\071\255\
\000\000\075\255\112\255\249\254\000\000\029\255\000\000\000\000\
\140\255\000\000\138\255\081\255\138\255\252\254\138\255\023\255\
\000\000\128\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\134\000\001\000\000\000\000\000\117\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\156\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\159\000\082\000\028\000\055\000\000\000\
\000\000\109\000\000\000\000\000\000\000\042\000\000\000\000\000\
\000\000\000\000\184\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\209\000\234\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\003\001\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\002\000\000\000\226\255\240\255\034\000\130\000\136\255\
\000\000\000\000\145\000\036\000\054\000\000\000\060\000\084\000"

let yytablesize = 547
let yytable = "\055\000\
\022\000\104\000\043\000\022\000\024\000\129\000\053\000\129\000\
\026\000\027\000\028\000\029\000\037\000\038\000\092\000\040\000\
\042\000\077\000\058\000\039\000\057\000\044\000\034\000\030\000\
\044\000\105\000\078\000\016\000\104\000\026\000\027\000\028\000\
\029\000\085\000\031\000\075\000\034\000\044\000\032\000\084\000\
\111\000\036\000\035\000\056\000\030\000\068\000\090\000\006\000\
\007\000\008\000\009\000\044\000\112\000\092\000\017\000\031\000\
\052\000\054\000\060\000\032\000\080\000\081\000\012\000\082\000\
\083\000\100\000\087\000\093\000\044\000\057\000\061\000\114\000\
\034\000\015\000\065\000\059\000\044\000\089\000\044\000\062\000\
\091\000\020\000\044\000\066\000\044\000\063\000\044\000\124\000\
\115\000\099\000\094\000\101\000\076\000\107\000\108\000\121\000\
\109\000\097\000\110\000\095\000\102\000\127\000\044\000\057\000\
\079\000\057\000\088\000\116\000\021\000\057\000\006\000\007\000\
\008\000\009\000\010\000\045\000\055\000\011\000\123\000\046\000\
\047\000\048\000\049\000\050\000\126\000\012\000\128\000\118\000\
\130\000\013\000\064\000\044\000\014\000\008\000\119\000\044\000\
\015\000\041\000\006\000\007\000\008\000\009\000\010\000\048\000\
\049\000\011\000\125\000\006\000\007\000\008\000\009\000\023\000\
\118\000\012\000\011\000\057\000\044\000\013\000\013\000\132\000\
\014\000\131\000\012\000\051\000\015\000\133\000\013\000\122\000\
\117\000\014\000\098\000\000\000\000\000\015\000\069\000\070\000\
\071\000\072\000\073\000\074\000\000\000\000\000\000\000\007\000\
\000\000\001\000\002\000\003\000\004\000\046\000\047\000\048\000\
\049\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\010\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
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

let yycheck = "\030\000\
\000\000\006\001\000\000\002\000\003\000\126\000\023\000\128\000\
\001\001\002\001\003\001\004\001\011\000\012\000\006\001\014\000\
\015\000\026\001\035\000\002\001\029\001\029\001\002\001\016\001\
\029\001\030\001\057\000\000\000\006\001\001\001\002\001\003\001\
\004\001\064\000\027\001\052\000\002\001\029\001\031\001\032\001\
\018\001\000\000\022\001\028\001\016\001\044\000\077\000\001\001\
\002\001\003\001\004\001\029\001\030\001\006\001\000\000\027\001\
\022\001\018\001\009\001\031\001\059\000\060\000\016\001\062\000\
\063\000\018\001\065\000\010\001\029\001\029\001\017\001\102\000\
\002\001\027\001\019\001\007\001\029\001\076\000\029\001\026\001\
\079\000\000\000\029\001\028\001\029\001\021\001\029\001\118\000\
\105\000\088\000\017\001\017\001\007\001\092\000\093\000\112\000\
\095\000\021\001\097\000\026\001\026\001\021\001\029\001\029\001\
\007\001\029\001\007\001\106\000\000\000\029\001\001\001\002\001\
\003\001\004\001\005\001\007\001\000\000\008\001\007\001\011\001\
\012\001\013\001\014\001\015\001\123\000\016\001\125\000\025\001\
\127\000\020\001\024\001\029\001\023\001\000\000\032\001\029\001\
\027\001\028\001\001\001\002\001\003\001\004\001\005\001\013\001\
\014\001\008\001\007\001\001\001\002\001\003\001\004\001\005\001\
\025\001\016\001\008\001\000\000\029\001\020\001\000\000\032\001\
\023\001\128\000\016\001\019\000\027\001\130\000\020\001\114\000\
\109\000\023\001\087\000\255\255\255\255\027\001\045\000\046\000\
\047\000\048\000\049\000\050\000\255\255\255\255\255\255\000\000\
\255\255\001\000\002\000\003\000\004\000\011\001\012\001\013\001\
\014\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\000\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
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
# 365 "parser_cbn.ml"
               : Syntax_cbn.command))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 53 "parser_cbn.mly"
                                          ( CRLetAnd ((_3, _5) :: _6) )
# 374 "parser_cbn.ml"
               : Syntax_cbn.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 54 "parser_cbn.mly"
                                          ( CExp _1 )
# 381 "parser_cbn.ml"
               : Syntax_cbn.command))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 58 "parser_cbn.mly"
                                      ( (_2,_4) :: _5 )
# 390 "parser_cbn.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "parser_cbn.mly"
                                          ( [] )
# 396 "parser_cbn.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 63 "parser_cbn.mly"
                                          ( _1 )
# 403 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 68 "parser_cbn.mly"
                                          ( EFun(_2,_4) )
# 411 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 70 "parser_cbn.mly"
                                          ( _1 )
# 418 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 72 "parser_cbn.mly"
                                          ( EIf(_2, _4, _6) )
# 427 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 74 "parser_cbn.mly"
                                          ( ELet(_2, _4, _6) )
# 436 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'and_expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 76 "parser_cbn.mly"
                                      ( ERLetAnd (((_3, _5) :: _6), _7) )
# 446 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'match_pattern) in
    Obj.repr(
# 78 "parser_cbn.mly"
                                          ( EMatch (_2, _4) )
# 454 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.expr) in
    Obj.repr(
# 80 "parser_cbn.mly"
                                          ( ECons (_1, _3) )
# 462 "parser_cbn.ml"
               : Syntax_cbn.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'and_expr) in
    Obj.repr(
# 85 "parser_cbn.mly"
                                      ( (_2, _4) :: _5 )
# 471 "parser_cbn.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "parser_cbn.mly"
                                          ( [] )
# 477 "parser_cbn.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 91 "parser_cbn.mly"
                                          ( EBin(OpAdd,_1,_3) )
# 485 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 92 "parser_cbn.mly"
                                          ( EBin(OpSub,_1,_3) )
# 493 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 93 "parser_cbn.mly"
                                          ( EBin(OpMul,_1,_3) )
# 501 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 94 "parser_cbn.mly"
                                          ( EBin(OpDiv,_1,_3) )
# 509 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 95 "parser_cbn.mly"
                                          ( EBin(OpEq,_1,_3) )
# 517 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 96 "parser_cbn.mly"
                                          ( EBin(OpLt,_1,_3) )
# 525 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 98 "parser_cbn.mly"
                                          ( _1 )
# 532 "parser_cbn.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 103 "parser_cbn.mly"
                                          ( EApp(_1,_2) )
# 540 "parser_cbn.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 104 "parser_cbn.mly"
                                          ( _1 )
# 547 "parser_cbn.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 109 "parser_cbn.mly"
                                          ( [] )
# 553 "parser_cbn.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 110 "parser_cbn.mly"
                                          ( (_1,_3) :: _4 )
# 562 "parser_cbn.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 111 "parser_cbn.mly"
                                          ( [(_1,_3)] )
# 570 "parser_cbn.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 115 "parser_cbn.mly"
                                          ( (_2,_4) :: _5 )
# 579 "parser_cbn.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 116 "parser_cbn.mly"
                                          ( (_2,_4) :: [] )
# 587 "parser_cbn.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 123 "parser_cbn.mly"
                                          ( PInt _1 )
# 594 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 124 "parser_cbn.mly"
                                          ( PBool true )
# 600 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 125 "parser_cbn.mly"
                                          ( PBool false )
# 606 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 127 "parser_cbn.mly"
                                          ( PVar (_1) )
# 613 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.pattern) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 129 "parser_cbn.mly"
                                          ( PTuple (_2 :: _4 :: _5) )
# 622 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 131 "parser_cbn.mly"
                                          ( PNil )
# 628 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax_cbn.pattern) in
    Obj.repr(
# 133 "parser_cbn.mly"
                                          ( PCons (_1, _3) )
# 636 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 134 "parser_cbn.mly"
                                          ( PWild )
# 642 "parser_cbn.ml"
               : Syntax_cbn.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 138 "parser_cbn.mly"
                                          ( _2 :: _3 )
# 650 "parser_cbn.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 139 "parser_cbn.mly"
                                          ( [] )
# 656 "parser_cbn.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 144 "parser_cbn.mly"
                                          ( ELiteral _1 )
# 663 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 145 "parser_cbn.mly"
                                          ( EVar (_1) )
# 670 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    Obj.repr(
# 146 "parser_cbn.mly"
                                          ( _2 )
# 677 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax_cbn.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 148 "parser_cbn.mly"
                                          ( ETuple (_2 :: _4 :: _5) )
# 686 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 150 "parser_cbn.mly"
                                          ( ENil )
# 692 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 152 "parser_cbn.mly"
                                          ( ECons (_2, _3) )
# 700 "parser_cbn.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 156 "parser_cbn.mly"
                                          ( _2 :: _3 )
# 708 "parser_cbn.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 157 "parser_cbn.mly"
                                          ( [] )
# 714 "parser_cbn.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax_cbn.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 161 "parser_cbn.mly"
                                          ( ECons(_2,_3) )
# 722 "parser_cbn.ml"
               : 'lists))
; (fun __caml_parser_env ->
    Obj.repr(
# 162 "parser_cbn.mly"
                                          ( ENil )
# 728 "parser_cbn.ml"
               : 'lists))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 166 "parser_cbn.mly"
                                          ( LInt _1 )
# 735 "parser_cbn.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 167 "parser_cbn.mly"
                                          ( LBool true )
# 741 "parser_cbn.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 168 "parser_cbn.mly"
                                          ( LBool false )
# 747 "parser_cbn.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 172 "parser_cbn.mly"
                                          ( _1 )
# 754 "parser_cbn.ml"
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
