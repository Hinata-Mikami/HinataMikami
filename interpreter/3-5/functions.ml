open Syntax

exception Error of string


let rec apply_ty_subst (t_s : ty_subst) (t : ty) : ty =
  match t with
  | TyInt -> TyInt
  | TyBool -> TyBool
  | TyFun(t1, t2) -> TyFun(apply_ty_subst t_s t1, apply_ty_subst t_s t2)
  | TyVar t_v -> 
    (match t_s with
    | [] -> t
    | (t_v', t') :: rest when t_v' = t_v -> t'
    | (t_v', t') :: rest -> apply_ty_subst rest t
    )
  | TyTuple (t1, t2) -> TyTuple (apply_ty_subst t_s t1, apply_ty_subst t_s t2)
  | TyCons t' -> TyCons (apply_ty_subst t_s t')
 

let compose_ty_subst (s1 : ty_subst) (s2 : ty_subst) : ty_subst =
  let rec make_l2 s2 =
    match s2 with
    | [] -> []
    | (t_v, t) :: rest -> (t_v, apply_ty_subst s1 t) :: (make_l2 rest)
  in let l2 = make_l2 s2
  in
  let rec make_l1 s1 = 
    match s1 with
    | [] -> []
    | (t_v, t) :: rest ->
      (match List.assoc_opt t_v s2 with
      | Some x -> make_l1 rest
      | None -> (t_v, t) :: (make_l1 rest)
      )
  in let l1 = make_l1 s1
in l2 @ l1


let rec check_var_fault (s : string) (t : ty) : bool =
  match t with
  | TyInt -> false
  | TyBool -> false
  | TyVar t_v -> if t_v = s then true else false
  | TyFun (t1, t2) -> check_var_fault s t1 || check_var_fault s t2
  | TyTuple (t1, t2) -> check_var_fault s t1 || check_var_fault s t2
  | TyCons t' -> check_var_fault s t'


  let rec ty_unify (c : ty_constraints) : ty_subst =
    match c with
    | [] -> []  
    | (t1, t2) :: rest when t1 = t2 -> ty_unify rest  
    | (TyFun (s1, t1), TyFun (s2, t2)) :: rest -> ty_unify ((s1, s2) :: (t1, t2) :: rest)  
    | (TyVar s, t) :: rest | (t, TyVar s) :: rest -> 
      if check_var_fault s t then raise (Error ("FunctionsError : Unable to decide type of "^s))
      else compose_ty_subst
      (ty_unify (List.map (fun (t1, t2) -> (apply_ty_subst [(s, t)] t1, apply_ty_subst [(s, t)] t2)) rest)) [(s, t)]
    | (TyCons t1, TyCons t2) :: rest -> ty_unify ((t1, t2) :: rest)
    | (TyTuple (t1, t2), TyTuple (t1', t2')) :: rest ->
      ty_unify ((t1, t1') :: (t2, t2') :: rest)

    | _ -> raise (Error "FunctionsError : Unable to unify")


