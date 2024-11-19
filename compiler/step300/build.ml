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
  (*
  ocaml "../step21/sq.mli";
  ocaml "../step21/sq.ml"; 
  ocaml "../step23/types.mli";
  ocaml "../step23/types.ml";
 *)
  ocaml "../step20/lang.mli" ~rename:"lang_20";
  ocaml "../step22/lang.mli" ~rename:"lang_22";
  ocaml "../step23/lang.mli" ~rename:"lang_23"; 
  ocaml "lang.mli"; (* Ex 12 *)
  ocaml "../step20/pp_ast.ml" ~rename:"pp_ast_20";
  ocaml "../step22/pp_ast.ml" ~rename:"pp_ast_22";
  ocaml "../step23/pp_ast.ml" ~rename:"pp_ast_23";
  ocaml "pp_ast.ml"; (* Ex 12 *)
  ocamlyacc "parser.mly";
  ocamllex "lexer.mll";
  (*
  ocaml "../step21/asm.mli" ~rename:"asm_21";
  ocaml "../step22/asm.mli";
  ocaml "../step21/asm.ml" ~rename:"asm_impl_21";
  ocaml "../step22/asm.ml";
  ocaml "../step21/compiler.ml" ~rename:"code_gen_21";
  ocaml "../step22/code_gen.ml" ~rename:"code_gen_22";
  ocaml "../step23/code_gen.ml";
  ocaml "../step23/compiler.ml";
  *)


  ocaml "driver.ml";
 ]

let runtime_manifest = build_all [
  cc "../step22/init.c";
 ]

let tests = test [
  "test_script_24.ml";
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

