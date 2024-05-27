type name = string 

(*型を表すデータ型*)
type ty =
  | TyInt
  | TyBool
  | TyFun of ty * ty
  (*型変数*)
  | TyVar of name                        

(*型代入 型変数に型tyを代入*)
and ty_subst = (name * ty) list

and ty_constraints = (ty * ty) list

exception Type_error


(*型代入:ty_subst と t を受け取り、
  tがTInt, TBoolのときはそのまま
  TFun(T1,t2) -> t1とt2を再帰的に型代入
  TVar n -> nがリストに存在するとき、置き換え
            存在しない -> そのまま返す*)
let rec apply_ty_subst (s : ty_subst) (t : ty) : ty =
  match t with
  | TyInt -> TyInt
  | TyBool -> TyBool
  | TyFun(t1, t2) -> TyFun(apply_ty_subst s t1, apply_ty_subst s t2)
  | TyVar n -> 
    (match s with
    | [] -> t
    | (s', t') :: rest when s' = n -> t'
    | (s', t') :: rest -> apply_ty_subst rest t
    )
            
(*s1とs2の合成*)
(*
TAPL p.318 より  
  代入σ、γについて、これらの合成は、
  γに属するすべての X ↦ T について X ↦ σ(T)
  さらに、γに属さないX ↦ T のうちσに属するそれについてはそのまま
              
  つまり、
  s2のすべての(n,t)についてs1の型を代入(置き換え)してl2
  次に、s1のうちs2に含まれるものを削除したリストl1
  これらを合成したものを作ればよい。
*)
            
let compose_ty_subst (s1 : ty_subst) (s2 : ty_subst) : ty_subst =
  let rec make_l2 s2 =
    match s2 with
    | [] -> []
    | (s, t) :: rest -> (s, apply_ty_subst s1 t) :: (make_l2 rest)
  in let l2 = make_l2 s2
  in
  let rec make_l1 s1 = 
    match s1 with
    | [] -> []
    | (s, t) :: rest ->
      (match List.assoc_opt s s2 with
      | Some x -> make_l1 rest
      | None -> (s, t) :: (make_l1 rest)
      )
  in let l1 = make_l1 s1
in l2 @ l1
            
(*tがsを含んでいるかどうかを確認する関数*)
let rec check_var_fault (s : string) (t : ty) : bool =
  match t with
  | TyInt -> false
  | TyBool -> false
  | TyVar n -> if n = s then true else false
  | TyFun (t1, t2) -> check_var_fault s t1 || check_var_fault s t2
            
            
let rec ty_unify (c : ty_constraints) : ty_subst =
  match c with
  (*unify {} = {}*)
  | [] -> []
  (*unify ( {s = s} U c) = unify c *)
  | (t1, t2) :: rest when t1 = t2 -> ty_unify rest
  (*unify ({ s1->t1 = s2->t2 } U c) = unify ({ s1=s2, t1=t2 } U c)*)
  | (TyFun (s1, t1), TyFun (s2, t2)) :: rest -> ty_unify ((s1, s2) :: (t1, t2) :: rest)
  (*unify ({s = t} U C) = unify ({t = s} U C) = unify (( C[s ↦ t] )∘[s ↦ t]) *)
  (*tはsを含まない -> t が s を含む場合はエラーを投げる*)
  | (TyVar s, t) :: rest | (t, TyVar s) :: rest ->
    if check_var_fault s t then raise Type_error
    (*C(rest)の各要素(t1,t2)においてsにtを代入する*)
    else compose_ty_subst
    (ty_unify (List.map (fun (t1, t2) -> (apply_ty_subst [(s, t)] t1, apply_ty_subst [(s, t)] t2)) rest)) [(s, t)]
  | _ -> raise Type_error
  

let test1 = ty_unify [(TyFun (TyVar "alpha", TyVar "beta"), TyFun (TyBool, TyVar "gamma"))];;
let test2 = ty_unify [(TyFun (TyVar "alpha", TyVar "beta"), TyFun (TyBool, TyVar "alpha"))];;
let test3 = ty_unify [(TyFun (TyVar "alpha", TyVar "beta"), TyFun (TyVar "beta", TyBool))];;
let test4 = ty_unify [(TyFun (TyVar "alpha", TyVar "alpha"), TyFun (TyBool, TyVar "gamma"))];;