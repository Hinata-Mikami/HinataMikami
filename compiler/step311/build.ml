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
  ocaml "hole.ml";
  ocaml "../step21/sq.mli";
  ocaml "../step21/sq.ml";
  ocaml "../step23/types.mli";
  ocaml "../step23/types.ml";
  ocaml "qna.ml";
  ocaml "../step300/lang.mli" ~rename:"Lang_300";
  ocaml "lang.mli";
  ocaml "../step20/pp_ast.ml" ~rename:"pp_ast_20";
  ocaml "../step22/pp_ast.ml" ~rename:"pp_ast_22";
  ocaml "../step23/pp_ast.ml" ~rename:"pp_ast_23";
  ocaml "../step300/pp_ast.ml"~rename:"pp_ast_300";
  ocaml "pp_ast.ml";
  (* Ex21 *)
  ocamlyacc "parser.mly";
  ocamllex  "lexer.mll";
  ocaml "../step22/asm.mli" ~rename:"asm_22";
  ocaml "asm.mli";
  ocaml "../step22/asm.ml" ~rename:"asm_impl_22";
  ocaml "asm.ml";
  ocaml "../step22/code_gen.ml" ~rename:"code_gen_22";
  ocaml "../step23/code_gen.ml" ~rename:"code_gen_23";
  ocaml "code_gen.ml";
  ocaml "../step23/compiler.ml" ~rename:"compiler_23";
  ocaml "compiler.ml";
  ocaml "../step24/driver.ml";
 ]

let runtime_manifest = build_all [
  cc "../step22/init.c";
 ]

let tests = test [
  "test_script_21.ml";
  "test_script_22.ml";
  "test_script_24.ml";
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

