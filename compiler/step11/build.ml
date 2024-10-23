#!/bin/env -S ocaml

(* Build *)

#directory "../util"
#load "unix.cma"
#load_rec "build.cmo"
open Build

(* Order matters! This is the link order, which is also the build order *)

let compiler_manifest = build_all [
  existent "../util/util.cmo";
  ocaml "config.ml";
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
  ("test",   Rules [tigerc;runtime_manifest;tests]);
  ("prog_int0", Shell 
	"gcc -o Build/prog_int0 -W -Wall int0.c && Build/prog_int0");
  (* testing clean_int.s (For Unix/Linux/WSL) *)
  ("prog_int", Shell 
	"gcc -o Build/prog_int -W -Wall init.c clean_int.s && Build/prog_int");
  (* testing clean_int_mac.s (For Mac) *)
  ("prog_int_mac", Shell 
	("gcc -o Build/prog_int_mac -W -Wall init.c clean_int_mac.s" ^
        "&& Build/prog_int_mac"));
  ("comp_compiler", Rules [ ocaml "asm.mli"; ocaml "compiler.ml" ]);
  ]
  @ Build.targets

let () = main targets

