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
  | EMatch of expr * (pattern * expr) list                             (*match e0 with ...*)
  | ETuple of expr list                               (* (e1, e2) *)
  | ENil                                              (* [] *)
  | ECons of expr * expr                              (* e1 :: e2 *)
  | ERLetAnd of (name * name * expr) list * expr      (* let f x = e0 and ... in e *)

and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VRFun of name * name * expr * env     
  | VTuple of value list                              (* (v1, v2)*)              
  | VNil                                              (* [] *)
  | VCons of value * value                            (* v1 :: v2 *)
  | VRFunAnd of int * (name * name * expr) list * env

and pattern = 
  | PInt of int
  | PBool of bool
  | PVar of name
  | PCons of pattern * pattern
  | PNil
  | PTuple of pattern list
  | PWild

type command =
  | CExp of expr
  | CLet of name * expr
  | CRLet of name * name * expr
  | CRLetAnd of (name * name * expr) list

exception Eval_error

let rec print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b)
<<<<<<< HEAD
  (* | VPair (v1, v2) ->   *)
  (* | VNil -> print_string ("[]") *)
  | _ -> ()
=======
  | VFun (x, e, env) -> print_string "<fun>"
  | VRFun (f, x, e, env) -> print_string "<fun>"
  | VCons (v, rest) -> 
    (match rest with
    | VNil -> print_value v; print_string " :: "; print_string "[]"
    | _ -> print_value v; print_string " :: ("; print_value rest; print_string ")" )
  | VNil -> print_string "[]"
  | VTuple vlist ->
      let rec print_tuple : value list -> unit
      = function
        | [] -> print_char ')'
        | v :: rest -> print_string ", "; print_value v; print_tuple rest; in
      (match vlist with
        | [] -> raise Eval_error
        | v :: rest -> print_char '('; print_value v; print_tuple rest)
  | VRFunAnd (_, l, _) -> print_string "<fun>"
>>>>>>> 46e8a9f (2-4完成)

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 