(* An extension to the compiler
*)

include Compiler_35
let lift1 = Qna.lift1
let lift2 = Qna.lift2

(* if without else. Must be of the void type *)
let if2  : repr -> repr -> repr = fun test th ->
  let* (testty,testblk) = test in
  let* (thty,thblk)     = th in
  Ty.check_type Ty.bool testty ~msg:": test of the conditional";
  Ty.check_type Ty.void thty  ~msg:": short-if should have the void type";
  Qna.ans (Ty.void, CG.if2 testblk thblk)

(* if-then-else *)
let if3  : repr -> repr -> repr -> repr = fun test th el ->
  let* (testty,testblk) = test in
  let* (thty,thblk)     = th in
  let* (elty,elblk)     = el in
  Ty.check_type Ty.bool testty ~msg:": test of the conditional";
  Ty.check_type thty elty 
      ~msg:": the branches of the conditional must have the same type";
  Qna.ans (thty, CG.if3 testblk thblk elblk)

(* Re-implementing the comparison operators from step32:
   as before, they are polymorphic: they take values of the same type.
   However, their functionality is not polymorphic. Strings take a particular
   implementation. Also, there is no comparison for voids.
   One may say, comparison is overloaded: ad hoc overloading.
*)

let type_cnv_comp 
    (cintbool: 'a -> 'b -> 'c)
    (cstring: 'a -> 'b -> 'c) : (Ty.t * 'a) -> (Ty.t * 'b) -> (Ty.t * 'c) =
    fun (ty1,c1) (ty2,c2) -> 
      Ty.check_type ty1 ty2;
      let resolved =
        if Ty.eq ty1 Ty.string then cstring
        else if Ty.eq ty1 Ty.int then cintbool
        else if Ty.eq ty1 Ty.bool then cintbool
        else Ty.type_error "cannot compare values of type %s" (Ty.to_string ty1)
      in
      (Ty.bool, resolved c1 c2)

let eq  : repr -> atom -> repr = 
  type_cnv_comp
    CG.eq 
    (fun e a -> CG.call Asm.(name "string_eq") e [a])
   |>  lift2
let neq : repr -> atom -> repr = 
  type_cnv_comp 
    CG.neq  
    (fun e a -> CG.not @@ CG.call Asm.(name "string_eq") e [a])
  |>  lift2
let lt  : repr -> atom -> repr = 
  type_cnv_comp 
    CG.lt
    (fun e a -> CG.call Asm.(name "string_less") e [a])
  |>  lift2
let leq  : repr -> atom -> repr = 
  type_cnv_comp 
    CG.leq
    (fun e a -> CG.not @@ CG.call Asm.(name "string_greater") e [a])
  |>  lift2
let gt  : repr -> atom -> repr = 
  type_cnv_comp 
    CG.gt
    (fun e a -> CG.call Asm.(name "string_greater") e [a])
  |>  lift2
let geq  : repr -> atom -> repr = 
  type_cnv_comp 
    CG.geq
    (fun e a -> CG.not @@ CG.call Asm.(name "string_less") e [a])
  |>  lift2


let while_loop : repr -> repr -> repr = fun test body ->
  let* (testty, testblk) = test in
  let* (bodyty, bodyblk) = body in
  Ty.check_type Ty.bool testty ~msg:": test of the while loop";
  Ty.check_type Ty.void bodyty ~msg:": body of the while loop must be void";
  Qna.ans (Ty.void, CG.while_loop testblk bodyblk)