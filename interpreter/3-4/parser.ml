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
# 2 "parser.mly"
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
# 50 "parser.ml"
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
\009\000\009\000\012\000\012\000\004\000\004\000\004\000\004\000\
\004\000\004\000\004\000\004\000\013\000\013\000\011\000\011\000\
\011\000\011\000\011\000\011\000\015\000\015\000\016\000\016\000\
\014\000\014\000\014\000\005\000\000\000\000\000\000\000\000\000"

let yylen = "\002\000\
\005\000\007\000\002\000\006\000\001\000\002\000\004\000\001\000\
\006\000\006\000\008\000\004\000\003\000\006\000\001\000\003\000\
\003\000\003\000\003\000\003\000\003\000\001\000\002\000\001\000\
\004\000\004\000\005\000\005\000\001\000\001\000\001\000\001\000\
\005\000\002\000\003\000\001\000\003\000\001\000\001\000\001\000\
\003\000\005\000\002\000\003\000\003\000\001\000\003\000\001\000\
\001\000\001\000\001\000\001\000\002\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\049\000\040\000\050\000\
\051\000\000\000\000\000\000\000\000\000\000\000\000\000\053\000\
\000\000\000\000\000\000\024\000\039\000\000\000\000\000\000\000\
\055\000\029\000\032\000\030\000\031\000\000\000\000\000\036\000\
\000\000\052\000\000\000\000\000\000\000\000\000\000\000\000\000\
\043\000\000\000\006\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\023\000\000\000\000\000\003\000\000\000\034\000\
\000\000\000\000\000\000\000\000\041\000\000\000\000\000\000\000\
\000\000\048\000\044\000\000\000\000\000\000\000\000\000\018\000\
\019\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\012\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\046\000\000\000\042\000\000\000\
\047\000\000\000\001\000\038\000\000\000\033\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\015\000\000\000\000\000\
\045\000\000\000\026\000\025\000\005\000\000\000\002\000\037\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\028\000\027\000\000\000\014\000\004\000"

let yydgoto = "\005\000\
\016\000\017\000\025\000\033\000\036\000\119\000\018\000\112\000\
\085\000\019\000\020\000\116\000\102\000\021\000\095\000\067\000"

let yysindex = "\185\000\
\147\255\147\255\174\255\006\255\000\000\000\000\000\000\000\000\
\000\000\010\255\147\255\147\255\004\255\147\255\119\255\000\000\
\003\000\090\255\023\255\000\000\000\000\029\255\019\255\048\255\
\000\000\000\000\000\000\000\000\000\000\006\255\063\255\000\000\
\047\255\000\000\093\255\092\255\022\255\028\255\096\255\051\255\
\000\000\055\255\000\000\147\255\023\255\023\255\023\255\023\255\
\023\255\023\255\000\000\093\255\104\255\000\000\081\255\000\000\
\006\255\093\255\147\255\147\255\000\000\147\255\147\255\006\255\
\147\255\000\000\000\000\029\255\199\255\076\255\076\255\000\000\
\000\000\199\255\093\255\147\255\006\255\047\255\111\255\009\255\
\246\254\042\255\029\255\027\255\000\000\055\255\118\255\034\255\
\043\255\147\255\147\255\147\255\000\000\147\255\000\000\147\255\
\000\000\147\255\000\000\000\000\006\255\000\000\014\255\029\255\
\029\255\042\255\056\255\005\255\043\255\000\000\093\255\147\255\
\000\000\006\255\000\000\000\000\000\000\093\255\000\000\000\000\
\093\255\029\255\058\255\093\255\122\255\147\255\124\255\147\255\
\083\255\147\255\014\255\000\000\000\000\005\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\134\000\001\000\000\000\000\000\126\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\133\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\159\000\082\000\028\000\055\000\000\000\
\000\000\109\000\000\000\000\000\000\000\042\000\000\000\000\000\
\000\000\000\000\184\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\209\000\
\234\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\003\001\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\002\000\000\000\228\255\251\255\004\000\157\000\006\000\
\000\000\000\000\117\000\012\000\034\000\000\000\038\000\059\000"

