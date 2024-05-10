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


%nonassoc FUN ARROW
%nonassoc LET IN
%nonassoc IF THEN ELSE
%left EQ LT
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
  | FUN ID ARROW expr           { EFun($2,$4) }       (*関数抽象 fun x -> E*)
  | arith_expr                  { $1 } 
  | IF expr THEN expr ELSE expr { EIf($2,$4,$6) }
  | LET var EQ expr IN expr     { ELet($2, $4, $6) }
;

(*%left を使用して整理*)
arith_expr:
  | arith_expr ADD    arith_expr { EBin(OpAdd,$1,$3) }
  | arith_expr SUB    arith_expr { EBin(OpSub,$1,$3) }
  | arith_expr MUL    arith_expr { EBin(OpMul,$1,$3) }
  | arith_expr DIV    arith_expr { EBin(OpDiv,$1,$3) }
  | arith_expr EQ     arith_expr { EBin(OpEq,$1,$3) }
  | arith_expr LT     arith_expr { EBin(OpLt,$1,$3) }
  | app_expr                     { $1 }  (*atomic_exprを含む＋関数適用を扱えるapp_expr*)
;

(*関数適用+atomic expr*)
app_expr:
  | app_expr atomic_expr { EApp($1,$2) } (*関数適用 E E*)
  | atomic_expr          { $1 }
;

atomic_expr: (*これ以降分解できない式*)
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
