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
  | END
  | COMMA
  | LBPAR
  | RBPAR
  | CONS
  | AND
  | WILD

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
  282 (* END *);
  283 (* COMMA *);
  284 (* LBPAR *);
  285 (* RBPAR *);
  286 (* CONS *);
  287 (* AND *);
  288 (* WILD *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* ID *);
    0|]

let yylhs = "\255\255\
\003\000\003\000\003\000\006\000\006\000\001\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\008\000\008\000\009\000\009\000\007\000\007\000\007\000\007\000\
\007\000\007\000\007\000\012\000\012\000\010\000\010\000\014\000\
\014\000\004\000\004\000\004\000\004\000\004\000\004\000\004\000\
\004\000\015\000\015\000\013\000\013\000\013\000\013\000\017\000\
\017\000\011\000\011\000\016\000\016\000\016\000\005\000\000\000\
\000\000\000\000\000\000"

let yylen = "\002\000\
\005\000\007\000\002\000\006\000\001\000\002\000\004\000\001\000\
\006\000\006\000\007\000\008\000\004\000\002\000\003\000\003\000\
\002\000\002\000\006\000\001\000\003\000\003\000\003\000\003\000\
\003\000\003\000\001\000\002\000\001\000\004\000\004\000\005\000\
\005\000\001\000\001\000\001\000\001\000\005\000\002\000\003\000\
\001\000\003\000\001\000\001\000\001\000\003\000\005\000\003\000\
\001\000\003\000\001\000\001\000\001\000\001\000\001\000\002\000\
\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\052\000\045\000\053\000\
\054\000\000\000\000\000\000\000\000\000\000\000\000\000\056\000\
\000\000\000\000\000\000\029\000\044\000\000\000\000\000\000\000\
\058\000\034\000\037\000\035\000\036\000\000\000\000\000\041\000\
\000\000\055\000\000\000\000\000\000\000\000\000\000\000\000\000\
\014\000\000\000\006\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\028\000\000\000\000\000\003\000\000\000\039\000\
\000\000\000\000\000\000\000\000\046\000\000\000\000\000\000\000\
\000\000\051\000\015\000\000\000\000\000\000\000\000\000\023\000\
\024\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\013\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\049\000\000\000\
\047\000\000\000\050\000\000\000\001\000\043\000\000\000\038\000\
\000\000\000\000\018\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\020\000\000\000\000\000\000\000\000\000\048\000\
\000\000\031\000\030\000\005\000\000\000\002\000\042\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\033\000\032\000\000\000\019\000\004\000"

let yydgoto = "\005\000\
\016\000\017\000\025\000\033\000\091\000\126\000\018\000\092\000\
\117\000\085\000\067\000\019\000\020\000\123\000\104\000\021\000\
\097\000"

let yysindex = "\165\000\
\083\255\083\255\171\255\009\255\000\000\000\000\000\000\000\000\
\000\000\001\255\083\255\083\255\002\255\083\255\142\255\000\000\
\005\000\121\255\056\255\000\000\000\000\243\254\029\255\010\255\
\000\000\000\000\000\000\000\000\000\000\009\255\006\255\000\000\
\024\255\000\000\122\255\120\255\000\255\038\255\109\255\085\255\
\000\000\089\255\000\000\083\255\056\255\056\255\056\255\056\255\
\056\255\056\255\000\000\122\255\131\255\000\000\086\255\000\000\
\009\255\122\255\083\255\083\255\000\000\083\255\083\255\009\255\
\083\255\000\000\000\000\243\254\172\255\135\255\135\255\000\000\
\000\000\172\255\122\255\083\255\009\255\024\255\074\255\250\254\
\022\255\065\255\243\254\040\255\000\000\089\255\076\255\016\255\
\090\255\083\255\094\255\136\255\083\255\083\255\000\000\083\255\
\000\000\083\255\000\000\083\255\000\000\000\000\009\255\000\000\
\147\255\083\255\000\000\083\255\243\254\243\254\065\255\017\255\
\059\255\090\255\000\000\122\255\083\255\243\254\243\254\000\000\
\009\255\000\000\000\000\000\000\122\255\000\000\000\000\122\255\
\243\254\041\255\122\255\133\255\083\255\154\255\083\255\134\255\
\083\255\014\255\000\000\000\000\008\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\131\000\001\000\000\000\000\000\163\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\180\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\157\000\079\000\027\000\053\000\000\000\
\000\000\105\000\000\000\000\000\000\000\074\000\000\000\000\000\
\000\000\000\000\181\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\176\255\000\000\000\000\000\000\205\000\229\000\000\000\000\000\
\176\255\000\000\000\000\000\000\000\000\176\255\253\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\021\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\004\000\000\000\228\255\254\255\047\000\106\000\098\000\
\240\255\000\000\104\000\000\000\173\000\057\000\081\000\000\000\
\085\000"

