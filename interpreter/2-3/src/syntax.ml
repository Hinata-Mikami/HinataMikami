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

(*endをつけないといけない理由：どこかでコンフリクトが起きる？実際のOCamlでも括弧をつけないといけないような…*)
type expr =
  | ELiteral of literal 
  | EBin of binOp * expr * expr 
  | EIf of expr * expr * expr 
  | EVar of name
  | ELet of name * expr * expr
  | ERLet of name * name * expr * expr (*資料参考:再帰表現*)
  | EFun of name * expr
  | EApp of expr * expr

and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VRFun of name * name * expr * env (*資料参考:ERLetを評価した値*)

type command =
  | CExp of expr
  | CLet of name * expr

exception Eval_error

let print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b) 
  | VFun (x, e, env) -> () (*未実装*)
  | VRFun (f, x, e, env) -> ()

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 