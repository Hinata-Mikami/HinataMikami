(* Tokenizer, or lexer *)

(* What is token (for now): a (maximal) sequence of alphanumerics
   starting with a letter; 
   a sequence of digits;  punctuation

  They are separated by spaces, other non-alphanumeric characters
  All whitespace is used only for separating tokens, and otherwise ignored
*)

open Util

type token =
  | Num    of string                    (* string of digits *)
  | Alfnum of string                    (* string of alphanumerics,
                                           starting with a letter *)
  | Other  of char                       (* Some other character *)

(* We use streams (of characters) and build streams (of tokens) 
   What is a stream?
   Stdlib.Seq is a good implementation of streams.
*)

(* To explain how it works, use
   succ-  56
   as an example
 *)
let tokenizer : char Seq.t -> token Seq.t = fun cs ->
  let open Seq in
  let open struct
    type sort = Digit | Alpha | WhiteSpace | Othr
    let char_sort : char -> sort = function
      | '0' .. '9' -> Digit
      | 'A' .. 'Z' -> Alpha
      | 'a' .. 'z' -> Alpha
      | '_' -> Alpha
      | ' ' | '\n' | '\t' -> WhiteSpace
      | _ -> Othr
  end in
  cs 
  |> group (fun c1 c2 -> match (char_sort c1, char_sort c2) with
    | (Digit,Alpha) | (Alpha,Digit) -> true
    | (x,y) -> x = y)
  |> map (fun cs -> match uncons cs with
    | None -> empty
    | Some (c,t) -> match char_sort c with
      | Alpha      -> Alfnum (String.of_seq cs) |> return
      | WhiteSpace -> empty
      | Digit -> if for_all (fun c -> char_sort c = Digit) t
                 then Num (String.of_seq cs) |> return
                 else fail "starts with digit but contains non-digit: %s"
            (String.of_seq cs)
      | Othr -> map (fun c -> Other c) cs)
  |> concat 

let seq_of_channel : in_channel -> char Seq.t = fun ch ->
  Seq.of_dispenser (fun () -> In_channel.input_char ch) |> Seq.memoize

