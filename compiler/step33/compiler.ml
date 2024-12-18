(* An extension of the compiler to substitute val-bindings that are known
   to be atoms
*)

include Compiler_32

(* For local variables, no need to allocate anything *)
let local_atom : vname * atom -> repr -> repr = fun (name,atom) body ->
  let* atom = atom in
  Qna.handle (VarQ.plug (name,atom)) body
