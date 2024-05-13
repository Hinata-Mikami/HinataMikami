type name = string 

type literal = 
  | LInt of int 
  | LBool of bool 

type binOp = OpAdd | OpSub | OpMul | OpDiv | OpEq | OpLt

type expr =
  | ELiteral of literal 
  | EBin of binOp * expr * expr 
  | EIf of expr * expr * expr 
  | EVar of name
  | ELet of name * expr * expr
  | EFun of name * expr (* fun x -> E*)
  | EApp of expr * expr (* E E *)

(*env : 変数に値を束縛するリスト型？*)
and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env (*fun式の評価結果のクロージャ (関数,環境)*)

type command =
  | CExp of expr
  | CLet of name * expr


let print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b) 
  | VFun _ -> ()

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 