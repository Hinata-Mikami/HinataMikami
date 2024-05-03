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
| digit+ as n { INT (int_of_string n) }
| ident  as n { ID n }
| ";;"        { DSC } (*Double Semi-Colon*)
| eof         { exit 0 } (*https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/class/isle4-09w/text.pdf*)
| _           { raise (Error ("Unknown Token: " ^ Lexing.lexeme lexbuf))}
