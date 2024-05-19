%{
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
%}

%token <int>    INT
%token <string> ID 
%token TRUE FALSE
%token LET IN EQ
%token IF THEN ELSE
%token ADD SUB MUL DIV EQ LT
%token LPAR RPAR 
%token DSC
%token EOF 
%token FUN ARROW
%token REC
%token MATCH WITH OR END
%token COMMA
%token LBPAR RBPAR
%token CONS
%token AND

//下に行くほど結合が強い
%nonassoc FUN ARROW
%nonassoc LET IN
%nonassoc IF THEN ELSE
%left EQ LT
%right CONS
%left ADD SUB
%left MUL DIV
%nonassoc INT ID LPAR RPAR


%start main expr
%type <Syntax.expr> main
%type <Syntax.expr> expr 


%start command
%type <Syntax.command> command
%% 


command:
  | LET var EQ expr DSC  { CLet($2,$4) }
  | expr DSC             { CExp $1 }
;

main: 
  | expr EOF {$1}
;

expr:
  //fun x -> E
  | FUN ID ARROW expr                         { EFun($2,$4) }  
  //算術表現     
  | arith_expr                                { $1 } 
  //if e1 then e2 else e3
  | IF expr THEN expr ELSE expr               { EIf($2,$4,$6) }
  //let x = e1 in e2
  | LET var EQ expr IN expr                   { ELet($2, $4, $6) }
  //let rec f x ... in e
  | LET REC var var rec_expr IN expr          { ERLet($3,$4,$5,$7) }
  //let rec f1 x ... and f2 x ... in e 
  | LET REC var var rec_expr let_expr IN expr { ERLetand ([($3, $4, $5)] @ $6, $8 ) }
  //match e with ...
  | MATCH expr WITH match_expr                { EMatch ($2, $4) }
  //(e1, e2)
  | LPAR expr COMMA expr RPAR                 { EPair ($2, $4) }
  //[]
  | LBPAR RBPAR                               { ENil }
  //e1::e2
  | expr CONS expr                            { ECons ($1, $3) };

//let rec f x <rec_expr> in e
rec_expr:
  // = e0
  | EQ expr      {$2}
  // x2 <rec_expr> 糖衣構文の実装
  | var rec_expr { EFun($1, $2) } 

//let rec f x = e0 <let_expr> in e
let_expr :
  | AND var var rec_expr let_expr   { [($2, $3, $4)] @ $5 }
  |                                 { [] }
;

//算術演算
arith_expr:
  | arith_expr ADD arith_expr { EBin(OpAdd,$1,$3) }
  | arith_expr SUB arith_expr { EBin(OpSub,$1,$3) }
  | arith_expr MUL arith_expr { EBin(OpMul,$1,$3) }
  | arith_expr DIV arith_expr { EBin(OpDiv,$1,$3) }
  | arith_expr EQ  arith_expr { EBin(OpEq,$1,$3) }
  | arith_expr LT  arith_expr { EBin(OpLt,$1,$3) }
  //E or E E
  | app_expr                  { $1 }
;

//E or E E
app_expr:
  | app_expr atomic_expr { EApp($1,$2) }
  | atomic_expr          { $1 }
;

//match e with ...
match_expr :
  // p1 -> e1 end
  | pattern ARROW expr END            { EMatchpairend ($1, $3) }
  // p1 -> e1 | ... 
  | pattern ARROW expr OR match_expr  { EBin (OpOr, EMatchpair ($1, $3), $5) }
;

//match e with <pattern> -> e | ...
pattern :
  //int,bool
  | literal                     { ELiteral $1 }
  //variable
  | ID                          { EVar ($1) }
  //(e1, e2)
  | LPAR expr COMMA expr RPAR   { EPair ($2, $4) }
  // []
  | LBPAR RBPAR                 { ENil }
  // e1 :: e2
  | expr CONS expr              { ECons ($1, $3) }
;

atomic_expr:
  | literal         { ELiteral $1 }
  | ID              { EVar($1) }
  | LPAR expr RPAR  { $2 }
;

literal: 
  | INT   { LInt $1 } 
  | TRUE  { LBool true } 
  | FALSE { LBool false } 
;

var:
  | ID  { $1 } 
;
