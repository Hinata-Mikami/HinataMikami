type name = string 

type value =
  | VInt  of int
  | VBool of bool 

type literal = 
  | LInt of int 
  | LBool of bool 

type binOp = OpAdd | OpSub | OpMul | OpDiv | OpEq | OpLt

type expr =
  | ELiteral of literal 
  | EBin   of binOp * expr * expr 
  | EIf   of expr * expr * expr 
  | EVar of name
  | ELet of name * expr * expr

type command =
  | CExp of expr
  | CLet of name * expr

(*env : 変数に値を束縛するリスト型？*)
type env = (name * value) list

exception Eval_error

let print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b) 

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 