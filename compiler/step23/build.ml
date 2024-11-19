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
  ocaml "types.mli";
  ocaml "types.ml";
  ocaml "../step20/lang.mli" ~rename:"lang_20";
  ocaml "../step22/lang.mli" ~rename:"lang_22";
  ocaml "lang.mli";
  ocaml "../step20/pp_ast.ml" ~rename:"pp_ast_20";
  ocaml "../step22/pp_ast.ml" ~rename:"pp_ast_22";
  ocaml "pp_ast.ml";
  ocaml "../step22/tokenizer.ml";
  ocaml "parser.ml";
  ocaml "../step22/asm.mli";
  ocaml "../step22/asm.ml";
  ocaml "../step22/code_gen.ml" ~rename:"code_gen_22";
  ocaml "code_gen.ml";
  ocaml "compiler.ml";
  ocaml "../step21/driver.ml";
 ]

let runtime_manifest = build_all [
  cc "../step22/init.c";
 ]

let tests = test [
  "test_script_21.ml";
  "test_script_22.ml";
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

