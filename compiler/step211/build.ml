#!/bin/env -S ocaml

(* Build *)

#directory "../util"
#load "unix.cma"
#load_rec "build.cmo"
open Build

(* Order matters! This is the link order, which is also the build order *)
(* Ex7 *)
let compiler_manifest = build_all [
  existent "../util/util.cmo";
  ocaml "config.ml";
  ocaml "sq.mli";
  ocaml "sq.ml";
  ocaml "lang.mli";
  ocaml "pp_ast.ml";
  ocaml "tokenizer.ml";
  ocaml "parser.ml";
  ocaml "asm.mli";
  ocaml "asm.ml";
  ocaml "compiler.ml";
  ocaml "driver.ml";
 ]

let runtime_manifest = build_all [
  cc "init.c";
 ]

let tests = test [
  "test_script.ml";
  ]

let tigerc = link ~out:"tigerc" compiler_manifest

(* The first target is the default *)
let targets = [
  ("tigerc", Rules [tigerc;runtime_manifest]);
  ("test",   Rules [tigerc;tests]);
  ]
  @ Build.targets

let () = main targets