let yytablesize = 564
let yytable = "\093\000\
\027\000\055\000\034\000\039\000\043\000\022\000\024\000\036\000\
\060\000\026\000\027\000\028\000\029\000\115\000\037\000\038\000\
\044\000\040\000\042\000\115\000\053\000\093\000\035\000\044\000\
\030\000\124\000\021\000\054\000\078\000\044\000\034\000\094\000\
\058\000\101\000\056\000\084\000\031\000\044\000\125\000\044\000\
\032\000\121\000\122\000\044\000\116\000\044\000\044\000\068\000\
\089\000\075\000\052\000\044\000\022\000\057\000\061\000\079\000\
\006\000\007\000\008\000\009\000\098\000\133\000\080\000\081\000\
\062\000\082\000\083\000\044\000\086\000\057\000\057\000\012\000\
\087\000\040\000\114\000\034\000\124\000\034\000\025\000\088\000\
\090\000\095\000\100\000\006\000\007\000\008\000\009\000\010\000\
\044\000\125\000\011\000\096\000\130\000\105\000\044\000\034\000\
\109\000\110\000\012\000\111\000\106\000\112\000\013\000\113\000\
\026\000\014\000\102\000\065\000\064\000\118\000\015\000\119\000\
\077\000\128\000\044\000\057\000\103\000\066\000\044\000\057\000\
\129\000\142\000\131\000\034\000\142\000\132\000\059\000\045\000\
\134\000\063\000\008\000\046\000\047\000\048\000\049\000\050\000\
\136\000\076\000\138\000\135\000\141\000\108\000\006\000\007\000\
\008\000\009\000\010\000\048\000\049\000\011\000\069\000\070\000\
\071\000\072\000\073\000\074\000\016\000\012\000\121\000\139\000\
\137\000\013\000\057\000\044\000\014\000\001\000\002\000\003\000\
\004\000\015\000\041\000\006\000\007\000\008\000\009\000\023\000\
\044\000\116\000\011\000\059\000\007\000\017\000\046\000\047\000\
\048\000\049\000\012\000\143\000\107\000\099\000\013\000\051\000\
\140\000\014\000\127\000\120\000\000\000\000\000\015\000\000\000\
\000\000\000\000\000\000\000\000\010\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\009\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\011\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\027\000\027\000\
\000\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
\000\000\027\000\027\000\027\000\012\000\000\000\000\000\000\000\
\027\000\027\000\027\000\027\000\000\000\027\000\027\000\027\000\
\021\000\021\000\044\000\021\000\021\000\021\000\021\000\000\000\
\000\000\021\000\000\000\021\000\021\000\021\000\000\000\000\000\
\000\000\000\000\021\000\021\000\021\000\021\000\000\000\021\000\
\021\000\021\000\022\000\022\000\000\000\022\000\022\000\022\000\
\022\000\000\000\000\000\022\000\000\000\022\000\022\000\022\000\
\000\000\000\000\000\000\000\000\022\000\022\000\022\000\022\000\
\000\000\022\000\022\000\022\000\025\000\025\000\000\000\025\000\
\025\000\000\000\040\000\000\000\000\000\025\000\040\000\025\000\
\025\000\025\000\000\000\000\000\040\000\000\000\025\000\025\000\
\025\000\025\000\000\000\025\000\025\000\025\000\026\000\026\000\
\000\000\026\000\026\000\000\000\000\000\000\000\000\000\026\000\
\000\000\026\000\026\000\026\000\000\000\000\000\000\000\000\000\
\026\000\026\000\026\000\026\000\000\000\026\000\026\000\026\000\
\008\000\000\000\000\000\008\000\008\000\000\000\000\000\000\000\
\000\000\000\000\000\000\008\000\008\000\008\000\000\000\000\000\
\000\000\000\000\008\000\008\000\008\000\008\000\000\000\008\000\
\008\000\008\000\016\000\000\000\000\000\016\000\016\000\000\000\
\000\000\000\000\000\000\000\000\000\000\016\000\016\000\016\000\
\000\000\000\000\000\000\000\000\016\000\016\000\016\000\016\000\
\000\000\016\000\007\000\016\000\000\000\007\000\007\000\000\000\
\000\000\000\000\000\000\000\000\000\000\007\000\007\000\007\000\
\000\000\000\000\000\000\000\000\007\000\007\000\007\000\007\000\
\000\000\007\000\010\000\007\000\000\000\010\000\010\000\000\000\
\000\000\000\000\000\000\000\000\000\000\010\000\010\000\010\000\
\000\000\000\000\000\000\000\000\010\000\010\000\010\000\010\000\
\000\000\010\000\009\000\010\000\000\000\009\000\009\000\000\000\
\000\000\000\000\000\000\000\000\000\000\009\000\009\000\009\000\
\000\000\000\000\000\000\000\000\009\000\009\000\009\000\009\000\
\000\000\009\000\011\000\009\000\000\000\011\000\011\000\000\000\
\000\000\000\000\000\000\000\000\000\000\011\000\011\000\011\000\
\000\000\000\000\000\000\000\000\011\000\011\000\011\000\011\000\
\000\000\011\000\012\000\011\000\000\000\012\000\012\000\000\000\
\000\000\000\000\000\000\000\000\000\000\012\000\012\000\012\000\
\000\000\000\000\000\000\000\000\012\000\012\000\012\000\012\000\
\000\000\012\000\000\000\012\000"

