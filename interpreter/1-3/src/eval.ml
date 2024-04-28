open Syntax

exception Eval_error;;

let rec f expr =
    match expr with
  | ELiteral x -> x

  | EBin (o, e1, e2) ->
    let v1 = f e1 in
    let v2 = f e2 in
      (match o with
      | OpAdd -> 
        (match v1, v2 with
        | LInt x, LInt y -> LInt (x + y)
        | _ -> raise Eval_error)
      | OpSub -> 
        (match v1, v2 with
        | LInt x, LInt y -> LInt (x - y)
        | _ -> raise Eval_error)
      | OpMul -> 
        (match v1, v2 with
        | LInt x, LInt y -> LInt (x * y)
        | _ -> raise Eval_error)
      | OpDiv -> 
        (match v1, v2 with
        |  LInt x, LInt y -> if y = 0 then raise Eval_error 
                            else LInt (x / y)
        | _ -> raise Eval_error)
      | OpEq -> 
        (match v1, v2 with
        | LInt x, LInt y -> LBool (x = y)
        | LBool x, LBool y -> LBool (x = y)
        | _ -> raise Eval_error)
      | OpLt -> 
        (match v1, v2 with
        | LInt x, LInt y -> LBool (x < y)
        | _ -> raise Eval_error))

  | EIf (e0, e1, e2) ->
      (match (f e0) with
      | LBool true -> f e1
      | LBool false -> f e2
      | _ -> raise Eval_error);;