let counter = ref 0
let new_ty_var () =
  let current_count = !counter in
  counter := current_count + 1;
  "t" ^ string_of_int current_count

  let rec gather_ty_constraints_pattern (p : pattern) : ty * ty_env * ty_constraints =
    match p with
    | PInt i -> (TyInt, [], [])
    | PBool b -> (TyBool, [], [])
    | PVar s ->
      let s1 = new_ty_var () in
      (TyVar s1, [(s, TyVar s1)], [])
    (* | PTuple p_l ->
      let rec gather_PTuple_constraints p_l =
        (match p_l with
        | [] -> ([], [], [])
        | pi :: rest -> (gather_ty_constraints_pattern pi) :: gather_PTuple_constraints rest
        ) in
      let l = gather_PTuple_constraints p_l in
      let rec ty_l l =
        (match l with
        | (x, _, _) :: [] -> x
        | (x, _, _) :: rest -> TyTuple (x, ty_l rest)
        | _ -> raise (Error "FunctionsError: couldn't gather PTuple constraints")
        ) in
      let rec t_bind l =
        (match l with
        | [] -> []
        | (_, bind, _) :: rest -> bind @ t_bind rest
        ) in
      let rec t_cons l =
        (match l with
        | [] -> []
        | (_, _, cons) :: rest -> cons @ t_cons rest
        ) in
        (ty_l l, t_bind l, t_cons l) *)
    | PTuple p_l ->
      let rec gather_PTuple_constraints p_l =
        (match p_l with
        | [] -> ([], [], [])
        | pi :: rest -> 
          let (t, env, cons) = gather_ty_constraints_pattern pi in
          let (t_rest, env_rest, cons_rest) = gather_PTuple_constraints rest in
          (t :: t_rest, env @ env_rest, cons @ cons_rest)
          ) in
      let (types, env, cons) = gather_PTuple_constraints p_l in
      let ty = List.fold_right (fun t acc -> TyTuple (t, acc)) types (List.hd (List.rev types)) in
      (ty, env, cons)
    | PNil ->
      let s = new_ty_var () in
      (TyCons (TyVar s), [], [])
    | PCons (p1, p2) ->
      let (t1, t_bind1, c1) = gather_ty_constraints_pattern p1 in
      let (t2, t_bind2, c2) = gather_ty_constraints_pattern p2 in
      (TyCons t1, t_bind1 @ t_bind2, [(TyCons t1, t2)] @ c1 @ c2) 
    | PWild -> 
      let s = new_ty_var () in
      (TyVar s, [], [])

