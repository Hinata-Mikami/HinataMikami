(* Main driver of the compiler. Parses options and invokes various phases *)

let usage_msg = {q|
 tigerc <options> filename.tg
 Only one file name is supported at present
 Options are as follows.|q}

let dump_parsetree = ref false
let dump_asm = ref false
let source_file = ref ""
let base_file_name = ref ""
let output_file_name = ref ""

let spec = Arg.[
  ("--dump-parse", Set dump_parsetree,
   "Dump the parse tree on the standard output");
  ("--dump-asm", Set dump_asm,
   "Dump the generated assembly on the standard output");
  ("-o", Set_string output_file_name, "Set output file name");
  ]

(* Build the final executable *)
exception Build_error of string

let build (asmfile : Util.fname) : unit =
  Filename.quote_command "gcc" 
    ((if !output_file_name = "" then [] else ["-o"; !output_file_name]) @ 
     [asmfile; Config.in_build "init.o"])
  |> Sys.command |> fun rc -> if rc <> 0 then 
      Build_error "assembly or linking error" |> raise else Sys.remove asmfile


let init_further (ch:in_channel) : unit =
  let lexbuf = Lexing.from_channel ch in
  Parser.parse Lexer.token lexbuf @@
  if !dump_parsetree then
    (module struct 
      include Pp_ast
      type obs = unit
      let observe = observe >> print_endline
    end)
  else
    (module struct 
      include Compiler
      type obs = unit
      let observe instr = 
        if !dump_asm then Compiler.observe instr stdout 
        else
          let (asmfile, ch) = Filename.open_temp_file "ti" ".s" in
          Compiler.observe instr ch;
          close_out ch;
          build asmfile
    end)


let init () : int =
  if !source_file = "" then begin
      print_endline "No input file";
      Arg.usage spec usage_msg;
      4
  end else
  Util.with_input_file !source_file @@ fun ch ->
    try init_further ch; 0 with
      e -> (Printexc.to_string e |> print_endline; 2)

let main () : unit = 
  let open Arg in
  let fname_proc str =
    if !source_file <> "" then raise (Bad "only one file name is allowed");
    if not (Filename.check_suffix str ".tg") then 
      raise (Bad "the source file should have the suffix .tg");
    source_file := str;
    base_file_name := Filename.remove_extension str
  in
  Arg.parse spec fname_proc usage_msg;
  init () |> exit

let _ = main ()
