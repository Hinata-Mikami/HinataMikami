(* Pre-defined global functions: the Standard Library, or, Prelude *)

module Ty = Types

(* The first element is the Tiger's function name
   The second is the link name, which may differ from the target name
   The third element is the type
*)
let global_fns : (Lang.vname * (Asm.symbol * Ty.function_t)) list = [
  ("read_int",    (Asm.name "read_int",     ([],Ty.int)));
  ("print_int",   (Asm.name "print_int",    ([Ty.int],Ty.void)));
]
