#!/bin/env -S ocaml

(* Build *)

#directory "../util"
#load "unix.cma"
#load_rec "build.cmo"
open Build

(* Order matters! This is the link order, which is also the build order *)

let compiler_manifest = build_all [
  existent "../util/util.cmo";
  existent "../util/common.cmo";
  ocaml "../step21/config.ml";
  ocaml "../step31/hole.ml";
  ocaml "../step21/sq.mli";
  ocaml "../step21/sq.ml";
  ocaml "../step23/types.mli" ~rename:"types_23";
  ocaml "../step34/types.mli" ~rename:"types_34";
  ocaml "types.mli";
  ocaml "../step23/types.ml" ~rename:"types_impl_23";
  ocaml "../step34/types.ml" ~rename:"types_impl_34";
  ocaml "types.ml";
  ocaml "../step31/qna.ml";
  ocaml "../step300/lang.mli" ~rename:"lang_30";
  ocaml "../step32/lang.mli" ~rename:"lang_32";
  ocaml "../step33/lang.mli" ~rename:"lang_33";
  ocaml "../step34/lang.mli" ~rename:"lang_34";
  ocaml "lang.mli";
  ocaml "../step20/pp_ast.ml" ~rename:"pp_ast_20";
  ocaml "../step22/pp_ast.ml" ~rename:"pp_ast_22";
  ocaml "../step23/pp_ast.ml" ~rename:"pp_ast_23";
  ocaml "../step300/pp_ast.ml" ~rename:"pp_ast_30";
  ocaml "../step32/pp_ast.ml" ~rename:"pp_ast_32";
  ocaml "../step33/pp_ast.ml" ~rename:"pp_ast_33";
  ocaml "../step34/pp_ast.ml" ~rename:"pp_ast_34";
  ocaml "pp_ast.ml";
  ocamlyacc "parser.mly";
  ocamllex  "../step34/lexer.mll";
  ocaml "../step21/asm.mli" ~rename:"asm_21";
  ocaml "../step22/asm.mli" ~rename:"asm_22";
  ocaml "../step31/asm.mli" ~rename:"asm_31";
  ocaml "../step32/asm.mli" ~rename:"asm_32";
  ocaml "asm.mli";
  ocaml "../step21/asm.ml" ~rename:"asm_impl_21";
  ocaml "../step22/asm.ml" ~rename:"asm_impl_22";
  ocaml "../step31/asm.ml" ~rename:"asm_impl_31";
  ocaml "../step32/asm.ml" ~rename:"asm_impl_32";
  ocaml "asm.ml";
  ocaml "../step22/code_gen.ml" ~rename:"code_gen_22";
  ocaml "../step23/code_gen.ml" ~rename:"code_gen_23";
  ocaml "../step31/code_gen.ml" ~rename:"code_gen_31";
  ocaml "../step32/code_gen.ml" ~rename:"code_gen_32";
  ocaml "../step34/code_gen.ml" ~rename:"code_gen_34";
  ocaml "code_gen.ml";
  ocaml "globals.ml";
  ocaml "../step23/compiler.ml" ~rename:"compiler_23";
  ocaml "../step31/compiler.ml" ~rename:"compiler_31";
  ocaml "../step32/compiler.ml" ~rename:"compiler_32";
  ocaml "../step33/compiler.ml" ~rename:"compiler_33";
  ocaml "../step34/compiler.ml" ~rename:"compiler_34";
  ocaml "compiler.ml";
  ocaml "../step24/driver.ml";
 ]

let runtime_manifest = build_all [
  cc "init.c";
 ]

let tests = test [
 (*
  "../step32/test_script_21.ml";
  "../step31/test_script_22.ml";
  "test_script_24.ml";
  "../step31/test_script.ml";
  "test_script_32.ml";
 *)
  "../step34/test_script_33.ml";
  "../step34/test_script.ml";
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

