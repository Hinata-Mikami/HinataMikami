#!/bin/env -S ocaml

(* Build *)

#directory "../util"
#load "unix.cma"
#load_rec "build.cmo"
open Build

(* Order matters! This is the link order, which is also the build order *)

let compiler_manifest = build_all [
  existent "../util/util.cmo";
  ocaml "lang.mli";
  ocaml "pp_ast.ml";
  ocaml "tokenizer.ml";
  ocaml "parser.ml";
  ocaml "driver.ml";
 ]

let tests = test [
  "test_script.ml";
  ]

let tigerc = link ~out:"tigerc" compiler_manifest

(* The first target is the default *)
let targets = [
  ("tigerc", Rules [tigerc]);
  ("test",   Rules [tigerc;tests]);
  ("parsing_intro", Rules [test ["parsing_intro.ml"]]);
  ]
  @ Build.targets

let () = main targets

