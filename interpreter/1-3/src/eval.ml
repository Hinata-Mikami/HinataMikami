open Syntax

exception Eval_error;;

let rec f expr =
    match expr with
  | ELiteral x -> value_of_literal x

  | EBin (o, e1, e2) ->
    let v1 = f e1 in
    let v2 = f e2 in
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
      (match (f e0) with
      | VBool true -> f e1
      | VBool false -> f e2
      | _ -> raise Eval_error);;
