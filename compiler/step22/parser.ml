(* Simple recursive-descent parser of arithmetic expressions 
   This modules contains parser2 from parsing_intro.ml
   But arranged as a separate module
*)

(*
       a single integer variable x
       integer (signed) constants
       booleans
       unary operations: -, succ, pred, not, is_zero

       exp  ::= int | x | true | false | 
               - exp | succ exp | pred exp | not exp | is_zero exp
*)


let string_of_token : Tokenizer.token -> string = function
  | Num s    -> Printf.sprintf "num '%s'" s
  | Alfnum s -> Printf.sprintf "alfnum '%s'" s
  | Other c  -> Printf.sprintf "other '%c'" c

exception Parse of string
let parse_error : ('a, unit, string, 'd) format4 -> 'a = fun fmt ->
  Printf.ksprintf (fun s -> raise (Parse s)) fmt

module type lang = module type of Lang with type obs = unit

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

