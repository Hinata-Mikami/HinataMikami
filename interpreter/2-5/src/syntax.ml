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
  | EMatch of expr * expr
  | EMatchpair of expr * expr
  | EMatchpairend of expr * expr
  | EPair of expr * expr
  | ENil
  | ECons of expr * expr
  | ERLetand of (name * name * expr) list * expr

and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VRFun of name * name * expr * env
  | VPair of value * value
  | VNil
  | VCons of value * value
  | VRFunand of int * (name * name * expr) list * env

type command =
  | CExp of expr
  | CLet of name * expr

exception Eval_error

let print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b) 
  | _ -> ()

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 