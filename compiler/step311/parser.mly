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
%}

/* Tokens */
%token <int64> INT
%token TRUE FALSE
%token NOT SUCC PRED ISZERO
%token LPAREN RPAREN
%token <string> IDENT
%token PLUS MINUS TIMES DIV
%token <string * Lexing.position> STRING
%token LET IN VAL END COLONEQUAL
%token EOF
%token EQ AND OR NE LE LT ME MT /*Ex21*/

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

/*Ex21*/
%right AND OR
%nonassoc EQ NE LT LE MT ME

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
*/

exp:
 | binexp { $1 }
 | subexp { $1 }
 ;

subexp:
  simple { $1 }
 | MINUS simple  { M.neg $2 }
 | NOT simple    { M.not $2 }
 | SUCC simple   { M.succ $2 }
 | PRED simple   { M.pred $2 }
 | ISZERO simple { M.is_zero $2 }
//  | subexp PLUS atom { M.add $1 $3 }
 | LET letblock  { $2 }
;

/*Ex21 e1 binop e2 => val tmp = e2 in binop(e1, tmp) */
binexp:
 | binexp EQ binexp     { M.local("tmp", $3) (M.equal $1 (M.var "tmp")) } 
 | binexp NE binexp     { M.local("tmp", $3) (M.ne $1 (M.var "tmp")) } 
 | binexp LT binexp     { M.local("tmp", $3) (M.lt $1 (M.var "tmp")) } 
 | binexp LE binexp     { M.local("tmp", $3) (M.le $1 (M.var "tmp")) } 
 | binexp MT binexp     { M.local("tmp", $3) (M.mt $1 (M.var "tmp")) } 
 | binexp ME binexp     { M.local("tmp", $3) (M.me $1 (M.var "tmp")) } 
 | binexp PLUS binexp   { M.local("tmp", $3) (M.add $1 (M.var "tmp")) } 
 | binexp MINUS binexp  { M.local("tmp", $3) (M.minus $1 (M.var "tmp")) } 
 | binexp TIMES binexp  { M.local("tmp", $3) (M.times $1 (M.var "tmp")) } 
 | binexp DIV binexp    { M.local("tmp", $3) (M.div $1 (M.var "tmp")) } 
 | subexp { $1 }
;

simple:
   atom { M.atomic $1 }
 | LPAREN exp RPAREN      { $2 }
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
