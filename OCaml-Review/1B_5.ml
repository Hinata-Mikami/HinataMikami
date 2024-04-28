type literal = LInt of int | LBool of bool

type binOp = OpAdd | OpSub | OpMul | OpDiv | OpEq | OpLt;;

type expr = Eliteral of literal  
          | EBin of binOp * expr * expr 
          | EIf of expr * expr * expr