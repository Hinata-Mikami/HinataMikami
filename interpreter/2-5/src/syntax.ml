type name = string 

type literal = 
  | LInt of int 
  | LBool of bool 

type binOp = 
  | OpAdd 
  | OpSub 
  | OpMul 
  | OpDiv 
  | OpEq 
  | OpLt

type expr =
  | ELiteral of literal 
  | EBin of binOp * expr * expr 
  | EIf of expr * expr * expr 
  | EVar of name
  | ELet of name * expr * expr
  | ERLet of name * name * expr * expr
  | EFun of name * expr
  | EApp of expr * expr
  | EMatch of expr * (pattern * expr) list            (*2-3 match e with p -> e | ...*)
  | ETuple of expr list                               (*2-4 (e1, e2, ...)*)
  | ENil                                              (*2-4 [] *)
  | ECons of expr * expr                              (*2-4 e1 :: e2 *)
  | ERLetAnd of (name * name * expr) list * expr      (*2-5 let f x = e0 and ... in e *)

and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VRFun of name * name * expr * env     
  | VTuple of value list                              (*2-4 (v1, v2, ...)*)              
  | VNil                                              (*2-4 [] *)
  | VCons of value * value                            (*2-4 v1 :: v2 *)
  | VRFunAnd of int * (name * name * expr) list * env (*2-5*)

(*2-3 パターンマッチ用*)
and pattern = 
  | PInt of int
  | PBool of bool
  | PVar of name
  | PWild
  (*2-4*)
  | PCons of pattern * pattern
  | PNil
  | PTuple of pattern list


type command =
  | CExp of expr
  | CLet of name * expr
  (* | CRLet of name * name * expr *)
  | CRLetAnd of (name * name * expr) list   (*2-5*)

exception Eval_error

let rec print_value (v: value) : unit =
  match v with
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b)
  | VFun (x, e, env) -> print_string "<fun>"
  | VRFun (f, x, e, env) -> print_string "<fun>"
  (*2-4*)
  | VCons (v, rest) -> 
    (match rest with
    | VNil -> print_value v; print_string " :: "; print_string "[]"
    | _ -> print_value v; print_string " :: ("; print_value rest; print_string ")" )
  | VNil -> print_string "[]"
  | VTuple vlist ->
      (*組を表示する関数*)
      let rec print_tuple (vl : value list) : unit =
      match vl with
        | [] -> print_char ')'
        | v :: rest -> print_string ", "; print_value v; print_tuple rest; in
      (match vlist with
        | [] -> raise Eval_error
        | v :: rest -> print_char '('; print_value v; print_tuple rest)
  (*2-5*)
  | VRFunAnd (_, l, _) -> print_string "<fun>"

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 