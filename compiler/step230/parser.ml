(* Simple recursive-descent parser of arithmetic expressions *)

(*
       a single integer variable x
       integer constants
       true and false booleans
       unary operations: -, succ, pred, not, is_zero
       parentheses
       binary operations: +

       exp    ::= unary | exp + atom
       unary  ::= simple | - simple | not simple | succ simple | pred simple 
       simple ::= atom | '(' exp ')'
       atom   ::= int | bool | x 

Parsing becomes a bit more challenging
*)

let string_of_token : Tokenizer.token -> string = function
  | Num s    -> Printf.sprintf "num '%s'" s
  | Alfnum s -> Printf.sprintf "alfnum '%s'" s
  | Other c  -> Printf.sprintf "other '%c'" c

let string_of_head : Tokenizer.token Seq.t -> string = fun s ->
   match Seq.uncons s with
   | None -> "EOF"
   | Some (x,_) -> string_of_token x

exception Parse of string
let parse_error : ('a, unit, string, 'd) format4 -> 'a = fun fmt ->
  Printf.ksprintf (fun s -> raise (Parse s)) fmt

module type lang = module type of Lang with type obs = unit

(* Note: the structure of the parser
   reflects the grammar:
   each non-terminal corresponds to a function
   It uses the so-called continuation-passing style
   See how all calls in the body are tail calls
 *)

(* This is the parser from the previouys step! Not extended *)

let parse (ch:in_channel) (module M: lang) : unit =
  let open Tokenizer in
  let rec loop s = match Seq.uncons s with
  | None           -> parse_error "unexpected EOF"
  | Some (x,t)     -> match x with
    | Other '-'     -> loop t |> M.neg
    | Alfnum "succ" -> loop t |> M.succ
    | Alfnum "pred" -> loop t |> M.pred
    | Alfnum "not"  -> loop t |> M.not
    | Alfnum "is_zero"  -> loop t |> M.is_zero
    | Alfnum "x"    -> if Seq.is_empty t then M.varx 
                       else parse_error "junk after x"
    | Alfnum "true"  -> if Seq.is_empty t then M.bool true
                       else parse_error "junk after true"
    | Alfnum "false"  -> if Seq.is_empty t then M.bool false
                       else parse_error "junk after false"
    | Num d         -> if Seq.is_empty t then Int64.of_string d |> M.int
                       else parse_error "junk after num"
    | t             -> parse_error "unexpected: %s" (string_of_token t)
  in
  seq_of_channel ch |> tokenizer |> loop |> M.observe