let rec gather_ty_constraints (t_e : ty_env) (e : expr) : ty * ty_constraints =
  match e with
  | ELiteral x -> 
    (match x with
    | LInt _ -> (TyInt, [])
    | LBool _ -> (TyBool, [])
    )
  | EVar x ->  
    (match List.assoc_opt x t_e with
    | Some x' -> (x', [])
    | None -> raise (Error ("FunctionsError : Unbound variable "^x))
    )
  | ELet (x, e1, e2) -> 
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints ((x, t1) :: t_e) e2 in
    (t2, c1 @ c2)
  | EIf (e1, e2, e3) -> 
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in
    let (t3, c3) = gather_ty_constraints t_e e3 in
    (t2, [(t1, TyBool); (t2, t3)] @ c1 @ c2 @ c3)
  | EFun (x, e) -> 
    let a = new_ty_var () in
    let (t, c) = gather_ty_constraints ((x, TyVar a) :: t_e) e in
    (TyFun (TyVar a, t), c)
  | EApp (e1, e2) -> 
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in 
    let a = new_ty_var () in
    (TyVar a, [(t1, TyFun (t2, TyVar a))] @ c1 @ c2)
  | ERLetAnd (l, e) -> 
    let l' = (List.map (fun (f,x1,e1) ->
      let a = new_ty_var () in
      let b = new_ty_var () in
      (f, x1, e1, a, b))
      l) in
    let gamma = 
      (List.map (fun (f,x1,e1,a,b) -> (f, TyFun (TyVar a, TyVar b))) l') @ t_e in
    let rec ty_con_b_list list =
      (match list with
      | [] -> []
      | (f,x1,e1,a,b) :: rest -> 
        let (t1, c1) = gather_ty_constraints ((x1, TyVar a) :: gamma) e1 in 
        (t1, TyVar b, c1) :: ty_con_b_list rest  
      ) in
    let (t, c) = gather_ty_constraints gamma e in      
    let rec new_con list' =
      (match list' with
      | [] -> c
      | (t1, t_vb, c1) :: rest -> ((t1, t_vb) :: c1) @ new_con rest  
      ) in
    (t, new_con (ty_con_b_list l'))
  | EBin (op, e1, e2) ->
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in
    (match op with
    | OpAdd | OpSub | OpMul | OpDiv | OpEq
      -> (TyInt, [(t1, TyInt); (t2, TyInt)] @ c1 @ c2) 
    | OpLt -> (TyBool, [(t1, TyInt); (t2, TyInt)] @ c1 @ c2)
    )
  | ECons (e1, e2) ->
    let (t1, c1) = gather_ty_constraints t_e e1 in
    let (t2, c2) = gather_ty_constraints t_e e2 in
    (TyCons t1, [(t2, TyCons t1)] @ c1 @ c2)
  | ETuple e_l -> 
    let rec gather_ETuple_constraints e_l =
      (match e_l with
      | [] -> []
      | e :: rest -> (gather_ty_constraints t_e e) :: gather_ETuple_constraints rest
      ) in
    let l = gather_ETuple_constraints e_l in
    let rec tlist l =
      (match l with
      | (ti, _) :: [] ->  ti
      | (ti, _) :: rest -> TyTuple (ti, (tlist rest))
      | _ -> raise (Error "FunctionsError : unable to gather ETuple constraints")
      ) in
    let rec clist l =
      (match l with
      | [] -> []
      | (_, ci) :: rest -> ci @ clist rest
      )
    in (tlist l, clist l)
    (* | EMatch (e, plist) ->
      let (t, c) = gather_ty_constraints t_e e in
      let s = new_ty_var () in
      let plist =
        List.fold_left (fun list (p, e) ->
          let (t, t_bind, c) = gather_ty_constraints_pattern p in
          let (t_e', c') = gather_ty_constraints (t_bind @ t_e) e in
          (t, t) :: (TyVar s, t_e') :: c @ c' @ list) [] plist in
      (TyVar s, c @ plist) *)
  | EMatch (e, plist) ->
    let (t, c) = gather_ty_constraints t_e e in
    let s = new_ty_var () in
    let rec process_patterns plist =
      match plist with
      | [] -> []
      | (p, e) :: rest ->
        let (t_p, t_bind, c_p) = gather_ty_constraints_pattern p in
        let (t_e, c_e) = gather_ty_constraints (t_bind @ t_e) e in
        (t, t_p) :: (TyVar s, t_e) :: c_p @ c_e @ process_patterns rest
    in
    let c' = process_patterns plist in
    (TyVar s, c @ c')
  | _ -> raise (Error "FunctionsError : Unable to gather constraints")


let rec infer_expr (t_e : ty_env) (e : expr) : ty * ty_env = 
  let (t, c) = gather_ty_constraints t_e e in
  let t_s = ty_unify c in
  (apply_ty_subst t_s t, List.map (fun (n, ty) -> (n, apply_ty_subst t_s ty)) t_e)


let infer_cmd (t_e : ty_env) (cmd : command) : ty_env * ty_env =
  match cmd with
  | CExp e ->
    let (t, t_e') = infer_expr t_e e in
    ([("- ", t)], t_e')
  | CLet (n, e) ->
    let (t, t_e') = infer_expr t_e e in
    let newenv = (n, t) :: t_e' in
    ([(n, t)], newenv)
   | CRLetAnd l ->
      let l' = (List.map (fun (f,x1,e1) ->
        let a = new_ty_var () in
        let b = new_ty_var () in
        (f, x1, e1, a, b))
        l) in
      let a = (List.map (fun (f,x1,e1,a,b) -> (f, TyFun (TyVar a, TyVar b))) l') in
      let gamma = a @ t_e in
      let rec ty_con_b_list list =
        (match list with
        | [] -> []
        | (f,x1,e1,a,b) :: rest -> 
          let (t1, c1) = gather_ty_constraints ((x1, TyVar a) :: gamma) e1 in 
          (t1, TyVar b, c1) :: ty_con_b_list rest  
        ) in
      let rec new_con list' =
        (match list' with
        | [] -> []
        | (t1, t_vb, c1) :: rest -> ((t1, t_vb) :: c1) @ new_con rest  
        ) in
      let t_s = ty_unify (new_con (ty_con_b_list l')) in
      (List.map (fun (n, ty) -> (n, apply_ty_subst t_s ty)) a, List.map (fun (n, ty) -> (n, apply_ty_subst t_s ty)) gamma)


let rec print_type (t : ty) : unit =
  match t with
  | TyInt -> print_string "Int"
  | TyBool -> print_string "Bool"
  | TyFun (t1, t2) -> 
    (match (t1, t2) with
    | (TyFun (t11, t12) as t1'), t2'-> print_string "("; print_type t1'; print_string ")"; print_string " -> "; print_type t2'
    | _ -> print_type t1; print_string " -> "; print_type t2
    )
  | TyVar s -> print_string s
  | TyCons t' -> print_string "["; print_type t'; print_string "]"
  | TyTuple (t1, t2) as tyt -> 
    let rec print_type_tuple (t : ty) : unit =
    (match t with
      | TyTuple (t1, t2) -> 
        (match t2 with
        | TyTuple (t1', t2) as t' -> print_type t1'; print_string " * "; print_type_tuple t'
        | t'' -> print_type t''
        )
      | _ -> raise (Error "FunctionsError : Couldn't print type of tuple")
    ) in
    print_type_tuple tyt


let print_command_type (t_e : ty_env) (cmd : command) : ty_env =
  let (t_e', t_e'') = infer_cmd t_e cmd in
  let rec print_command_loop (t_e : ty_env) : unit =
    match t_e with
    | [] -> ()
    | (name, ty) :: [] ->
      print_string (name ^ ": "); print_type ty
    | (name, ty) :: rest ->
      print_string (name ^ ": "); print_type ty; print_string "; "; print_command_loop rest
    in 
    print_command_loop t_e'; 
    t_e''


let rec print_value (v: value) : unit =
  match v with
  | VInt i -> print_string "Int = "; print_int i 
  | VBool b -> print_string "Bool = "; print_string (string_of_bool b)
  | VFun (x, e, env) -> print_string " = <fun>"
  | VRFunAnd (_, l, _) -> print_string " = <fun>"
  | VNil | VCons _ -> print_string "List = "
  | _ -> raise (Error "FunctionsError : Still developing")


let rec print_command_value (env : env) (cmd : command) (t_e : ty_env) : env * ty_env =
  let t_e' = print_command_type t_e cmd in
  print_newline();
  match cmd with
  | CExp expr -> print_value (Eval.eval env expr); print_newline(); (env, t_e')
  | CLet (n, e) ->  print_string (" = "); 
    let command_let (env : env) (n : name) (e : expr) : (value * env) =
      (match Eval.eval env e with | v1 -> (v1, ((n,v1) :: env))) in
    let (v,e') = command_let env n e in print_value v; print_newline();
    (e', t_e')
  | CRLetAnd l ->
    let rec and_env (i: int) (l1: (name * name * expr) list) : env =
    match l1 with
    | [] -> env
    | (f, x, e) :: rest -> (f, VRFunAnd(i, l, env)) :: (and_env (i + 1) rest) in
    let nenv = and_env 0 l in
      (nenv, t_e')

let repl () =

  let lexbuf = Lexing.from_channel stdin in

  let rec loop_stdin (env:env) (t_e : ty_env) =  
    let () = print_string "# " in
    let () = flush stdout in
  
    match Parser.command Lexer.token lexbuf with
    | r ->
      (match print_command_value env r t_e with
      | (env', t_e') -> loop_stdin env' t_e'
      | exception Error s -> print_endline s; print_newline(); loop_stdin env t_e
      )
    | exception Lexer.Error msg ->
      Printf.printf "Lexing Error\n" ;
      print_endline msg;
      loop_stdin env t_e
    | exception Parsing.Parse_error ->
      Printf.printf "Parse Error "; 
      Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf); 
      loop_stdin env t_e
  
  in loop_stdin [] []


let read_file op_file =
  
  let lexbuf = Lexing.from_channel op_file in
    
  let rec loop_file (env : env) (t_e : ty_env) = 
    match Parser.command Lexer.token lexbuf with 
    | r -> 
      (match print_command_value env r t_e with
      | (env', t_e') -> loop_file env' t_e'
      | exception Error s -> print_endline s; print_newline()
      )
    | exception Lexer.Error msg -> Printf.printf "Lexing Error\n"; print_endline msg;
    | exception Parsing.Parse_error 
      ->  Printf.printf "Parse Error "; 
          Printf.printf "around `%s'\n" (Lexing.lexeme lexbuf);
  
  in loop_file [] []