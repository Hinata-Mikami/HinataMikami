{
  open Parser

  exception Error of string
}

let digit = ['0'-'9']
let space = ' ' | '\t' | '\r' | '\n'
let alpha = ['a'-'z' 'A'-'Z' '_' ] 
let ident = alpha (alpha | digit)* 

rule token = parse
| space+      { token lexbuf }
| "let"       { LET }
| "in"        { IN  }
| "true"      { TRUE } 
| "false"     { FALSE }
| "if"        { IF }
| "then"      { THEN }
| "else"      { ELSE }
| "="         { EQ }
| "<"         { LT }
| '+'         { ADD }
| '-'         { SUB }
| '*'         { MUL}
| '/'         { DIV }
| '('         { LPAR }
| ')'         { RPAR }
| "fun"       { FUN }
| "->"        { ARROW }
| "rec"       { REC }
(*2-3*)
| "match"     { MATCH }
| "with"      { WITH }
| '|'         { OR }
| '_'         { WILD }
| "end"       { END } 
(*2-4*)
| ','         { COMMA }
| '['         { LBPAR }
| ']'         { RBPAR }
| "::"        { CONS }
(*2-5*)
| "and"       { AND }
| digit+ as n { INT (int_of_string n) }
| ident  as n { ID n }
| ";;"        { DSC } (*Double Semi-Colon*)
| ";"         { SSC } (*Single Semi-Colon*) (*2-4*)
| eof         { exit 0 }
| _           { raise (Error ("Unknown Token: " ^ Lexing.lexeme lexbuf))}
