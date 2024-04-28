(*
削除
type name = string 
*)

type value =
  | VInt  of int
  | VBool of bool 

type literal = 
  | LInt of int 
  | LBool of bool 

(*追加*)
type binOp = OpAdd | OpSub | OpMul | OpDiv | OpEq | OpLt

(*EVar削除，ELet->EIf*)
type expr =
  | ELiteral of literal 
  | EBin   of binOp * expr * expr 
  | EIf   of expr * expr * expr 

type command = CExp of expr

(*使わないので削除
let print_name : name -> unit = print_string 
*)

let print_value : value -> unit = function 
  | VInt i -> print_int i 
  | VBool b -> print_string (string_of_bool b) 

let value_of_literal : literal -> value = function 
  | LInt i -> VInt i 
  | LBool b -> VBool b 

let print_literal : literal -> unit = fun lit -> print_value @@ value_of_literal lit 

(*追加*)
let print_binOp : binOp -> unit = function 
  | OpAdd -> print_string "OpAdd" 
  | OpSub -> print_string "OpSub"
  | OpMul -> print_string "OpMul"
  | OpDiv -> print_string "OpDiv"
  | OpEq -> print_string "OpEq"
  | OpLt-> print_string "OpLt"

(*削除・変更*)
let rec print_expr = function 
  | ELiteral v -> 
    print_literal v 

  | EBin (op,e1,e2) -> 
    ( print_string "EBin (";
      print_binOp op ; 
      print_string ","; 
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | EIf (e0,e1,e2) ->
    (print_string "EIf (";
     print_expr   e0;
     print_string ","; 
     print_expr   e1;
     print_string ",";
     print_expr   e2;
     print_string ")")
 