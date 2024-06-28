%{
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
%}

%token <int>    INT
%token <string> ID 
%token TRUE FALSE
%token LET IN EQ
%token IF THEN ELSE
%token ADD SUB MUL DIV LT
%token LPAR RPAR 
%token DSC
%token SSC
%token EOF 
%token FUN ARROW
%token REC
%token MATCH WITH OR
%token COMMA
%token LBPAR RBPAR
%token CONS
%token AND
%token WILD
%token END

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


%start pattern
%type <Syntax.pattern> pattern
%% 


command:
  | LET var EQ expr DSC                   { CLet ($2, $4) }
  | LET REC var var EQ expr and_command   { CRLetAnd (($3, $4, $6) :: $7) }
  | expr DSC                              { CExp $1 }
;

and_command:
  | AND var var EQ expr and_command       { ($2,$3,$5) :: $6 }
  | DSC                                   { [] }
;

main: 
  | expr EOF                              { $1 }
;

expr:
  //fun x -> E
  | FUN ID ARROW expr                     { EFun($2,$4) }  
  //算術表現・関数適用     
  | arith_expr                            { $1 } 
  //if e1 then e2 else e3
  | IF expr THEN expr ELSE expr           { EIf($2, $4, $6) }
  //let x = e1 in e2
  | LET var EQ expr IN expr               { ELet($2, $4, $6) }
  //let rec f1 x ... and f2 x ... in e (let rec x = e1 in e を含む)
  | LET REC var var EQ expr and_expr expr { ERLetAnd ((($3, $4, $6) :: $7), $8) }
  //match e with ...
  | MATCH expr WITH match_pattern         { EMatch ($2, $4) }
  // e1 :: e2
  | expr CONS expr                        { ECons ($1, $3) }
;

//let rec f x = e0 <and_expr> in e
and_expr :
  | AND var var EQ expr and_expr          { ($2, $3, $5) :: $6 }
  | IN                                    { [] }
;

//算術演算・関数適用
arith_expr:
  | arith_expr ADD arith_expr             { EBin(OpAdd,$1,$3) }
  | arith_expr SUB arith_expr             { EBin(OpSub,$1,$3) }
  | arith_expr MUL arith_expr             { EBin(OpMul,$1,$3) }
  | arith_expr DIV arith_expr             { EBin(OpDiv,$1,$3) }
  | arith_expr EQ  arith_expr             { EBin(OpEq,$1,$3) }
  | arith_expr LT  arith_expr             { EBin(OpLt,$1,$3) }
  //E or E E
  | app_expr                              { $1 }
;

//E or E E
app_expr:
  | app_expr atomic_expr                  { EApp($1,$2) }
  | atomic_expr                           { $1 }
;

//match e with ...
match_pattern:
  | END                                   { [] }
  | pattern ARROW expr patterns           { ($1,$3) :: $4 }
  | pattern ARROW expr END                { [($1,$3)] }
;

patterns:
  | OR pattern ARROW expr patterns        { ($2,$4) :: $5 }
  | OR pattern ARROW expr END             { ($2,$4) :: [] }
;


//match e with <pattern> -> e | ...
pattern :
  //int,bool
  | INT                                   { PInt $1 }
  | TRUE                                  { PBool true }
  | FALSE                                 { PBool false }
  //variable
  | ID                                    { PVar ($1) }
  //(e1, e2, ...)
  | LPAR pattern COMMA pattern ptuple     { PTuple ($2 :: $4 :: $5) }
  // []
  | LBPAR RBPAR                           { PNil }
  // e1 :: e2
  | pattern CONS pattern                  { PCons ($1, $3) }
  | WILD                                  { PWild }
;

ptuple:
  | COMMA pattern ptuple                  { $2 :: $3 }
  | RPAR                                  { [] }
;


atomic_expr:
  | literal                               { ELiteral $1 }
  | ID                                    { EVar ($1) }
  | LPAR expr RPAR                        { $2 }
  //(e1, e2, ...)
  | LPAR expr COMMA expr tuple            { ETuple ($2 :: $4 :: $5) }  
  //[] 
  | LBPAR RBPAR                           { ENil }
  //[e1; ...
  | LBPAR expr lists                      { ECons ($2, $3) }
;

tuple:
  | COMMA expr tuple                      { $2 :: $3 }
  | RPAR                                  { [] }
;

lists:
  | SSC expr lists                        { ECons($2,$3) }
  | RBPAR                                 { ENil }
;

literal: 
  | INT                                   { LInt $1 } 
  | TRUE                                  { LBool true } 
  | FALSE                                 { LBool false } 
;

var:
  | ID                                    { $1 } 
;
