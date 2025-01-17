(* Extended code generator *)

include Code_gen_35

let if2 : repr -> repr -> repr = fun tst th ->
  let open Sq in
  let open Asm in
  let label = new_label () in
  tst @ 
  one (test (reg rax) (reg rax)) @ 
  one (je label) @ 
  th @ 
  one (set_label label)

(* TODO: if repr is extended, be sure both branches deliver the result
   consistently, e.g., in the same register (or both deliver no result)

   I think it might improve the precision of the variable allocation
   if we use a special merging of th and el branches (rather than
   the usual merge). OTH, the usual merge doesn't seem to affect the conflicts.
   see the test with lets in both if branches.
*)
let if3 : repr -> repr -> repr -> repr = fun tst th el ->
  let open Sq in
  let open Asm in
  let label_el  = new_label () in
  let label_end = new_label () in
  tst @ 
  one (test (reg rax) (reg rax)) @
  one (je label_el) @
  th @ 
  one (jmp label_end) @
  one (set_label label_el) @
  el @ 
  one (set_label label_end)
