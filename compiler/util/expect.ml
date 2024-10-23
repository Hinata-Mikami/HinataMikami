(* Main part of the testing framework: run the compiler and check its output *)

open Util

(* read some of the input and return it as a string *)
let read_all : in_channel -> string = 
  let buf_len = 1024 in
  let buf = Bytes.make buf_len '\000' in
  fun ch ->
  let rec loop i =
    let len = buf_len - i in
    let len' = input ch buf i len in
    if len' = 0 || len' = len then Bytes.sub_string buf 0 (i+len') 
    else loop (i+len')
  in loop 0

(* Run the command and return its output
   cmd is the list: the head is the command itself, followed by arguments,
   argv[1], argv1[2], etc.
 *)
let test_command (cmd:string list) : (string * (string * int)) =
  let open Unix in
  let ch =
    match cmd with
    | cmdfile::_ ->
        open_process_args_in cmdfile (Array.of_list cmd)
    | _ -> fail "test_command: empty command"
  in
  let result = read_all ch |> String.trim in
  let rc = match close_process_in ch with
  | WEXITED n | WSIGNALED n | WSTOPPED n -> n in
  (List.hd cmd, (result,rc))

(* The same but feed the given string to the stdin 
   This is not an interactive session
   It is assumed that the command first reads its input fully, and
   then replies
   (limited buffering, aroun 8K, is tolerated though)
*)
let test_command_stdin (sin:string) (cmd:string list) : (string*(string*int)) =
  let open Unix in
  let (ich,och) =
    match cmd with
    | cmdfile::_ ->
        open_process_args cmdfile (Array.of_list cmd)
    | _ -> fail "test_command: empty command"
  in
  output_string och sin; flush och;
  let result = read_all ich |> String.trim in
  let rc = match close_process (ich,och) with
  | WEXITED n | WSIGNALED n | WSTOPPED n -> n in
  (sin,(result,rc))

(* Run the command on the given input
  cmd accepts the input file name and returns the command and its arguments
  (the head of the list is the command itself, followed by arguments,
  argv[1], argv1[2], etc.)
 *)
let test_it (inp:string) (cmd:string->string list) : (string * (string * int)) =
  let (inp_file,och) = Filename.open_temp_file "ts" ".tg" in
  output_string och inp; close_out och;
  let (_,res) = test_command (cmd inp_file) in
  Sys.remove inp_file;
  (inp,res)


(* check the output meets the expectations. The default argument
   is a comparison procedure that received the expected and 
   and the actual output and tests them. By default, it is the string
   comparison.
 *)
let expect ?(comparator=((=) : string -> string -> bool))
    (expected: string) ((tested:string),((actual:string), (rc:int))) : unit =
  if rc <> 0 then begin
    Printf.printf 
      "The test\n%s\nfailed with the return code %d and the message\n%s\n"
      tested rc actual;
    failwith "Test failure"
   end;
  if comparator expected actual then () 
  else
    (Printf.printf
      "Expected output\n%s\n\n---but produced\n%s\n" expected actual;
     failwith "expect failed, see the message above")

(* Comparator for assembly code. Ignore .type and undescores
    when comparing
*)
let comparator_asm : string -> string -> bool = fun s1 s2 ->
  let open Seq in
  let rec compare_seq s1 s2 = match (s1 (),s2 ()) with
  | (Nil,Nil) -> true
  | (Cons (h1,t1), Cons (h2,t2)) -> h1 = h2 && compare_seq t1 t2
  | _ -> false
  in
  let rec skip_while_next pred s () = match s () with
    | Nil -> Nil
    | Cons (h,t) -> if pred h then skip_while_next pred t () else t ()
  in
  let rec is_prefix i str s = if i >= String.length str then true else
  match s () with 
  | Nil -> false
  | Cons (h,t) -> h = str.[i] && is_prefix (i+1) str t
  in
  let rec skip_type s () = match s () with
  | Nil -> Nil
  | Cons ('\t',t) when is_prefix 0 ".type" t -> skip_type (skip_while_next ((<>) '\n') t) ()
  | Cons (h,t) -> Cons (h,skip_type t)
  in
  let transf s = s |> String.to_seq |> filter ((<>) '_') |> skip_type in
  compare_seq (transf s1) (transf s2)

(* Expect a test that fails *)
let expect_fail ((tested:string),((actual:string), (rc:int))) : unit =
  if rc = 0 then
    Printf.kprintf failwith 
      "The test\n%s\nwas expected to fail but it succeded with\n%s\n" 
      tested actual
  else
    Printf.printf 
      "The test failed as expected, with the code %d and the output\n%s\n"
      rc actual