let yycheck = "\006\001\
\000\000\030\000\002\001\002\001\000\000\002\000\003\000\010\000\
\009\001\001\001\002\001\003\001\004\001\006\001\011\000\012\000\
\030\001\014\000\015\000\006\001\023\000\006\001\022\001\030\001\
\016\001\018\001\000\000\018\001\057\000\030\001\002\001\010\001\
\035\000\018\001\029\001\064\000\028\001\030\001\031\001\030\001\
\032\001\025\001\026\001\030\001\031\001\030\001\030\001\044\000\
\077\000\052\000\022\001\030\001\000\000\030\001\017\001\058\000\
\001\001\002\001\003\001\004\001\021\001\021\001\059\000\060\000\
\027\001\062\000\063\000\030\001\065\000\030\001\030\001\016\001\
\075\000\000\000\103\000\002\001\018\001\002\001\000\000\076\000\
\007\001\017\001\007\001\001\001\002\001\003\001\004\001\005\001\
\030\001\031\001\008\001\027\001\121\000\090\000\030\001\002\001\
\093\000\094\000\016\001\096\000\007\001\098\000\020\001\100\000\
\000\000\023\001\017\001\019\001\024\001\106\000\028\001\108\000\
\027\001\116\000\030\001\030\001\027\001\029\001\030\001\030\001\
\117\000\138\000\125\000\002\001\141\000\128\000\007\001\007\001\
\131\000\021\001\000\000\011\001\012\001\013\001\014\001\015\001\
\133\000\007\001\135\000\007\001\137\000\006\001\001\001\002\001\
\003\001\004\001\005\001\013\001\014\001\008\001\045\000\046\000\
\047\000\048\000\049\000\050\000\000\000\016\001\025\001\026\001\
\007\001\020\001\000\000\030\001\023\001\001\000\002\000\003\000\
\004\000\028\001\029\001\001\001\002\001\003\001\004\001\005\001\
\030\001\031\001\008\001\000\000\000\000\006\001\011\001\012\001\
\013\001\014\001\016\001\141\000\091\000\086\000\020\001\019\000\
\136\000\023\001\114\000\111\000\255\255\255\255\028\001\255\255\
\255\255\255\255\255\255\255\255\000\000\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\000\000\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\000\000\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\006\001\007\001\
\255\255\009\001\010\001\011\001\012\001\013\001\014\001\015\001\
\255\255\017\001\018\001\019\001\000\000\255\255\255\255\255\255\
\024\001\025\001\026\001\027\001\255\255\029\001\030\001\031\001\
\006\001\007\001\030\001\009\001\010\001\011\001\012\001\255\255\
\255\255\015\001\255\255\017\001\018\001\019\001\255\255\255\255\
\255\255\255\255\024\001\025\001\026\001\027\001\255\255\029\001\
\030\001\031\001\006\001\007\001\255\255\009\001\010\001\011\001\
\012\001\255\255\255\255\015\001\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\030\001\031\001\006\001\007\001\255\255\009\001\
\010\001\255\255\017\001\255\255\255\255\015\001\021\001\017\001\
\018\001\019\001\255\255\255\255\027\001\255\255\024\001\025\001\
\026\001\027\001\255\255\029\001\030\001\031\001\006\001\007\001\
\255\255\009\001\010\001\255\255\255\255\255\255\255\255\015\001\
\255\255\017\001\018\001\019\001\255\255\255\255\255\255\255\255\
\024\001\025\001\026\001\027\001\255\255\029\001\030\001\031\001\
\006\001\255\255\255\255\009\001\010\001\255\255\255\255\255\255\
\255\255\255\255\255\255\017\001\018\001\019\001\255\255\255\255\
\255\255\255\255\024\001\025\001\026\001\027\001\255\255\029\001\
\030\001\031\001\006\001\255\255\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\006\001\031\001\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\006\001\031\001\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\006\001\031\001\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\006\001\031\001\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\006\001\031\001\255\255\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\017\001\018\001\019\001\
\255\255\255\255\255\255\255\255\024\001\025\001\026\001\027\001\
\255\255\029\001\255\255\031\001"

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
  END\000\
  COMMA\000\
  LBPAR\000\
  RBPAR\000\
  CONS\000\
  AND\000\
  WILD\000\
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
# 374 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 53 "parser.mly"
                                          ( CRLetAnd ((_3, _4, _6) :: _7) )
