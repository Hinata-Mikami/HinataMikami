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
  | ETuple of expr * expr                           
  | ENil                                     
  | ECons of expr * expr                       
  | ERLetAnd of (name * name * expr) list * expr
  | ERLetInf of name * expr * expr

and env = (name * thunk) list

and value =
  | VInt  of int
  | VBool of bool 
  | VFun of name * expr * env
  | VTuple of value * value                         
  | VNil                                              
  | VCons of value * value                            
  | VRFunAnd of int * (name * name * expr) list * env

and pattern = 
  | PInt of int
  | PBool of bool
  | PVar of name
  | PWild
  | PCons of pattern * pattern
  | PNil
  | PTuple of pattern * pattern

and thunk = Thunk of expr * env
  | ThunkInf of name * expr * env


type command =
  | CExp of expr
  | CLet of name * expr
  | CRLetAnd of (name * name * expr) list
  | CRLetInf of name * expr