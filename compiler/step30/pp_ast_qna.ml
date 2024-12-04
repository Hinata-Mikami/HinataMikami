(* Pretty-printer showing scope: Question-answering (QNA) semantics *)

type vname = string
let (>>) f g = fun x -> f x |> g

(* The traditional PP, which doesn't deal with scope *)
module P = Pp_ast_ns

(* whereas the meaning of 1 (for the purpose of pretty-printing)
   is "1" and the meaning of true is "true", what is the meaning
   of the variable x (such that it shows its scope).
   It can't be simple "x" since it doesn't show the distinction, say,
   between global and locally-bound x.
   Since we want to know it which (binding) context a particular x
   appears, we should ask.
   Therefore, the meaning of an expression is not a simple string,
   but either an answer (already known string) or
   a question (asking for the interpretation of the variable
   and then proceeding)
 *)


type repr = 
  | A of P.repr             (* answer: meaning in the P semantics *)
  | Q of vname * (P.repr -> repr) (* Give the P meaning for a variable *)

(* Helpful functions to build questions and answers *)

let an : P.repr -> repr = fun x -> A x
let qu : vname -> repr  = fun v -> Q (v,an)

type atom = repr          (* Just as the P semantics, we don't distinguish
                             atoms and expressions *)

(* Int and bool literals don't depend on the context: answers *)
let int  : Int64.t -> atom = P.int >> an
let bool : bool -> atom    = P.bool >> an

(* A variable poses a question *)
let var : vname -> atom = qu

(* Composite expressions *)
let rec neg  : repr -> repr = function 
  (* If the argument is the answer (that is, a string produced by an
     earlier pretty-printer P), we use its P.neg to produce the representation
     of the negated expression. This will be the answer.
  *)
  | A x -> P.neg x |> an
  (* If the argument is the question, we can't proceed till we know the answer
     to it. So, we re-ask the question
  *)
  | Q (v,k)  -> Q (v, fun a -> k a |> neg)

(* Clearly it is a bother to repeat such complex expression for succ, not
   and all other unary operators. We can refactor it however, 
   abstracting the questioning part.
  Why it is called lift1?
 *)

let rec lift1 : (P.repr -> P.repr) -> (repr -> repr) = fun op -> function
  | A x     -> op x |> an
  | Q (v,k) -> Q(v, k >> lift1 op)

let neg  : repr -> repr = lift1 P.neg
let succ : repr -> repr = lift1 P.succ
let pred : repr -> repr = lift1 P.pred
let not  : repr -> repr = lift1 P.not
let is_zero : repr -> repr = lift1 P.is_zero
let atomic : atom -> repr = lift1 P.atomic (* atom and repr are the same type *)

(* Binary op are similar *)

let rec lift2 : (P.repr -> P.repr -> P.repr) -> 
                (repr -> repr -> repr) = 
  fun op e1 e2 -> match (e1,e2) with
  | (A x, A y)     -> op x y |> an
  | (Q (v,k),e2)   -> Q(v, fun x -> lift2 op (k x) e2)
  | (e1,Q (v,k))   -> Q(v, fun x -> lift2 op e1 (k x))

let add : repr -> atom -> repr = lift2 P.add

(* How to answer the questions? We need an answerer, called a handler *)

let rec handler : (vname -> P.repr option) -> repr -> repr = fun h -> function
  | A _ as a -> a                       (* It is already an answer *)
  | Q (v,k) -> match h v with
   (* Got reply from h. Pass it to k. There may be further questions,
      so we have to keep handling
    *)
   | Some r -> k r |> handler h
   (* h could not asnwer the question. Ask it again *)
   | None   -> Q(v, k >> handler h)

let local : vname * repr  -> repr -> repr = 
  fun (n,exp) body -> 
   (* exp may have questions, answer them *)
   let rec eh = function
   | A e -> 
       let unique_name = Util.gensym n in
       let h v = if v = n then Some (P.var unique_name) else None in
       lift1 (P.local (unique_name,e)) (handler h body)
   | Q (v,k) -> Q(v, k >> eh)
   in eh exp


(* Finally, the top handler: answers the questions that propagate
   to the very top, that is, about global variables
 *)

let rec top_hand : repr -> P.repr = function
  | A x -> x
  | Q (v,k) when v = "x" -> P.var v |> k |> top_hand
  | Q (v,_) -> Util.fail "unbound variable: %s" v

type obs = P.obs                                (* observation type *)
let observe : repr -> obs = top_hand >> P.observe

