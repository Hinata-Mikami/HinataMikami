/* The Parser generator file */
/*
See the explanation
https://kenichi-asai.github.io/lex-yacc/
*/

/* Prelude */
%{
exception Parse of string
let raise_parse (s:string) : 'a = raise (Parse s)

module type lang = module type of Lang with type obs = unit

let parse (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) 
      (module M:lang) : unit =
let open struct

(* `Desugaring' exp1 OP exp2 as
  let val temp := exp2 in exp1 OP temp end
*)
let binary (op: M.repr -> M.atom -> M.repr) (e1:M.repr) (e2:M.repr) : M.repr =
  let tempvar = Util.gensym "__t" in    (* why two underscores? *)
  M.local (tempvar,e2) (op e1 (M.var tempvar))

%}

/* Tokens */
%token <int64> INT
%token TRUE FALSE
%token NOT SUCC PRED ISZERO
%token LPAREN RPAREN
%token <string> IDENT
%token PLUS MINUS TIMES DIV
%token AMPERSAND BAR
%token LESS GREATER EQUAL LESSGREATER LESSEQUAL GREATEREQUAL
%token <string * Lexing.position> STRING
%token LET IN VAL END COLONEQUAL
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
%nonassoc LET
%nonassoc COLONEQUAL
%right BAR AMPERSAND
%nonassoc EQUAL LESS GREATER LESSEQUAL GREATEREQUAL LESSGREATER
%left PLUS MINUS        /* lowest precedence */
%left TIMES DIV         /* medium precedence */
%nonassoc prec_unary_minus   /* marker for the prefix op */
%nonassoc prec_appl          /* marker for the highest precedence */

/* Finally, the first tokens of simple_expr are above everything else. */
%nonassoc TRUE FALSE INT IDENT LPAREN STRING

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
   atom                    { M.atomic $1 }
 | LPAREN exp RPAREN       { $2 }
 | unary atom              { $1 (M.atomic $2) }
 | unary LPAREN exp RPAREN { $1 $3 }
 | exp PLUS exp            { binary M.add $1 $3 }
 | exp MINUS exp           { binary M.sub $1 $3 }
 | exp TIMES exp           { binary M.mul $1 $3 }
 | exp BAR exp             { binary M.bor $1 $3 }
 | exp AMPERSAND exp       { binary M.band $1 $3 }
 | exp EQUAL exp           { binary M.eq $1 $3 }
 | exp LESSGREATER exp     { binary M.neq $1 $3 }
 | exp LESS exp            { binary M.lt $1 $3 }
 | exp LESSEQUAL exp       { binary M.leq $1 $3 }
 | exp GREATER exp         { binary M.gt $1 $3 }
 | exp GREATEREQUAL exp    { binary M.geq $1 $3 }
 | LET letblock  { $2  }
;

unary:
 | MINUS  { M.neg }
 | NOT    { M.not }
 | SUCC   { M.succ }
 | PRED   { M.pred }
 | ISZERO { M.is_zero }
;

atom:
   INT   { M.int $1 }
 | TRUE  { M.bool true }
 | FALSE { M.bool false }
 | IDENT { M.var $1 }
;

letblock: 
  VAL IDENT COLONEQUAL exp lbrest  { M.local ($2,$4) $5 }
;

lbrest:
  IN exp END { $2 }
 | letblock  { $1 }
;

%%
(* Trailer *)
end in
start lexfun lexbuf |> M.observe
