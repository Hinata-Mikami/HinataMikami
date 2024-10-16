(* Script defining a DSL and its interpreters
   See course notes for the explanation
*)

(* Language: integers and addition, to be called Lang

   Sample expressions:
   4
   0
   -1
   (4 + 0)
   ((4 + 0) + -1)
   (-1 + -1)
   ((4 + 0) + (-1 + -1))

   In other words: (i) an integer is an expression; (ii) connecting two
   existing expression with the plus sign (with parentheses around)
   makes a new expression.

   How to embed, that is, represent them in OCaml. OCaml is a functional
   language, so the fundamental operation is application. So, we have
   to represent expressions of our language as applications. Assume functions
   int and add
   int 4
   add (add (int 4) (int 0)) (add (int (-1)) (int (-1)))
   What are the types of int and add?
*)

let e1 = fun (type repr) (int:int->repr) (add:repr->repr->repr) ->
   add (add (int 4) (int 0)) (add (int (-1)) (int (-1)))

(* See the return type. The difference between 4 and int 4:
   look at the type, and see which represents the sentence Lang,
   and which not.
*)

(* The definition of our DSL, in the form of an OCaml signature 
   cf: Go interfaces, Rust and Scala's traits, virtual/abstract classes
   or namespaces (in C++)
   signature: module outline
   This signature shows the syntax of our DSL
*)
module type Lang = sig
  type repr
  val int: int -> repr
  val add: repr -> repr -> repr
end

(* A sample DSL expression, as a parameterized module
   (why do we use open)
 *)
module Ex1(L:Lang) = struct
  open L
  let res = add (add (int 4) (int 0)) 
                (add (int (-1)) (int (-1)))
end

(* One interpreter for the DSL: meta-circular *)
module Eval = struct
  type repr = int
  let int x = x
  let add   = (+)
end

(* Try interpreting Ex1 *)
let _ = let module M = Ex1(Eval) in M.res
(*
  - : int = 2
*)

(* What happens when the implementation is wrong? *)

module EvalW1 = struct
  type repr = int
  let int x = x
  let add   = (<)
end

module EvalW2 = struct
  type repr = int
  let int x = x
end

(*
let _ = let module M = Ex1(EvalW1) in M.res
let _ = let module M = Ex1(EvalW2) in M.res
*)

(* Bonus question: how to ensure the error in EvalW1 and EvalW2
is reported as they are defined, rather than when they are used?
*)

(* Another interpreter: pretty-printer *)
module Pp = struct
  type repr = string
  let int = string_of_int
  let add x y = "(" ^ x ^ " + " ^ y ^ ")"
end

(* Interpreting the same Ex1 using Pp *)
let _ = let module M = Ex1(Pp) in M.res
(*
- : string = "((4 + 0) + (-1 + -1))"
*)

(* Let's write another interpreter: NegEval, which is just the Eval
   but gives the opposite result
   Note, that -(x + y) = (-x) + (-y)
   So, to get the sum with the opposite sign we use the regular plus,
   but with negated operands.
*)
module NegEval = struct
  type repr = int
  let int x = -x
  let add   = (+)
end

(* Try interpreting Ex1 *)
let _ = let module M = Ex1(NegEval) in M.res
(*
  - : int = -2
*)

(* Instead of writing NegEval from scratch, can we write it starting from
  Eval, as transforming Eval?

  We can write the |int| implemenatation as either
     let int x = Eval.int (-x)
  or
     let int x = - Eval.int x

 Why is the former better? Because it does not use the fact that Eval.repr
 is an integer -- it does not need to. Therefore, it generalizes.
*)

module NegEval = struct
  type repr = Eval.repr
  let int x = Eval.int (-x)
  let add   = Eval.add
end
let _ = let module M = Ex1(NegEval) in M.res
(*
  - : int = -2
*)


(* And now we abstract out Eval *)
module Neg(F:Lang) = struct
  type repr = F.repr
  let int x     = F.int (-x)
  let add e1 e2 = F.add e1 e2
end

(* transform Eval and Pp implementations and use them 
   to interpret the same |Ex1| *)
let _ = let module M = Ex1(Neg(Eval)) in M.res
(*
    - : int = -2
*)

(* The benefit of writing the more complex Neg transformer is that
   it can be applied not just to Eval but to other interpreters, uniformly:
 *)
let _ = let module M = Ex1(Neg(Pp)) in M.res
(*
- : string = "((-4 + 0) + (1 + 1))"
*)

(* Neg was written as a transformer of interpreters. But it can also 
   be regarded as transforming expressions. Here is
   the transformed Ex1 
*)
module Ex1Neg(F:Lang) = Ex1(Neg(F))

(* |Ex1Neg| has the same type as the original |Ex1|: given an interpreter
|Lang| it computes the meaning of |res| in that interpreter.
That is, |Ex1Neg| is a tagless-final representation
of a DSL expression. We could have written it by hand:
*)
module Ex1Neg'(L:Lang) = struct
  open L
  let res = add (add (int (-4)) (int 0)) 
                (add (int 1) (int 1))
end


let _ = let module M = Ex1Neg(Eval) in M.res
let _ = let module M = Ex1Neg'(Eval) in M.res
(*
  - : int = -2
*)

let _ = let module M = Ex1Neg(Pp) in M.res
let _ = let module M = Ex1Neg'(Pp) in M.res
(*
- : string = "((-4 + 0) + (1 + 1))"
*)

let _ = let module M = Ex1Neg(NegEval) in M.res
let _ = let module M = Ex1Neg(Neg(Eval)) in M.res
let _ = let module M = Ex1Neg'(Neg(Eval)) in M.res
(*
  - : int = 2
*)

let _ = let module M = Ex1Neg(Neg(Pp)) in M.res
let _ = let module M = Ex1Neg'(Neg(Pp)) in M.res

let _ = print_endline "All done"

;;
