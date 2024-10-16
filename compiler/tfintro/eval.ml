(* The evaluator of the language: meta-circular interpreter *)

(* The expressions of our language are interpreted as OCaml integers.
   Or: expressions are represented by OCaml integers.
 *)

type repr = int

let int x = x
let add   = (+)
