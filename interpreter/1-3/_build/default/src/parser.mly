%{
  open Syntax
  (* ここに書いたものは，Parser.mliに入らないので注意 *)
%}

%token <int>    INT
%token <string> ID 
%token TRUE FALSE
(*%token LET IN EQ*)
%token IF THEN ELSE
%token ADD SUB MUL DIV EQ LT
%token LPAR RPAR 
%token EOF 

%nonassoc EQ LT
%left ADD SUB
%left MUL DIV
%nonassoc UNARY

%start main expr
%type <Syntax.expr> main
%type <Syntax.expr> expr 
%% 


(*生成される木における位置が深いほど計算の優先順位が高い*)
main: 
expr EOF {$1}
;

expr:
  | arith_expr { $1 } 
  | arith_expr LT arith_expr { EBin(OpLt, $1, $3) } (*LTの前に左右を評価*)
  | IF expr THEN expr ELSE expr { EIf($2,$4,$6) }
;

(*加減：左結合　→左に行くほど深くなる　右側は常に乗除算かアトミック*)
arith_expr:
  | arith_expr ADD term_expr { EBin(OpAdd, $1, $3) }
  | arith_expr SUB term_expr { EBin(OpSub, $1, $3) }
  | term_expr { $1 } (*加減でないときは乗除にのサブルールに入る*)
;

(*乗除：左結合　→左に行くほど深くなる　右側は常にアトミック*)
term_expr:
  | term_expr MUL atomic_expr { EBin(OpMul, $1, $3) }
  | term_expr DIV atomic_expr { EBin(OpDiv, $1, $3) }
  | atomic_expr { $1 } 
;
(*
factor_expr:
  | atomic_expr { $1 }
;
*)
atomic_expr: (*これ以降分解できない式*)
  | literal { ELiteral $1 }
  | LPAR expr RPAR { $2 }
;


literal: 
  | INT   { LInt $1 } 
  | TRUE  { LBool true } 
  | FALSE { LBool false } 
;

(*
var:
  | ID  { $1 } 
;
*)