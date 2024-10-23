(* Main driver of the compiler, which puts everything together *)

let usage_msg = {q|
 tigerc filename.tg
 Only one file name is supported at present
 Options are as follows.|q}

(* Build the final executable *)
exception Build_error of string

let build (asmfile : Util.fname) : unit =
  Filename.quote_command "gcc" ["-o"; Config.in_build "a.out";
                                asmfile; Config.in_build "init.o"]
  |> Sys.command |> fun rc -> if rc <> 0 then 
      Build_error "linking error" |> raise else Sys.remove asmfile

let init_further (ich:in_channel) : unit =
  let (asmfile, och) = Filename.open_temp_file "ti" ".s" in
  Compiler.compile ich och;
  close_out och;
  build asmfile

let init (source: Util.fname) : unit =
  Util.with_input_file source @@ fun ch ->
    try init_further ch with
      e -> (Printexc.to_string e |> print_endline; exit 2)

let main () : unit = 
  if Array.length Sys.argv <> 2 then begin
      Printf.printf "One argument is needed: the file name\n%s"
      usage_msg;
      exit 4
    end;
  init Sys.argv.(1)

let _ = main ()
