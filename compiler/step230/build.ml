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
  ocaml "../step22/tokenizer.ml";
  ocaml "parser.ml";
 (*
  ocaml "../step20/asm.mli" ~rename:"asm_20";
  ocaml "asm.mli";
  ocaml "../step20/asm.ml" ~rename:"asm_impl_20";
  ocaml "asm.ml";
  ocaml "../step20/compiler.ml" ~rename:"code_gen_20";
  ocaml "code_gen.ml";
  ocaml "compiler.ml";
  *)
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
  ]
  @ Build.targets

let () = main targets

