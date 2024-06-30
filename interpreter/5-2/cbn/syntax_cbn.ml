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
  | EMatch of expr * (pattern * expr) list        
  | ETuple of expr list                          
  | ENil                                     
  | ECons of expr * expr                  
  | ERLetAnd of (name * name * expr) list * expr


and env = (name * thunk) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VTuple of thunk list                       
  | VNil                               
  | VCons of thunk * thunk                          
  | VRLetAnd of int * (name * name * expr) list * env

and pattern = 
  | PInt of int
  | PBool of bool
  | PVar of name
  | PWild
  | PCons of pattern * pattern
  | PNil
  | PTuple of pattern list

and thunk = 
  | Thunk of expr * env
  | ThLetAnd of int * (name * expr list) * env


type command =
  | CExp of expr
  | CLet of name * expr
  | CRLetAnd of (name * name * expr) list


type ty_var = name

type ty =
  | TyInt
  | TyBool
  | TyFun of ty * ty
  | TyVar of ty_var
  | TyCons of ty 
  | TyTuple of ty * ty                 
  
  
and ty_subst = (ty_var * ty) list
  
and ty_constraints = (ty * ty) list
  
and ty_env = (name* ty) list