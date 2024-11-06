(* Simple recursive-descent parser of arithmetic expressions 
   This modules contains parser2 from parsing_intro.ml
   But arranged as a separate module
*)

(*
       a single integer variable x
       integer (signed) constants
       unary operations: -, succ, pred

       exp  ::= int | x | - exp | succ exp | pred exp
*)


let string_of_token : Tokenizer.token -> string = function
  | Num s    -> Printf.sprintf "num '%s'" s
  | Alfnum s -> Printf.sprintf "alfnum '%s'" s
  | Other c  -> Printf.sprintf "other '%c'" c

exception Parse of string
let raise_parse (s:string) : 'a = raise (Parse s)

module type lang = module type of Lang with type obs = unit

(* It is like parser2 from parsing_intro.ml (with swapped arguments),
   with a bit of polish.
 The parser particularly well matches the railroad diagram 
*)

let parse (ch:in_channel) (module M: lang) : unit =
  let open Tokenizer in
  let rec loop s = match Seq.uncons s with
  | None           -> raise_parse "unexpected EOF"
  | Some (x,t)     -> match x with
    | Other '-'     -> loop t |> M.neg
    | Alfnum "succ" -> loop t |> M.succ
    | Alfnum "pred" -> loop t |> M.pred
    | Alfnum "x"    -> if Seq.is_empty t then M.varx 
                       else raise_parse "junk after x"
    | Num d         -> if Seq.is_empty t then Int64.of_string d |> M.int
                       else raise_parse "junk after num"

    (* Ex 5 *)
    | Alfnum "true" -> if Seq.is_empty t then true |> M.bool
                       else raise_parse "junk after true"
    | Alfnum "false" -> if Seq.is_empty t then false |> M.bool
                       else raise_parse "junk after false"
    | Alfnum "is_zero" -> loop t |> M.is_zero
    | Alfnum "not" -> loop t |> M.not

    | t             -> Printf.kprintf raise_parse 
                       "unexpected: %s" (string_of_token t)
    
  in
  seq_of_channel ch |> tokenizer |> loop |> M.observe
