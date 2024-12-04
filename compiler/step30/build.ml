#!/bin/env -S ocaml

(* Build *)

#directory "../util"
#load "unix.cma"
#load_rec "build.cmo"
open Build

(* Order matters! This is the link order, which is also the build order *)

(* It is parameterized by the file name of the particular pretty-printer *)
let compiler_manifest pp_fname = build_all [
  existent "../util/util.cmo";
  ocaml "../step21/config.ml";
 (*
  ocaml "../step21/sq.mli";
  ocaml "../step21/sq.ml";
  ocaml "../step23/types.mli";
  ocaml "../step23/types.ml";
 *)
  ocaml "../step300/lang.mli";
  ocaml "../step20/pp_ast.ml" ~rename:"pp_ast_20";
  ocaml "../step22/pp_ast.ml" ~rename:"pp_ast_22";
  ocaml "../step23/pp_ast.ml" ~rename:"pp_ast_23";
  ocaml "../step300/pp_ast.ml" ~rename:"pp_ast_ns";
  ocaml pp_fname ~rename:"pp_ast";
  ocamlyacc "parser.mly";
  ocamllex  "lexer.mll";
 (*
  ocaml "../step21/asm.mli" ~rename:"asm_21";
  ocaml "../step22/asm.mli";
  ocaml "../step21/asm.ml" ~rename:"asm_impl_21";
  ocaml "../step22/asm.ml";
  ocaml "../step21/compiler.ml" ~rename:"code_gen_21";
  ocaml "../step22/code_gen.ml" ~rename:"code_gen_22";
  ocaml "code_gen.ml";
  ocaml "compiler.ml";
 *)  
  ocaml "../step300/driver.ml";
 ]

let runtime_manifest = build_all [
  cc "../step22/init.c";
 ]

let tests = test [
  "test_script_21.ml";
  "test_script_22.ml";
  "../step300/test_script_24.ml";
  "test_script.ml";
  ]

let tigerc pp_fname = link ~out:"tigerc" (compiler_manifest pp_fname)

(* The first target is the default *)
let targets = [
  ("tigerc-env", Rules [tigerc "pp_ast_env.ml";(*runtime_manifest*)]);
  ("tigerc-qna", Rules [tigerc "pp_ast_qna.ml";(*runtime_manifest*)]);
  ("test",   Rules [tests]);
  ]
  @ Build.targets

let () = main targets

