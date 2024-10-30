(* A story about parsing *)

(* Recall our Tagless-Final introduction 
   The language we are dealing now is quite similar to the one
   we used back then.
   But now we try to build its expressions by parsing.
*)

(* First, define the language *)

module type Lang = sig
  type repr                               (* representation type *)

  val int  : Int64.t -> repr

  val varx : repr

  val neg  : repr -> repr
  val succ : repr -> repr
  val pred : repr -> repr

  val observe : repr -> unit 
end

(* A simplest interpreter. It does not reveal what repr actually is.
   Therefore, may could later change it to be more than string
   (for a prettier printing).
 *)

module LangString : Lang = struct
  type repr = string

  let int  : Int64.t -> repr = Int64.to_string

  let varx : repr = "x"

  let neg  : repr -> repr = fun p -> "-" ^ p
  let succ : repr -> repr = fun p -> "succ" ^ p
  let pred : repr -> repr = fun p -> "pred" ^ p

  let observe : repr -> unit = print_endline
end

let () = 
  let open LangString in
  let r = neg (neg varx) in
  observe r

  

(* A bit of error handling *)
exception Parse of string
let raise_parse (s:string) : 'a = raise (Parse s)

(* The first parser 
   Look at the grammar: it has choices (for the train to go)
   If we look at the input string such as
     - succ 1
   Can we infer the path the train must have taken?
   Yes, we can: look at the choices. Each starts with a different character.
   So, by looking at the current character we can tell right away which
   turn to take.
*)


let parser1 (module I:Lang) (ic: in_channel) : unit =
  let getc () = In_channel.input_char ic in
  let rec loop () = match getc () with
  | Some '-' -> loop () |> I.neg
  | Some 's' -> check "ucc"; loop () |> I.succ
  | Some 'p' -> check "red"; loop () |> I.pred
  | Some 'x' -> if getc () <> None then raise_parse "junk after x";
                I.varx
  | Some ('0'..'9' as d) -> digit_to_int d |> read_num |> I.int
  | Some x -> Printf.kprintf raise_parse "bad char: %c" x
  | None   -> raise_parse "unexpected EOF"
 and
  check : string -> unit = 
    String.iter (fun c -> if Some c <> getc () then
      raise_parse "unexpected char")
 and
  digit_to_int (d:char) : Int64.t = Char.(code d - code '0') |> Int64.of_int
 and
  read_num (accum: Int64.t) = match getc () with
  | Some ('0'..'9' as d) ->
      Int64.(add (mul accum 10L) (digit_to_int d)) |> read_num
  | None   -> accum
  | Some _ -> raise_parse "not a digit"
  in
  loop () |> I.observe
;;

(* To see the result of parsing, let's define a pretty-printing
   interpreter. It is a bit more informative than LangString.

  It is again very similar to the ones used in ../tfintro
*)
module Pp : Lang = struct
  type repr = string                               (* representation type *)

  let int  : Int64.t -> repr = Int64.to_string

  let varx : repr = "x"

  (* utilities *)
  let paren (x:string) : string = "(" ^ x ^ ")"
  let prepend (pref:string) (s:string) : string = pref ^ s
  let (>>) f g = fun x -> f x |> g

  let neg  : repr -> repr = prepend "neg "  >> paren
  let succ : repr -> repr = prepend "succ " >> paren
  let pred : repr -> repr = prepend "pred " >> paren

  let observe : repr -> unit = print_endline
end

(* A simple testing framework, to feed the input *)
#directory "../util"
#load "util.cmo"

