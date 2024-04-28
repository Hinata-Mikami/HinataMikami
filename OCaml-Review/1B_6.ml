type literal = LInt of int | LBool of bool

type binOp = OpAdd | OpSub | OpMul | OpDiv | OpEq | OpLt;;

type expr = ELiteral of literal  
          | EBin of binOp * expr * expr 
          | EIf of expr * expr * expr;;

exception Eval_error;;

let rec eval e =
  match e with
  | ELiteral x -> x

  | EBin (o, e1, e2) ->
    let v1 = eval e1 in
    let v2 = eval e2 in
      (match o with
      | OpAdd -> 
        (match v1, v2 with
        | VInt x, VInt y -> VInt (x + y)
        | _ -> raise Eval_error)
      | OpSub -> 
        (match v1, v2 with
        | VInt x, VInt y -> VInt (x - y)
        | _ -> raise Eval_error)
      | OpMul -> 
        (match v1, v2 with
        | VInt x, VInt y -> VInt (x * y)
        | _ -> raise Eval_error)
      | OpDiv -> 
        (match v1, v2 with
        |  VInt x, VInt y -> if y = 0 then raise Eval_error 
                            else VInt (x / y)
        | _ -> raise Eval_error)
      | OpEq -> 
        (match v1, v2 with
        | VInt x, VInt y -> VBool (x = y)
        | VBool x, VBool y -> VBool (x = y)
        | _ -> raise Eval_error)
      | OpLt -> 
        (match v1, v2 with
        | VInt x, VInt y -> VBool (x < y)
        | _ -> raise Eval_error))

  | EIf (e0, e1, e2) ->
      (match (eval e0) with
      | VBool true -> eval e1
      | VBool false -> eval e2
      | _ -> raise Eval_error);;