(* Another interpreter of our language: pretty-printer
   It interprets the expressions of the language as strings
*)

type repr = string

let int = string_of_int
let add x y = "(" ^ x ^ " + " ^ y ^ ")"

(*Exercise 1*)
let sub x y = "(" ^ x ^ " - " ^ y ^ ")"