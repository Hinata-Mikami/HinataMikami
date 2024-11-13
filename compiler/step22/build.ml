#!/bin/env -S ocaml

(* Build *)

#directory "../util"
#load "unix.cma"
#load_rec "build.cmo"
open Build

(* Order matters! This is the link order, which is also the build order *)

let compiler_manifest = build_all [
  existent "../util/util.cmo";
  ocaml "../step21/config.ml";
  ocaml "../step21/sq.mli";
  ocaml "../step21/sq.ml";
  ocaml "../step20/lang.mli" ~rename:"lang_20";
  ocaml "lang.mli";
  ocaml "../step20/pp_ast.ml" ~rename:"pp_ast_20";
  ocaml "pp_ast.ml";
  ocaml "tokenizer.ml";
  ocaml "parser.ml";
  ocaml "asm.mli";
  ocaml "asm.ml";
  ocaml "code_gen.ml";
  ocaml "compiler.ml";
  ocaml "../step21/driver.ml";
 ]

let runtime_manifest = build_all [
  cc "init.c";
 ]

let tests = test [
  "../step21/test_script.ml";
  "test_script.ml";
  ]

let tigerc = link ~out:"tigerc" compiler_manifest

(* The first target is the default *)
let targets = [
  ("tigerc", Rules [tigerc;runtime_manifest]);
  ("test",   Rules [tigerc;runtime_manifest;tests]);
  ]
  @ Build.targets

let () = main targets

