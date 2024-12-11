(* Another implementation of lang.mli: Compiler *)
(* Extension with variable bindings *)

let (>>) f g x = f x |> g

type vname = string


(* previous version of the compiler, to extend with variable bindings *)
module C = Compiler_23
let type_cnv1 = C.type_cnv1
let type_cnv2 = C.type_cnv2

module CG = Code_gen

let (let*) = Qna.(let*)

(* Add a question about a variable. The answer is the previous compiler's
   atom
 *)
module VarQ = 
  Qna.Que.Make(struct type hname = vname 
                      type res = C.atom
                      let error_msg = Types.type_error "unbound variable %s"
               end)

type atom = C.atom Qna.t

(* Literals are answered immediately: don't depend on the context *)
let int  : int64 -> atom = C.int >> Qna.ans
let bool : bool -> atom  = C.bool >> Qna.ans

(* Variable is a question to the context *)
let var : vname -> atom = fun n -> Qna.que (VarQ.hole n)

type repr = C.repr Qna.t

(* Lifting the old compiler to question-answering system *)
let atomic : atom -> repr = Qna.lift1 C.atomic

let neg  : repr -> repr = Qna.lift1 C.neg
let succ : repr -> repr = Qna.lift1 C.succ
let pred : repr -> repr = Qna.lift1 C.pred
let not  : repr -> repr = Qna.lift1 C.not
let is_zero  : repr -> repr = Qna.lift1 C.is_zero

let add : repr -> atom -> repr = Qna.lift2 C.add

(* Introducing a local variable, and answering questions about it *)
let local : vname * repr -> repr -> repr = fun (name,exp) body ->
  let* (ty,blk) = exp in
  let (v,loc)  = CG.new_loc () in
  Qna.handle (VarQ.plug (name, (ty,loc))) body |>
  Qna.lift1 @@ fun (tyb,resb) -> (tyb, CG.(local (v,blk) resb))
 
type obs = C.obs                        (* observation type *)

(* Answering the questions about global variables and detecting
   unbound ones
*)

(* Global variable "x" has the same meaning as before *)
let observe : repr -> obs = 
  Qna.handle (VarQ.plug ("x",C.varx)) >> Qna.top_hand VarQ.error >> C.observe 

