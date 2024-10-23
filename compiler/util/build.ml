(* Build the project, including Tiger' project *)
(* This is a simple version of Make, but tuned to the Tiger' project 

  The particular characteristics of the Tiger' project that call for a custom
  make:

  -- since the compiler is built by extending the earlier code,
  the source code is spread through many steps. The code on step23
  may use the source code files in step21, step21, step20. That per
  se could be fixed with VPATH, but that makes it difficult to
  see where exactly the code is. It is much preferable to have the complete
  list of code files.

  -- some files from the previous steps have to be renamed before compiling.
  For example, step21/lang.mli should be renamed to lang_21.mli (because
  it would be included under that name in step22/lang.mli). Previously I
  resorted to symbolic links, which clutter the directory and are harder
  to maintain.

  -- since files are so spread out, automatic dependencies are difficult
  to maintain. Ocamldep does not help here. On the other hand, the build order
  of .cmo files (for the final executable) is the dependency. So, when the
  source files are compiled in the build order, everything works out well.
  (We need to also add .cmi files to the build manifest, to be removed
  before linking since they are not used in linking). Thus dependency
  is actually much simpler to maintain and does not need to be discovered.
  We hence assume consecutive (single-threaded) build and so lose 
  on parallelism.
  In our experience, the compilation is very fast (including the complete
  rebuild), so parallelism is not necessary. Even incremental builds aren't
  needed (at least, for the time being).

  The overall interface is like make:
    build <target> ...
*)

(* 
 For incremental builds: make a file in the build directory: .build_status
 (can be written by output_value).
 For each output file, record the modified timestamps and file lengths
 of each file used to build that output (perhaps just hash the stat structure,
 zeroing out the atime?)
 So, to rebuild, we only need to look through the current modified timestamps/
 lengths to see if any inputs changed. If so, needed to be rebuilt.
 We compare timestamps only for equality: not order! We essentially use
 timestamp as a hash of the input build state.
 *)

(*
#load "util.cmo"
#load "unix.cma"
*)
open Util

type fname = string

(* All build artifacts go into the builddir *)
let builddir = "Build"
let ocamlflags = ["-I"; "../util"]
let test_cmd fn = ["ocaml"; "-I"; "+unix"; "-I"; "../util"; "unix.cma";
                     "../util/util.cmo"; "../util/expect.cmo"; fn]


let in_build : fname -> fname = Filename.concat builddir
let mk_output_fname (basebase:fname) (ext:string) : fname =
   basebase ^ ext |> in_build

let within_build : (unit -> 'w) -> 'w = fun th ->
   Sys.chdir builddir;
   match th ()  with 
   | x -> Sys.chdir ".."; x
   | exception e  -> Sys.chdir ".."; raise e
   
(* The argument is the command itself (file name) followed by arguments 
   The command is looked up in the PATH, if needed.
*)
let do_command : string list -> unit = fun cmds ->
   List.iter (fun i -> prerr_string " "; prerr_string i) cmds;
   prerr_endline "";
   let (cmd,args) = match cmds with
   | [] -> fail "empty command"
   | cmd::_ -> (cmd, Array.of_list cmds)
   in
   let open Unix in
   let pid = fork () in
   if pid=0 then try execvp cmd args with _ -> _exit (127) 
   else match waitpid [] pid with
   | (_,WEXITED rc) ->
      if rc <> 0 then fail "command failed: return code %d" rc 
   | (_,WSIGNALED n) -> fail "command failed: signal %d" n
   | (_,WSTOPPED n) -> fail "command failed: stopped %d" n

let do_command_if (force:bool) : string list -> bool = fun cmds ->
   if force then do_command cmds; force

(* Check if fn was modified after fnref. If fnref does not exist,
   return true unconditionally
*)
let if_modified (fn:fname) (fnref:fname) : bool = 
   match (Unix.stat fnref).st_mtime with
   | tref ->  (Unix.stat fn).st_mtime >= tref
   | exception _    -> true

(* return the basename without extension, and the extension separately *)
let base_ext : fname -> fname * string = fun fn ->
   let open Filename in
   let base = basename fn in
   (remove_extension base, extension base)

(* Check the filename has the given extension, and return the basename
   without extension
*)
let check_ext : fname -> string -> fname = fun fn ext ->
   let (basebase,ext') = base_ext fn in
   if ext <> ext' then fail "expected extension %s in %s" ext fn else basebase


(* Each rule returns the file names it produces, plus a function that
   does the production and returns a boolean (false if the output is
   up to date). Its bool argument, if false, hints that it is enough
   to check if the output already exists and is up-to-date.
   If true, generate the output without any checks.
 *)

type rule = fname list * (bool -> bool)

let empty : rule = ([], Fun.id)

(* The file that should already be existing *)
let existent (inf:fname) : rule =
  if Sys.file_exists inf then
    ([inf], Fun.id)
  else fail "%s does not exist" inf

let cc (inf:fname) : rule =
  let basebase = check_ext inf ".c" in
  let output = mk_output_fname basebase ".o" in
  let command = ["gcc"; "-c"; "-Wall"; "-W"; "-o"; output; inf] in
  ([output], fun force ->
   do_command_if (force || if_modified inf output) command)


let ocaml ?(rename:fname option) (inf:fname) : rule =
  let (basebase,ext) = base_ext inf in
  let outext = 
    if ext = ".ml" then ".cmo" else
    if ext = ".mli" then ".cmi" else
    fail "expected suffix .ml or .mli in %s" inf in
  let renamed = Option.map (fun x -> mk_output_fname x ext) rename in
  let output = mk_output_fname (Option.value ~default:basebase rename) outext
  in
  let command = ["ocamlc"; "-c"; "-I"; builddir] @ ocamlflags @
                ["-o";output; (renamed |> Option.value ~default:inf)]
  in
  let exec force =
   let force =
   match renamed with
    | None -> force || if_modified inf output
    | Some newn when Sys.file_exists newn -> force || if_modified newn output
    | Some newn -> Unix.symlink (Unix.realpath inf) newn; true
   in
   do_command_if force command
  in ([output], exec)

let ocamlyacc (inf:fname) : rule =
  let basebase = check_ext inf ".mly" in
  let gen_ml = mk_output_fname basebase ".ml"  in
  let gen_mli = mk_output_fname basebase ".mli" in
  let (outputs,compile) = ocaml gen_ml in
  let command = ["ocamlyacc"; "-v"; "-b"^(in_build basebase); inf] in 
  let exec force =
   (if if_modified inf gen_ml then begin
      do_command command;
      (try Sys.remove gen_mli with _ -> ());
      true
   end else force) |> compile
  in (outputs, exec)

let ocamllex (inf:fname) : rule =
  let basebase = check_ext inf ".mll" in
  let gen_ml = mk_output_fname basebase ".ml" in
  let (outputs,compile) = ocaml gen_ml in
  let command = ["ocamllex"; "-o"; gen_ml; inf] in
  let exec force =
   (do_command_if (if_modified inf gen_ml) command || force) |> compile
  in (outputs, exec)


(* Coalesce a list of rules (taken in order) into a single rule 
   while chaining dependencies
   Don't build unless forced or previous rules fired
*)
let build_all : rule list -> rule = fun lst ->
  let outputs = List.map fst lst |> List.concat in
  let exec force =
    List.fold_left (fun force (_,action) -> action force || force) force lst
  in 
  (outputs,exec)


let link ~(out:fname) ((inputs,builder):rule) : rule =
  let inputs = List.filter (fun f -> Filename.check_suffix f ".cmo") inputs in
  let output = in_build out in
  let command = ["ocamlc"] @ ocamlflags @ ["-o"; output] @ inputs in
  ([output], fun force -> 
   do_command_if (builder force || (Fun.negate Sys.file_exists output))
      command)

let test (fns: fname list) : rule =
  let do_test fn = prerr_endline ("Testing " ^ fn);
                   do_command (test_cmd fn)
  in
  ([], fun _ -> List.iter do_test fns; true)

type target = 
  | Shell of string
  | Rules of rule list

let run_target : target -> unit = function
  | Shell cmd -> do_command ["sh";"-c"; cmd]
  | Rules rs -> Fun.flip List.iter rs @@ 
                fun (outputs,exec) ->
                  prerr_endline (String.concat " " ("Building"::outputs));
                  if exec false then () else
                     prerr_endline "Up to date"

type targets = (string * target) list

(* The first target is the default *)
let targets = [
  ("clean", Shell
     (String.concat " " [
      "rm -f"; "*.cm[ixoa]"; "*.cmxa"; "*.[oa]"; "a.out"; "parser.output";
      Filename.concat builddir "*"])
     )
]
 

let main (targets:targets) : unit = 
  if Array.length Sys.argv = 1 then 
    match targets with
    | (_,t)::_ -> run_target t
    | _ -> failwith "No targets given"
  else
    Fun.flip Array.iteri Sys.argv @@
    fun i n -> if i > 0 then match List.assoc n targets with
    | t -> run_target t
    | exception Not_found -> Printf.kprintf failwith "No such target %s" n

