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



(* Ex 9 *)
let parse (ch:in_channel) (module M: lang) : unit =
  let open Tokenizer in

  (* Parse <add> ::= "" | "+" <atom> | <add> <add> *)
  let rec parse_add seq expr =
    match Seq.uncons seq with
    | Some (Other '+', t) ->
        let (right_expr, remaining_seq) = parse_atom t in
        parse_add remaining_seq (M.add expr right_expr)
    | _ -> (expr, seq)

  (* Parse <atom> ::= <int> | <bool> | "x" *)
  and parse_atom seq =
    match Seq.uncons seq with
    | Some (Alfnum "true", t)  -> (M.bool true, t)
    | Some (Alfnum "false", t) -> (M.bool false, t)
    | Some (Alfnum "x", t)     -> (M.varx, t)
    | Some (Num d, t)          -> (M.int (Int64.of_string d), t)
    | _ -> parse_error "unexpected atom"

  (* Parse <unary> ::= "" | "-" <unary> | "not" <unary> | "succ" <unary> | "pred" <unary> | "is_zero" <unary> *)
  and parse_unary seq =
    match Seq.uncons seq with
    | Some (Other '-', t) ->
        let (unary_expr, remaining_seq) = parse_unary t in
        (M.neg unary_expr, remaining_seq)
    | Some (Alfnum "not", t) ->
        let (unary_expr, remaining_seq) = parse_unary t in
        (M.not unary_expr, remaining_seq)
    | Some (Alfnum "succ", t) ->
        let (unary_expr, remaining_seq) = parse_unary t in
        (M.succ unary_expr, remaining_seq)
    | Some (Alfnum "pred", t) ->
        let (unary_expr, remaining_seq) = parse_unary t in
        (M.pred unary_expr, remaining_seq)
    | Some (Alfnum "is_zero", t) ->
        let (unary_expr, remaining_seq) = parse_unary t in
        (M.is_zero unary_expr, remaining_seq)
    | Some (Other '(', t) ->
        let (inner_expr, remaining_seq) = parse_exp t in
        begin match Seq.uncons remaining_seq with
        | Some (Other ')', t') -> (inner_expr, t')
        | _ -> parse_error "missing closing parenthesis"
        end
    | _ -> parse_atom seq 

  (* Parse <exp> ::= <unary> <atom> <add> | <unary> "(" <exp> ")" <add> | <atom> <add> | "(" <exp> ")" <add> *)
  and parse_exp seq =
    let (expr, remaining_seq) = parse_unary seq in
    parse_add remaining_seq expr

  in
  let (parsed_expr, _) = seq_of_channel ch |> tokenizer |> parse_exp in
  M.observe parsed_expr





