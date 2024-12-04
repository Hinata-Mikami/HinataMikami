(* Lexer For Tiger'
   It is based on OCaml's lexer, parsing/lexer.mll

   It supports position-tracking and backslash-escapes in
   character ans string literals.

   The biggest difference from OCaml are comments, which are C++-style:
   // till the end of line
*)

(* Prelude: declarations, Utilities *)

{
open Lexing
open Parser

type error =
  | Illegal_character of char
  | Illegal_escape of string * string
  | Eol_in_string
  | Unterminated_string
  | Invalid_int64_literal of string

exception LexicalError of error * Lexing.position

(* The table of keywords *)

let keyword_table =
  Hashtbl.create 19 |> List.fold_right (fun (k,v) t -> Hashtbl.add t k v; t) [
    ("true",  TRUE);
    ("false", FALSE);
    ("succ",  SUCC);
    ("pred",  PRED);
    ("not",   NOT);
    ("is_zero",  ISZERO);

    ("let",  LET);
    ("in",   IN);
    ("end",  END);
    ("val",  VAL);
]

(* To buffer string literals *)

let string_buffer = Buffer.create 256
let reset_string_buffer () = Buffer.reset string_buffer
let get_stored_string () = Buffer.contents string_buffer

let store_string_char c = Buffer.add_char string_buffer c
let store_string s = Buffer.add_string string_buffer s

(* To store the position of the beginning of a string *)
let string_start_loc = ref Lexing.dummy_pos;;

let wrap_string_lexer f lexbuf =
  let loc_start = lexbuf.lex_curr_p in
  reset_string_buffer();
  let string_start = lexbuf.lex_start_p in
  string_start_loc := loc_start;
  let _ = f lexbuf in
  lexbuf.lex_start_p <- string_start;
  get_stored_string (), loc_start

let error lexbuf e = raise (LexicalError(e, lexbuf.lex_curr_p))
let error_loc loc e = raise (LexicalError(e, loc))

(* to translate escape sequences *)

let digit_value c =
  match c with
  | 'a' .. 'f' -> 10 + Char.code c - Char.code 'a'
  | 'A' .. 'F' -> 10 + Char.code c - Char.code 'A'
  | '0' .. '9' -> Char.code c - Char.code '0'
  | _ -> assert false

let num_value lexbuf ~base ~first ~last =
  let c = ref 0 in
  for i = first to last do
    let v = digit_value (Lexing.lexeme_char lexbuf i) in
    assert(v < base);
    c := (base * !c) + v
  done;
  !c

let char_for_backslash = function
  | 'n' -> '\010'
  | 'r' -> '\013'
  | 'b' -> '\008'
  | 't' -> '\009'
  | c   -> c

let illegal_escape lexbuf reason =
  error lexbuf (Illegal_escape (Lexing.lexeme lexbuf, reason))

let char_for_decimal_code lexbuf i =
  let c = num_value lexbuf ~base:10 ~first:i ~last:(i+2) in
  if (c < 0 || c > 255) then
      illegal_escape lexbuf
        (Printf.sprintf
          "%d is outside the range of legal characters (0-255)." c)
  else Char.chr c

(* Update the current location: increment line counter.
   The chars argument is for newlines in strings
   "string \
      continuation"
   to skip the leading whitespace in the continuation line
 *)

let update_loc lexbuf chars =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <- { pos with
    pos_lnum = pos.pos_lnum + 1;
    pos_bol = pos.pos_cnum - chars;
  }

}

(* Lexical classes *)

let newline   = ('\013'* '\010')
let blank     = [' ' '\009' '\012']
let lowercase = ['a'-'z' '_']
let uppercase = ['A'-'Z']
let identchar = ['A'-'Z' 'a'-'z' '_' '\'' '0'-'9']

let ident = (lowercase | uppercase) identchar*

let decimal_literal =
  ['0'-'9'] ['0'-'9' '_']*
let hex_digit =
  ['0'-'9' 'A'-'F' 'a'-'f']
let hex_literal =
  '0' ['x' 'X'] ['0'-'9' 'A'-'F' 'a'-'f']['0'-'9' 'A'-'F' 'a'-'f' '_']*
let oct_literal =
  '0' ['o' 'O'] ['0'-'7'] ['0'-'7' '_']*
let bin_literal =
  '0' ['b' 'B'] ['0'-'1'] ['0'-'1' '_']*
let int_literal =
  decimal_literal | hex_literal | oct_literal | bin_literal
let float_literal =
  ['0'-'9'] ['0'-'9' '_']*
  ('.' ['0'-'9' '_']* )?
  (['e' 'E'] ['+' '-']? ['0'-'9'] ['0'-'9' '_']* )?

(* Tokenizing rules *)

rule token = parse
  | ('\\' as bs) newline {
      error lexbuf (Illegal_character bs) }
  | newline
      { update_loc lexbuf 0;
        token lexbuf }
  | blank +
      { token lexbuf }
  | lowercase identchar * as name
      { try Hashtbl.find keyword_table name
        with Not_found -> IDENT name }
  | uppercase identchar * as name
      { IDENT name } (* No capitalized keywords *)
  | ("-"? int_literal) as lit { 
    match Int64.of_string lit with 
    | exception Failure reason -> error lexbuf (Invalid_int64_literal reason)
    | x -> INT x }
  | "\"" 
      { STRING (wrap_string_lexer string lexbuf) }
 (*
  | "\'" ([^ '\\' '\'' '\010' '\013'] as c) "\'"
      { CHAR c }
  | "\'\\" (['\\' '\'' '\"' 'n' 't' 'b' 'r' ' '] as c) "\'"
      { CHAR (char_for_backslash c) }
  | "\'\\" ['0'-'9'] ['0'-'9'] ['0'-'9'] "\'"
      { CHAR(char_for_decimal_code lexbuf 2) }
  | "\'" ("\\" _ as esc)
      { error lexbuf (Illegal_escape (esc, "in character literal")) }
 *)
  | "("  { LPAREN }
  | ")"  { RPAREN }
  | "+"  { PLUS }
  | "-"  { MINUS }
  | "*"  { TIMES }
  | "/"  { DIV }
  | ":=" { COLONEQUAL }
  | "//" [^ '\013' '\010'] * newline
      { update_loc lexbuf 0;
        token lexbuf }
  | eof { EOF }
  | (_ as illegal_char)
      { error lexbuf (Illegal_character illegal_char) }

and string = parse
    '\"'
      { lexbuf.lex_start_p }
  | '\\' newline ([' ' '\t'] * as space)
      { update_loc lexbuf (String.length space);
        string lexbuf
      }
  | '\\' (['\\' '\'' '\"' 'n' 't' 'b' 'r' ' '] as c)
      { store_string_char (char_for_backslash c);
        string lexbuf }
  | '\\' ['0'-'9'] ['0'-'9'] ['0'-'9']
      { store_string_char (char_for_decimal_code lexbuf 1);
         string lexbuf }
  | '\\' (_ as c)
      { error lexbuf (Illegal_escape (Char.escaped c, "in quoted string")) }
  | newline
      { error lexbuf Eol_in_string }
  | eof
      { error_loc !string_start_loc Unterminated_string }
  | (_ as c)
      { store_string_char c;
        string lexbuf }

(* Postlude *)

{
}
