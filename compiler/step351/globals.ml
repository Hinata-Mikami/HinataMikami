(* Global functions *)

module Ty = Types

(* The first element is the Tiger's function name
   The second is the link name, which may differ from the target name
   The third element is the type
*)
(* Note that `random' conflicts with the C function of the same
   name but different type, so C compiler reports an error
   when #include <stdlib.h>
   To make life simpler, we use the external name ti_random
   Conveniently, the global_fns permits the link name to be
   different from the Tiger' name.
*)
let global_fns : (Lang.vname * (Asm.symbol * Ty.function_t)) list = [
  ("read_int",    (Asm.name "read_int",     ([],Ty.int)));
  ("print_int",   (Asm.name "print_int",    ([Ty.int],Ty.void)));
  ("read_bool",   (Asm.name "read_bool",    ([],    Ty.bool)));
  ("print_bool",  (Asm.name "print_bool",   ([Ty.bool],Ty.void)));
  ("print_line",  (Asm.name "print_line",   ([],    Ty.void)));
  ("print",       (Asm.name "print",        ([Ty.string],  Ty.void)));
  ("random",      (Asm.name "ti_random",    ([Ty.int;Ty.int], Ty.int)));
  ("seed",        (Asm.name "seed",         ([Ty.int],     Ty.void)));
  ("compare_tistrings", (Asm.name "compare_tistrings", ([Ty.string; Ty.string], Ty.bool)));
]
