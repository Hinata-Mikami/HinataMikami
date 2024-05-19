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
  | OpOr

type expr =
  | ELiteral of literal 
  | EBin of binOp * expr * expr 
  | EIf of expr * expr * expr 
  | EVar of name
  | ELet of name * expr * expr
  | ERLet of name * name * expr * expr
  | EFun of name * expr
  | EApp of expr * expr
  | EMatch of expr * expr                             (*match e0 with ...*)
  | EMatchpair of expr * expr                         (*p1 -> e1 | ...*)
  | EMatchpairend of expr * expr                      (*p1 -> e1 end*)
  | EPair of expr * expr                              (* (e1, e2) *)
  | ENil                                              (* [] *)
  | ECons of expr * expr                              (* e1 :: e2 *)
  | ERLetand of (name * name * expr) list * expr      (* let f x = e0 and ... in e *)

and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VRFun of name * name * expr * env     
  | VPair of value * value                            (* (v1, v2)*)              
  | VNil                                              (* [] *)
  | VCons of value * value                            (* v1 :: v2 *)
  | VRFunand of int * (name * name * expr) list * env

type command =
  | CExp of expr
  | CLet of name * expr

exception Eval_error

let rec print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b)
  (* | VPair (v1, v2) ->   *)
  (* | VNil -> print_string ("[]") *)
  | _ -> ()

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 