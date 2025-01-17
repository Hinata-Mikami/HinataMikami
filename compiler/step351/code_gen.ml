(* Extended code generator *)

include Code_gen_34

(*
    On my Linux distribution,
    compiling C code like 
       void foo(void) { printf("message")} 
    produces
    .text
       mov $LC, %rdi
       call puts
    .data
       .LC .asciz "message"

This uses the 32-bit absolute addressing in mov $LS, %rdi

This is the most performant way, that is my gcc does it when can.
Alas, for the sake of ALSR (security), many distributions have switched to
-pie by default. On these distributions, gcc would pass the -pie flag to
the linker. In this case, 32-bit absolute addressing (actually, 32-bit
relocation in R_X86_64_32S) is not allowed and the linker reports an error.

Incidentally, 64-bit relocation R_X86_64_64 is allowed, even in PIE.
I (used to) use this.

See objdump -drz to check
*)

(* String literals are expressions: require allocation *)
let string : string -> repr = fun s -> 
  let open Asm in
  let slabel = new_label ~prefix:"C" () in (* address of the string address *)
  snocs [
   segment_data ();
   align 4; 
   set_label slabel;
   data_uint32 (String.length s)] Sq.empty |>
   fun l ->
   String.to_seq s |> Seq.map (fun c -> data_uint8 (Char.code c)) |>
     Seq.fold_left (Fun.flip snoc) l |>
  snocs [
   segment_text ();
   leaq (rip_offset slabel) rax;
  ]



  (* let comparison_string (f: Asm.operand -> Asm.instr) :
  repr -> atom -> repr = fun ins a ->
    let open Asm in
    snocs Asm.[
      movq a (reg rdi);
      movq (reg rax) (reg rsi); 
      call (Asm.name "compare_tistrings");
      test (reg rax) (reg rax); 
      f (reg al);
      movzb (reg al) (reg rax);
    ] ins


let eq_s  : repr -> atom -> repr = comparison_string Asm.sete
let neq_s : repr -> atom -> repr = comparison_string Asm.setne
let lt_s  : repr -> atom -> repr = comparison_string Asm.setl
let leq_s : repr -> atom -> repr = comparison_string Asm.setle
let gt_s  : repr -> atom -> repr = comparison_string Asm.setg
let geq_s : repr -> atom -> repr = comparison_string Asm.setge *)