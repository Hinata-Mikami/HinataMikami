(* Extended code generator *)

include Code_gen_36

(* Obvious approach: pretty much like `if test then fi'. 
   However, too much branching during the iteration 

let while_ : repr -> repr -> repr = fun tst body ->
  let label_beg = Asm.new_label () in
  let label_end = Asm.new_label () in
  Asm.(set_label label_beg @ tst @ test rax rax @ je label_end @ 
       body @ jmp label_beg @ set_label label_end)
*)

(* Although less natural, there is only one jump during iterations *)
let while_ : repr -> repr -> repr = fun tst body ->
  let open Asm in
  let open Sq in
  let label_again = new_label () in
  let label_test  = new_label () in
  one (jmp label_test) @ 
  one (set_label label_again) @
  body @
  one (set_label label_test) @
  tst @ 
  one (test (reg al) (reg al)) @ 
  one (jne label_again)

let incr : vreg -> repr = fun vr ->
  Sq.one Asm.(incq (hole vr))