let with_channel_of_string : string -> (in_channel -> 'a) -> 'a =
  fun src consumer ->
    let (inp_file,och) = Filename.open_temp_file "ts" ".tg" in
    output_string och src; close_out och;
    let res = Util.with_input_file inp_file consumer in
    Sys.remove inp_file;
    res

let _ = with_channel_of_string "x" @@ parser1 (module Pp)

let _ = with_channel_of_string "-x" @@ parser1 (module Pp)

let _ = with_channel_of_string "123" @@ parser1 (module Pp)

let _ = with_channel_of_string "zzz" @@ parser1 (module Pp)

(*
Int64.max_int;;
*)

let _ = with_channel_of_string "9223372036854775807" @@ parser1 (module Pp)

(* so far, so good. *)

(* Bug! Should have reported an error! 
   We shall deal with it soon.
*)
let _ = with_channel_of_string "92233720368547758070" @@ parser1 (module Pp)

(* And also: *)
let _ = with_channel_of_string "succpred-x" @@ parser1 (module Pp)

(* No leading *)
let _ = with_channel_of_string " x" @@ parser1 (module Pp)
(* Or intermediary spaces are allowed *)
let _ = with_channel_of_string "- x" @@ parser1 (module Pp)

(* The railroad grammar was not actually bad. Simply, it was a grammar
   over a string of tokens!
*)

(* The second parser: based on tokens. First, we need a tokenizer *)
#directory "Build"
#load "tokenizer.cmo"
open Tokenizer

(* Let's check how it works, by printing the stream of token *)
let print_tokens (ic: in_channel) : unit =
  seq_of_channel ic |> tokenizer |> Seq.iter (function
  | Other c  -> Printf.printf "Other: %c\n" c
  | Num s    -> Printf.printf "Numeric: %s\n" s
  | Alfnum s -> Printf.printf "Alpha-Numeric: %s\n" s)

let _ = with_channel_of_string "" print_tokens

let _ = with_channel_of_string "123xxx" print_tokens

let _ = with_channel_of_string "0-1+x" print_tokens

let _ = with_channel_of_string " 0 - 1\n+x " print_tokens

let _ = with_channel_of_string "123_xx_x" print_tokens

(* Is this simple! *)
let parser2 (module I:Lang) (ic: in_channel) : unit =
  let rec loop s = match Seq.uncons s with
  | Some (Other '-',t)     -> loop t |> I.neg
  | Some (Alfnum "succ",t) -> loop t |> I.succ
  | Some (Alfnum "pred",t) -> loop t |> I.pred
  | Some (Alfnum "x",t)    -> if Seq.is_empty t then I.varx else
                               raise_parse "junk after x"
  | Some (Num d,t)         -> if Seq.is_empty t
                              then Int64.of_string d |> I.int
                              else raise_parse "junk after num"
  | Some (Alfnum x,_)      -> Printf.kprintf raise_parse "bad token: %s" x
  (* try to omit the next line, and see what happens *)
  | Some (Other x,_)       -> Printf.kprintf raise_parse "bad char: %c" x
  | None           -> raise_parse "unexpected EOF"
  in
  seq_of_channel ic |> tokenizer |> loop |> I.observe

(* The old tests *)
let _ = with_channel_of_string "x" @@ parser2 (module Pp)

let _ = with_channel_of_string "-x" @@ parser2 (module Pp)

let _ = with_channel_of_string "123" @@ parser2 (module Pp)

let _ = with_channel_of_string "zzz" @@ parser2 (module Pp)

(* Older problems are now taken care of *)
let _ = with_channel_of_string "123 4" @@ parser2 (module Pp)

let _ = with_channel_of_string "123xxx" @@ parser2 (module Pp)

(*
Int64.max_int;;
*)

let _ = with_channel_of_string "9223372036854775807" @@ parser2 (module Pp)

(* so far, so good. *)

(* The bug is now fixed
*)
let _ = with_channel_of_string "92233720368547758070" @@ parser2 (module Pp)

(* And also: *)
let _ = with_channel_of_string "succpred-x" @@ parser2 (module Pp)

(* leading *)
let _ = with_channel_of_string " x" @@ parser2 (module Pp)
(* Or intermediary spaces are now allowed *)
let _ = with_channel_of_string "- x" @@ parser2 (module Pp)

let _ = with_channel_of_string "succ pred - x " @@ parser2 (module Pp)

let () = print_endline "All Done"

;;
