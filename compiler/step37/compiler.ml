(* An extension to the compiler
*)

include Compiler_36

let while_ : repr -> repr -> repr = fun test body ->
  let* (test_ty, test_blk) = test in
  let* (body_ty, body_blk) = body in
  Ty.check_type Ty.bool test_ty  ~msg:": test of while";
  Ty.check_type Ty.void body_ty  ~msg:": while body should have the void type";
  Qna.ans (Ty.void, CG.while_ test_blk body_blk)

(*
The for-loop 
   for i=lwb to upbv do exp done
is essentially the whie loop
   let var i:=lwb in
   while i <= upbv do exp; i := i + 1 done
   end

with the only difference is that we treat i in the exp as immutable
(so, we don't allow the mutations to it)
*)

(* increment *)
let incr : vname -> repr = fun name ->
  let* (vty,_) = var name in
  Ty.check_type vty Ty.int ~msg:": in increment";
  Fun.flip Qna.lift1 (mutble name) @@ function
  | Some v -> (Ty.void, CG.incr v)
  | None   -> Ty.type_error "increment of an immutable var %s" name

(* treat a variable as immutable within an expression *)
let as_immutable (name:vname) (exp:repr) : repr = 
  Qna.handle (MutQ.plug (name, None)) exp

let for_  : (vname*repr) -> atom -> repr -> repr = fun (name,lwb) upb body ->
  (* although the following four lines are unnecessary, they give better
     error messages for for-loop *)
  let* (lwb_ty, _) = lwb in
  let* (upb_ty, _) = upb in
  Ty.check_type Ty.int lwb_ty  ~msg:": lower-bound of for";
  Ty.check_type Ty.int upb_ty  ~msg:": upper-bound of for";
  local ~mut:true (name,lwb) @@
  while_ (leq (atomic (var name)) upb) @@
  (seq (as_immutable name body) @@ incr name)
