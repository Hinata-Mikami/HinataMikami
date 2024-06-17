open Syntax_cbn

exception Error of string

(* let rec make_ERLetAnd_env (expl : (name * name * expr) list) (env : env) : env =
  match expl with
  | [] -> env
  | (f, x, e1) :: rest -> (f, Thunk (EFun (x, e1), env)) :: (make_ERLetAnd_env rest env)
   *)
let rec make_thunk (exp : expr) (env : env) : thunk =
  match exp with
  | ELiteral x -> Thunk (ELiteral x, env) 
  | EBin (op, e1, e2) -> Thunk ((EBin (op, e1, e2)), env)
  | EIf (e1, e2, e3) ->
    (match e1 with
    | ELiteral (LBool b) -> if b then Thunk (e2, env) else Thunk (e3, env)
    | _ -> raise (Error "Eval-CBN Error : Unexpected if syntax") 
    )
  | ELet (n, e1, e2) -> Thunk (e2, (n, Thunk (e1, env)) :: env)
  | EVar n ->(try List.assoc n env 
              with Not_found -> raise (Error "Eval-CBN Error : Variable not found"))
  | EApp (e1, e2) -> 
    (match e1 with
    | EFun (n, e1) -> Thunk (e2, (n, Thunk (EFun (n, e1), env)) :: env)
    (* | ERLetAnd (expl, e) -> 
      let env' = make_ERLetAnd_env expl env in
     *)
    | _ -> raise (Error "Eval-CBN Error : No-Function expression cannot be applied")
    )
  (* | ERLetAnd (expl, e) ->
    let env' = make_ERLetAnd_env expl env in
    Thunk (e, env') *)
  | ETuple elist -> Thunk (ETuple elist, env)
  | ECons (e1, e2) -> Thunk (ECons (e1, e2), env)
  | ENil -> Thunk (ENil, env)
  (* | EMatch (e, plist) -> *)
  | _ -> raise (Error "")

let value_of_literal (l:  literal) : value = 
  match l with
  | LInt i -> VInt i 
  | LBool b -> VBool b

let value_of_bin_op (op : binOp) (v1 : value) (v2 : value) : value =
  match v1, v2 with
  | VInt x, VInt y ->
  ( match op with
    | OpAdd -> VInt (x + y)
    | OpSub -> VInt (x - y)
    | OpMul -> VInt (x * y)
    | OpDiv -> if y = 0 then raise (Error "Eval_Error : Zero_Division") else VInt (x / y)
    | OpEq -> VBool (x = y)
    | OpLt -> VBool (x < y))
  | _ -> raise (Error "Eval_Error : Unexpected expression on eval_bin_op")


let rec value_of_etuple (elist : expr list) (env : env) : thunk list = 
  match elist with
  | [] -> []
  | e :: rest -> Thunk (e, env) :: value_of_etuple rest env

let rec value_of_exp (exp : expr) (env : env) : value =
  let Thunk (exp', env') = make_thunk exp env in
    match exp' with
    | ELiteral l -> value_of_literal l
    | EBin (op, e1, e2) -> 
      let v1 = value_of_exp e1 env' in
      let v2 = value_of_exp e2 env' in
      value_of_bin_op op v1 v2
    | EIf (e1, e2, e3) -> value_of_exp exp' env'
    | EFun (n, e1) -> value_of_exp exp' env'
    | ETuple elist -> VTuple (value_of_etuple elist env)
    | ENil -> VNil
    | ECons (e1, e2) -> VCons (Thunk (e1, env'), value_of_exp e2 env')
    | _ -> raise (Error "Eval_CBN Error : Undefined expression at value_of_exp")
     

let rec print_value (v : value) : unit =
  match v with
  | VInt i -> print_int i
  | VBool b -> print_string (string_of_bool b)
  | VTuple thlist -> 
      print_string "("; 
      let rec print_value_tuple thlist =
        (match thlist with
        | Thunk (exp, env) :: [] -> print_value (value_of_exp exp env); print_string ")"
        | Thunk (exp, env) :: rest -> print_value (value_of_exp exp env); print_string ", "; print_value_tuple rest
        | _ -> raise (Error "Unexpected match happened at eval_cbn/print_value")
        ) 
      in print_value_tuple thlist
    | VNil -> print_string "[]"
    | VCons (Thunk (exp, env), v) -> print_value (value_of_exp exp env); print_string " :: "; print_value v
    | _ -> () 

  
    
    

