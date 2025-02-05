/* The Parser generator file */
/*
See the explanation
https://kenichi-asai.github.io/lex-yacc/
*/

/* Prelude */
%{
open Common

exception Parse of string
let raise_parse (s:string) : 'a = raise (Parse s)

module type lang = module type of Lang with type obs = unit

let parse (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) 
      (module M:lang) : unit =
let open struct

(* An expression may be an atom, and this fact is syntactically clear.
   This is a useful distinction, and we carry it around, before
   reducing everything to M.repr
*)
type exp_atom = A of M.atom | E of M.repr

let to_repr : exp_atom -> M.repr = function
  | A a -> M.atomic a
  | E x -> x

let atomize : exp_atom -> (M.atom -> M.repr) -> M.repr = function
   | A a -> fun f -> f a
   | E e -> fun f ->
       let tempvar = Util.gensym "__t" in
       M.local (tempvar,e) (f (M.var tempvar))

(* `Desugaring' exp1 OP exp2 as
  let val temp := exp2 in exp1 OP temp end
*)
let binary (op: M.repr->M.atom->M.repr) (e1:exp_atom) (e2:exp_atom) : M.repr =
  atomize e2 (op (to_repr e1))
%}

/* Tokens */
%token <int64> INT
%token TRUE FALSE
%token NOT SUCC PRED ISZERO
%token LPAREN RPAREN
%token SEMI
%token COMMA
%token <string> IDENT
%token <string> IDENTPAREN
%token PLUS MINUS TIMES DIV
%token AMPERSAND BAR
%token LESS GREATER EQUAL LESSGREATER LESSEQUAL GREATEREQUAL
%token <string * Lexing.position> STRING
%token LET IN VAL VAR END COLONEQUAL
%token IF THEN ELSE ELIF FI
%token BARBAR AMPERAMPER
%token FOR TO DO DONE WHILE
%token COLON FUNCTION AND
%token EOF

/* Precedences and associativities.

Tokens and rules have precedences.  A reduce/reduce conflict is resolved
in favor of the first rule (in source file order).  A shift/reduce conflict
is resolved by comparing the precedence and associativity of the token to
be shifted with those of the rule to be reduced.

By default, a rule has the precedence of its rightmost terminal (if any).

When there is a shift/reduce conflict between a rule and a token that
have the same precedence, it is resolved using the associativity:
if the token is left-associative, the parser will reduce; if
right-associative, the parser will shift; if non-associative,
the parser will declare a syntax error.

We will only use associativities with operators of the kind  x * x -> x
for example, in the rules of the form    expr: expr BINOP expr
in all other cases, we define two precedences if needed to resolve
conflicts.

The precedences must be listed from low to high.
*/

%nonassoc IN            /* absolute lowest precedence */
%right    SEMI
%nonassoc LET
%nonassoc COLONEQUAL
%nonassoc COMMA
%right BAR AMPERSAND
%right    BARBAR
%right    AMPERAMPER
%nonassoc EQUAL LESS GREATER LESSEQUAL GREATEREQUAL LESSGREATER
%left PLUS MINUS        /* lowest precedence */
%left TIMES DIV         /* medium precedence */
%nonassoc prec_unary_minus   /* marker for the prefix op */
%nonassoc prec_appl          /* marker for the highest precedence */

/* Finally, the first tokens of simple_expr are above everything else. */
%nonassoc TRUE FALSE INT IDENT LPAREN STRING IDENTPAREN IF FOR WHILE AND

/* Entry points */


%start start
%type <M.repr> start
%%

/* Rules */
start:
  exp EOF
    { $1 }
;

/*
  A local binding is in the scope (environment) of the previous bindings.
  Thus we desugar
     let decl1 decl2 ... declN in body end
  as
     let decl1 in let decl2 ... in let declN in body end end ... end

  We now handle exp1 PLUS exp2 for arbitrary expressions, by desugaring
  as let val temp := exp2 in exp1 PLUS temp end
*/

exp:
   atom         { M.atomic $1 }
 | exp_complex  { $1 }

/* The same as exp but with atoms specifically marked, so we
   can distinguish them from general expressions
*/
exp_atom:
   atom         { A $1 }
 | exp_complex  { E $1 }
;

/* Basic pattern: for any binary operation OP, we have to write
   exp_atom OP exp_atom
rather than
  exp OP exp_atom
or
  exp OP exp
because otherwise we can't disambiguate based on precedence and associativity
*/

exp_complex:
 | LPAREN exp RPAREN              { $2 }
 | unary atom                     { $1 (M.atomic $2) }
 | unary LPAREN exp RPAREN        { $1 $3 }
 | exp_atom PLUS exp_atom         { binary M.add $1 $3 }
 | exp_atom MINUS exp_atom        { binary M.sub $1 $3 }
 | exp_atom TIMES exp_atom        { binary M.mul $1 $3 }
 | exp_atom BAR exp_atom          { binary M.bor $1 $3 }
 | exp_atom AMPERSAND exp_atom    { binary M.band $1 $3 }
 | exp_atom EQUAL exp_atom        { binary M.eq  $1 $3 }
 | exp_atom LESSGREATER exp_atom  { binary M.neq $1 $3 }
 | exp_atom LESS exp_atom         { binary M.lt  $1 $3 }
 | exp_atom LESSEQUAL exp_atom    { binary M.leq $1 $3 }
 | exp_atom GREATER exp_atom      { binary M.gt  $1 $3 }
 | exp_atom GREATEREQUAL exp_atom { binary M.geq $1 $3 }
 | LET letblock  { $2  }
 | LPAREN RPAREN                  { M.empty }
 | exp_atom SEMI exp_atom         { M.seq (to_repr $1) (to_repr $3) }
 | IDENTPAREN RPAREN              { M.call0 $1 }
 | IDENTPAREN exp extra_args      { $3 (M.call $1 $2) }
 | IDENT COLONEQUAL exp_atom      { M.assign $1 (to_repr $3) }
 | STRING                         { $1 |> fst |> M.string }
 | IF if_exp                      { $2 }
 | WHILE exp DO exp DONE          { M.while_ $2 $4 }
 | FOR IDENT COLONEQUAL exp TO exp_atom DO exp DONE {
     atomize $6 (fun atom -> M.for_ ($2,$4) atom $8) }
;

if_exp:
    exp THEN exp rest_if { match $4 with 
         | None   -> M.if2 $1 $3
         | Some e -> M.if3 $1 $3 e }
;

rest_if: 
   FI          { None }
 | ELSE exp FI { Some $2 }
 | ELIF if_exp { Some $2 }
;

unary:
 | MINUS  { M.neg }
 | NOT    { M.not }
 | SUCC   { M.succ }
 | PRED   { M.pred }
 | ISZERO { M.is_zero }
;

extra_args:
   RPAREN                    { fun k -> k [] }
 | COMMA exp_atom extra_args { fun k -> 
     atomize $2 (fun a -> $3 (fun l -> k (a::l))) }
;

atom:
   INT   { M.int $1 }
 | TRUE  { M.bool true }
 | FALSE { M.bool false }
 | IDENT  { M.var $1 }
;

letblock: 
   VAL IDENT COLONEQUAL atom lbrest         { M.local_atom ($2,$4) $5 }
 | VAL IDENT COLONEQUAL exp_complex lbrest  { M.local ($2,$4) $5 }
 | VAR IDENT COLONEQUAL exp lbrest          { M.local ~mut:true ($2,$4) $5 }
 | fun_decls IN exp END { M.fundecl $1 $3 } /* 変更 */
;

fun_decls:
  FUNCTION IDENTPAREN decl_args_opt RPAREN ret_type_opt exp and_rest {
    ($2, ($3, $5), $6) :: $7
  }
;

and_rest:
  AND fun_decls { $2 }
| { [] }
;

;

lbrest:
  IN exp END { $2 }
 | letblock  { $1 }
;

decl_args_opt:
               { [] }
 | decl_args   { $1 } 
;

decl_args:
 | IDENT COLON IDENT                 { [($1,$3)] } 
 | IDENT COLON IDENT COMMA decl_args { ($1,$3) :: $5 } 
;

ret_type_opt:
   EQUAL             { "void" }
 | COLON IDENT EQUAL { $2 }
;
  
%%
(* Trailer *)
end in
start lexfun lexbuf |> M.observe