# 384 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 54 "parser.mly"
                                          ( CExp _1 )
# 391 "parser.ml"
               : Syntax.command))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_command) in
    Obj.repr(
# 59 "parser.mly"
                                          ( (_2,_3,_5) :: _6 )
# 401 "parser.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    Obj.repr(
# 60 "parser.mly"
                                          ( [] )
# 407 "parser.ml"
               : 'and_command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 64 "parser.mly"
                                          ( _1 )
# 414 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 69 "parser.mly"
                                          ( EFun(_2,_4) )
# 422 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 71 "parser.mly"
                                          ( _1 )
# 429 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 73 "parser.mly"
                                          ( EIf(_2, _4, _6) )
# 438 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 75 "parser.mly"
                                          ( ELet(_2, _4, _6) )
# 447 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'rec_expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 77 "parser.mly"
                                          ( ERLet(_3, _4, _5, _7) )
# 457 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : 'var) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : 'and_expr) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 79 "parser.mly"
                                          ( ERLetAnd (((_3, _4, _6) :: _7), _8) )
# 468 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'match_pattern) in
    Obj.repr(
# 81 "parser.mly"
                                          ( EMatch (_2, _4) )
# 476 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 83 "parser.mly"
                                          ( ENil )
# 482 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 85 "parser.mly"
                                          ( ECons (_2, _3) )
# 490 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 87 "parser.mly"
                                          ( ECons (_1, _3) )
# 498 "parser.ml"
               : Syntax.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Syntax.expr) in
    Obj.repr(
# 95 "parser.mly"
                                          ( _2 )
# 505 "parser.ml"
               : 'rec_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'var) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'rec_expr) in
    Obj.repr(
# 97 "parser.mly"
                                          ( EFun(_1, _2) )
# 513 "parser.ml"
               : 'rec_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'var) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'var) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'and_expr) in
    Obj.repr(
# 103 "parser.mly"
                                          ( (_2, _3, _5) :: _6 )
# 523 "parser.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 104 "parser.mly"
                                          ( [] )
# 529 "parser.ml"
               : 'and_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 111 "parser.mly"
                                          ( EBin(OpAdd,_1,_3) )
# 537 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 112 "parser.mly"
                                          ( EBin(OpSub,_1,_3) )
# 545 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 113 "parser.mly"
                                          ( EBin(OpMul,_1,_3) )
# 553 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 114 "parser.mly"
                                          ( EBin(OpDiv,_1,_3) )
# 561 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 115 "parser.mly"
                                          ( EBin(OpEq,_1,_3) )
# 569 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 116 "parser.mly"
                                          ( EBin(OpLt,_1,_3) )
# 577 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'app_expr) in
    Obj.repr(
# 118 "parser.mly"
                                          ( _1 )
# 584 "parser.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'app_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 123 "parser.mly"
                                          ( EApp(_1,_2) )
# 592 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atomic_expr) in
    Obj.repr(
# 124 "parser.mly"
                                          ( _1 )
# 599 "parser.ml"
               : 'app_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 130 "parser.mly"
                                          ( (_1,_3) :: _4 )
# 608 "parser.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 131 "parser.mly"
                                          ( [(_1,_3)] )
# 616 "parser.ml"
               : 'match_pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'patterns) in
    Obj.repr(
# 135 "parser.mly"
                                          ( (_2,_4) :: _5 )
# 625 "parser.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 136 "parser.mly"
                                          ( (_2,_4) :: [] )
# 633 "parser.ml"
               : 'patterns))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 142 "parser.mly"
                                          ( PInt _1 )
# 640 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 143 "parser.mly"
                                          ( PBool true )
# 646 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 144 "parser.mly"
                                          ( PBool false )
# 652 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 146 "parser.mly"
                                          ( PVar (_1) )
# 659 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.pattern) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 148 "parser.mly"
                                          ( PTuple (_2 :: _4 :: _5) )
# 668 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 150 "parser.mly"
                                          ( PNil )
# 674 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Syntax.pattern) in
    Obj.repr(
# 152 "parser.mly"
                                          ( PCons (_1, _3) )
# 682 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 153 "parser.mly"
                                          ( PWild )
# 688 "parser.ml"
               : Syntax.pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ptuple) in
    Obj.repr(
# 157 "parser.mly"
                                          ( _2 :: _3 )
# 696 "parser.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 158 "parser.mly"
                                          ( [] )
# 702 "parser.ml"
               : 'ptuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 163 "parser.mly"
                                          ( ELiteral _1 )
# 709 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 164 "parser.mly"
                                          ( EVar (_1) )
# 716 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    Obj.repr(
# 165 "parser.mly"
                                          ( _2 )
# 723 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Syntax.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 166 "parser.mly"
                                          ( ETuple (_2 :: _4 :: _5) )
# 732 "parser.ml"
               : 'atomic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 170 "parser.mly"
                                          ( _2 :: _3 )
# 740 "parser.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    Obj.repr(
# 171 "parser.mly"
                                          ( [] )
# 746 "parser.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Syntax.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lists) in
    Obj.repr(
# 175 "parser.mly"
                                          ( ECons(_2,_3) )
# 754 "parser.ml"
               : 'lists))
; (fun __caml_parser_env ->
    Obj.repr(
# 176 "parser.mly"
                                          ( ENil )
# 760 "parser.ml"
               : 'lists))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 180 "parser.mly"
                                          ( LInt _1 )
# 767 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 181 "parser.mly"
                                          ( LBool true )
# 773 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 182 "parser.mly"
                                          ( LBool false )
# 779 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 186 "parser.mly"
                                          ( _1 )
# 786 "parser.ml"
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