let yytablesize = 547
let yytable = "\092\000\
\022\000\055\000\043\000\022\000\024\000\039\000\026\000\027\000\
\028\000\029\000\110\000\034\000\037\000\038\000\091\000\040\000\
\042\000\053\000\044\000\110\000\034\000\030\000\117\000\006\000\
\007\000\008\000\009\000\016\000\078\000\058\000\060\000\035\000\
\031\000\044\000\118\000\084\000\032\000\044\000\012\000\091\000\
\052\000\035\000\044\000\111\000\061\000\068\000\075\000\096\000\
\089\000\015\000\044\000\099\000\079\000\062\000\017\000\057\000\
\044\000\044\000\093\000\100\000\080\000\081\000\044\000\082\000\
\083\000\054\000\086\000\094\000\101\000\087\000\044\000\057\000\
\109\000\065\000\064\000\057\000\044\000\088\000\126\000\044\000\
\114\000\020\000\066\000\044\000\044\000\123\000\057\000\115\000\
\048\000\049\000\056\000\103\000\104\000\105\000\034\000\106\000\
\045\000\107\000\059\000\108\000\046\000\047\000\048\000\049\000\
\050\000\121\000\077\000\114\000\021\000\057\000\076\000\044\000\
\124\000\122\000\132\000\125\000\063\000\090\000\127\000\006\000\
\007\000\008\000\009\000\010\000\098\000\054\000\011\000\129\000\
\128\000\131\000\130\000\134\000\056\000\008\000\012\000\051\000\
\135\000\136\000\013\000\135\000\133\000\014\000\120\000\113\000\
\097\000\015\000\041\000\006\000\007\000\008\000\009\000\010\000\
\000\000\000\000\011\000\000\000\000\000\000\000\013\000\000\000\
\000\000\000\000\012\000\000\000\000\000\000\000\013\000\000\000\
\000\000\014\000\000\000\000\000\000\000\015\000\006\000\007\000\
\008\000\009\000\023\000\000\000\000\000\011\000\000\000\007\000\
\000\000\001\000\002\000\003\000\004\000\012\000\000\000\000\000\
\000\000\013\000\000\000\000\000\014\000\000\000\000\000\000\000\
\015\000\069\000\070\000\071\000\072\000\073\000\074\000\000\000\
\010\000\046\000\047\000\048\000\049\000\000\000\000\000\000\000\
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
\016\000\016\000\035\000\016\000\017\000\017\000\035\000\017\000\
\017\000\017\000\017\000\035\000\000\000\017\000\000\000\017\000\
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
\003\001\004\001\006\001\002\001\011\000\012\000\006\001\014\000\
\015\000\023\000\029\001\006\001\002\001\016\001\018\001\001\001\
\002\001\003\001\004\001\000\000\057\000\035\000\009\001\022\001\
\027\001\029\001\030\001\064\000\031\001\029\001\016\001\006\001\
\022\001\000\000\029\001\030\001\017\001\044\000\052\000\021\001\
\077\000\027\001\029\001\018\001\058\000\026\001\000\000\029\001\
\029\001\029\001\017\001\017\001\059\000\060\000\029\001\062\000\
\063\000\018\001\065\000\026\001\026\001\075\000\029\001\029\001\
\101\000\019\001\024\001\029\001\029\001\076\000\021\001\029\001\
\025\001\000\000\028\001\029\001\029\001\114\000\029\001\032\001\
\013\001\014\001\028\001\090\000\091\000\092\000\002\001\094\000\
\007\001\096\000\007\001\098\000\011\001\012\001\013\001\014\001\
\015\001\111\000\026\001\025\001\000\000\029\001\007\001\029\001\
\118\000\112\000\032\001\121\000\021\001\007\001\124\000\001\001\
\002\001\003\001\004\001\005\001\007\001\000\000\008\001\126\000\
\007\001\128\000\007\001\130\000\000\000\000\000\016\001\019\000\
\131\000\134\000\020\001\134\000\129\000\023\001\109\000\106\000\
\086\000\027\001\028\001\001\001\002\001\003\001\004\001\005\001\
\255\255\255\255\008\001\255\255\255\255\255\255\000\000\255\255\
\255\255\255\255\016\001\255\255\255\255\255\255\020\001\255\255\
\255\255\023\001\255\255\255\255\255\255\027\001\001\001\002\001\
\003\001\004\001\005\001\255\255\255\255\008\001\255\255\000\000\
\255\255\001\000\002\000\003\000\004\000\016\001\255\255\255\255\
\255\255\020\001\255\255\255\255\023\001\255\255\255\255\255\255\
\027\001\045\000\046\000\047\000\048\000\049\000\050\000\255\255\
\000\000\011\001\012\001\013\001\014\001\255\255\255\255\255\255\
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
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 52 "parser.mly"
                                          ( CLet (_2, _4) )
# 363 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 53 "parser.mly"
                                          ( CRLetAnd ((_3, _4, _6) :: _7) )
# 373 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 54 "parser.mly"
                                          ( CExp _1 )
