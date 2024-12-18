(* Extending with many binary operations *)

include module type of Lang_30

val sub : repr -> atom -> repr
val mul : repr -> atom -> repr

(* boolean conjunction and disjunction *)
val band : repr -> atom -> repr
val bor  : repr -> atom -> repr

(* comparison *)
val eq  : repr -> atom -> repr
val neq : repr -> atom -> repr
val lt  : repr -> atom -> repr
val leq : repr -> atom -> repr
val gt  : repr -> atom -> repr
val geq : repr -> atom -> repr
