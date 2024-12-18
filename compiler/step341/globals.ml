(* Pre-defined global functions: the Standard Library, or, Prelude *)

module Ty = Types

(* The first element is the Tiger's function name
   The second is the link name, which may differ from the target name
   The third element is the type
*)
let global_fns : (Lang.vname * (Asm.symbol * Ty.function_t)) list = [
  ("read_int",    (Asm.name "read_int",     ([],Ty.int)));
  ("print_int",   (Asm.name "print_int",    ([Ty.int],Ty.void)));
  (*Ex 24*)
  ("read_bool",   (Asm.name "read_bool",    ([],Ty.bool)));
  ("print_bool",  (Asm.name "print_bool",   ([Ty.bool],Ty.void)));
  ("print_line",  (Asm.name "print_line",   ([],Ty.void)));
  ("rnd",         (Asm.name "rnd",          ([Ty.int; Ty.int],Ty.int)));
  ("rnd_seed",    (Asm.name "rnd_seed",     ([Ty.int],Ty.void)));
  ]