# 380 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 58 "parser.mly"
                                          ( (_2,_3,_5) :: _6 )
# 390 "parser.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "parser.mly"
                                          ( [] )
# 396 "parser.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 63 "parser.mly"
                                          ( _1 )
# 403 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 68 "parser.mly"
                                          ( EFun(_2,_4) )
# 411 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 70 "parser.mly"
                                          ( _1 )
# 418 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 72 "parser.mly"
                                          ( EIf(_2, _4, _6) )
# 427 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 74 "parser.mly"
                                          ( ELet(_2, _4, _6) )
# 436 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : 'and_expr) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 76 "parser.mly"
                                          ( ERLetAnd (((_3, _4, _6) :: _7), _8) )
# 447 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'match_pattern) in
    Obj.repr(
# 78 "parser.mly"
                                          ( EMatch (_2, _4) )
# 455 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 80 "parser.mly"
                                          ( ECons (_1, _3) )
# 463 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_expr) in
    Obj.repr(
# 85 "parser.mly"
                                          ( (_2, _3, _5) :: _6 )
# 473 "parser.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "parser.mly"
                                          ( [] )
# 479 "parser.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 91 "parser.mly"
                                          ( EBin(OpAdd,_1,_3) )
# 487 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 92 "parser.mly"
                                          ( EBin(OpSub,_1,_3) )
# 495 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 93 "parser.mly"
                                          ( EBin(OpMul,_1,_3) )
# 503 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 94 "parser.mly"
                                          ( EBin(OpDiv,_1,_3) )
# 511 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 95 "parser.mly"
                                          ( EBin(OpEq,_1,_3) )
# 519 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 96 "parser.mly"
                                          ( EBin(OpLt,_1,_3) )
# 527 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 98 "parser.mly"
                                          ( _1 )
# 534 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 103 "parser.mly"
                                          ( EApp(_1,_2) )
# 542 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 104 "parser.mly"
                                          ( _1 )
# 549 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 109 "parser.mly"
                                          ( (_1,_3) :: _4 )
# 558 "parser.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 110 "parser.mly"
                                          ( [(_1,_3)] )
# 566 "parser.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 114 "parser.mly"
                                          ( (_2,_4) :: _5 )
# 575 "parser.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 115 "parser.mly"
                                          ( (_2,_4) :: [] )
# 583 "parser.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 122 "parser.mly"
                                          ( PInt _1 )
# 590 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 123 "parser.mly"
                                          ( PBool true )
# 596 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 124 "parser.mly"
                                          ( PBool false )
# 602 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 126 "parser.mly"
                                          ( PVar (_1) )
# 609 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.pattern) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 128 "parser.mly"
                                          ( PTuple (_2 :: _4 :: _5) )
# 618 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 130 "parser.mly"
                                          ( PNil )
# 624 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax.pattern) in
    Obj.repr(
# 132 "parser.mly"
                                          ( PCons (_1, _3) )
# 632 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 133 "parser.mly"
                                          ( PWild )
# 638 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 137 "parser.mly"
                                          ( _2 :: _3 )
# 646 "parser.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 138 "parser.mly"
                                          ( [] )
# 652 "parser.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 143 "parser.mly"
                                          ( ELiteral _1 )
# 659 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 144 "parser.mly"
                                          ( EVar (_1) )
# 666 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 145 "parser.mly"
                                          ( _2 )
# 673 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 147 "parser.mly"
                                          ( ETuple (_2 :: _4 :: _5) )
# 682 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 149 "parser.mly"
                                          ( ENil )
# 688 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 151 "parser.mly"
                                          ( ECons (_2, _3) )
# 696 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 155 "parser.mly"
                                          ( _2 :: _3 )
# 704 "parser.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 156 "parser.mly"
                                          ( [] )
# 710 "parser.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 160 "parser.mly"
                                          ( ECons(_2,_3) )
# 718 "parser.ml"
               : 'lists))
; (fun __caml_parser_env ->
    Obj.repr(
# 161 "parser.mly"
                                          ( ENil )
# 724 "parser.ml"
               : 'lists))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 165 "parser.mly"
                                          ( LInt _1 )
# 731 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 166 "parser.mly"
                                          ( LBool true )
# 737 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 167 "parser.mly"
                                          ( LBool false )
# 743 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 171 "parser.mly"
                                          ( _1 )
# 750 "parser.ml"
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
   (Parsing.yyparse yytables 1 lexfun lexbuf : Syntax.expr)
let expr (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : Syntax.expr)
let command (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 3 lexfun lexbuf : Syntax.command)
let pattern (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 4 lexfun lexbuf : Syntax.pattern)
