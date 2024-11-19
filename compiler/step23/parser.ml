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

(* Looks like a function 'a -> 'w, somewhat *)
type ('a,'w) cont = Tokenizer.token Seq.t ->
   (Tokenizer.token Seq.t -> 'a -> 'w) -> 'w

let parse (ch:in_channel) (module M: lang) : unit =
  let open Tokenizer in
  (* Note how it closely follows the railway diagram *)
  let rec exp : (M.repr,'w) cont = fun s k -> 
    unary_opt s @@ fun s unary_f ->
      simple s @@ fun s simple_exp ->
        binary (unary_f simple_exp) s k
  and unary_opt : (M.repr->M.repr,'w) cont = fun s k ->
    match Seq.uncons s with
    | Some (Other '-',t)        -> k t M.neg
    | Some (Alfnum "succ",t)    -> k t M.succ
    | Some (Alfnum "pred",t)    -> k t M.pred
    | Some (Alfnum "not",t)     -> k t M.not
    | Some (Alfnum "is_zero",t) -> k t M.is_zero
    | _                         -> k s Fun.id
  (* should be atom_or_paren_exp, but this is too long a name *)
  and simple : (M.repr,'w) cont = fun s k -> 
    match Seq.uncons s with
    | Some (Other '(',t)   ->
        begin exp t @@ fun s x ->
        match Seq.uncons s with
        | Some (Other ')',t) -> k t x
        | _    -> parse_error 
                  "expected closing paren but received %s" (string_of_head s)
        end
    | _    -> atom s (fun s x -> k s (M.atomic x))
  and binary : M.repr -> (M.repr,'w) cont = fun arg1 s k ->
    match Seq.uncons s with
    | Some (Other '+',t) -> atom t (fun s x -> binary (M.add arg1 x) s k)
    | _ -> k s arg1
  and atom : (M.atom,'w) cont = fun s k -> match Seq.uncons s with
  | Some (Alfnum "x",t)      -> M.varx |> k t 
  | Some (Alfnum "true",t)   -> M.bool true |> k t
  | Some (Alfnum "false",t)  -> M.bool false |> k t
  | Some (Num d,t)           -> Int64.of_string d |> M.int |> k t
  | _                        -> parse_error
                                "unexpected atom: %s" (string_of_head s)
  and terminate : token Seq.t -> M.repr -> M.obs = fun s x ->
    if Seq.is_empty s then M.observe x else
    parse_error "junk at the end %s" (string_of_head s)
  in
  seq_of_channel ch |> tokenizer |> (fun s -> exp s terminate)
