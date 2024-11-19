exception Error of string
type expr =
  | Var of string
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  (* | Par of expr *)

let rec make_nnf (expr : expr) : expr =
  match expr with
  | Not (And (e1, e2)) -> Or (make_nnf (Not e1), make_nnf (Not e2))
  | Not (Or (e1, e2)) -> And (make_nnf (Not e1), make_nnf (Not e2))
  | And (e1, e2) -> And (make_nnf e1, make_nnf e2)
  | Or (e1, e2) -> Or (make_nnf e1, make_nnf e2)
  (* | Par e -> Par (make_nnf e) *)
  | Var s -> Var s
  | Not (Var s)  -> Not (Var s)
  | Not (Not e) -> make_nnf e

let rec print_expr (expr : expr) : unit =
  match expr with
  | Var s -> print_string ("Var "^ s)
  (* | Par e -> print_string "Par ("; print_expr e; print_string ")" *)
  | And (e1, e2) -> print_string "And (";print_expr e1; print_string ", "; print_expr e2; print_string ")"
  | Or (e1, e2) -> print_string "Or (";print_expr e1; print_string ", "; print_expr e2; print_string ")"
  | Not e -> print_string "Not (";print_expr e; print_string ")"


(* 1 : ¬¬p = p*)
let test1 = Not (Not (Var "p"));;
print_expr (make_nnf test1); print_newline()

(* 2 : ((p) ∨ ¬p) = ( ¬( (¬p) ∧ p) ) *)
let test2 = Or ((Var "p"), Not (Var "p"));;
print_expr (make_nnf test2); print_newline()

(* 3 (Q5-3) : ¬( (¬p) ∨ ( (¬p) ∧ p ) ) *)
let test3 = Not (Or (Not (Var "p"), And (Not (Var "p"), Var "p")));;
print_expr (make_nnf test3); print_newline()





