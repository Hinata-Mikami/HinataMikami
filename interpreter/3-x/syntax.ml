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
  | EFun of name * expr
  | EApp of expr * expr
  | EMatch of expr * (pattern * expr) list            (*match e with p -> e | ...*)
  | ETuple of expr list                               (*(e1, e2, ...)*)
  | ENil                                              (*[] *)
  | ECons of expr * expr                              (*e1 :: e2 *)
  | ERLetAnd of (name * name * expr) list * expr      (*let f x = e0 and ... in e *)

and env = (name * value) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VRFun of name * name * expr * env     
  | VTuple of value list                              (*(v1, v2, ...)*)              
  | VNil                                              (*[] *)
  | VCons of value * value                            (*v1 :: v2 *)
  | VRFunAnd of int * (name * name * expr) list * env

(*パターンマッチ用*)
and pattern = 
  | PInt of int
  | PBool of bool
  | PVar of name
  | PWild
  | PCons of pattern * pattern
  | PNil
  | PTuple of pattern list


type command =
  | CExp of expr
  | CLet of name * expr
  | CRLetAnd of (name * name * expr) list

(* 型を表すデータ型
type ty =
  | TyInt
  | TyBool
  | TyFun of ty * ty
  (*型変数*)
  | TyVar of name                        

(*型代入 型変数に型tyを代入*)
and ty_subst = (name * ty) list

and ty_constraints = (ty * ty) list *)
