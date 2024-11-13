(* Another implementation of lang.mli: Code-generator *)

(* Assumptions:
   %rdi always contains the value of the variable x

  There are no function calls in expressions (so, no need to save
  caller-save registers)
   ...
*)

(* Actually, re-written and adjusted. 
   TODO. Could've written Code_gen_21 better to start with
include Code_gen_21
*)

type repr =                             (* representation type *)
    Asm.instr Sq.t        (* instruction sequence placing the result in %rax *)

let int  : Int64.t -> repr = fun x -> 
  Sq.one Asm.(movq (imm x) (reg rax))

let varx : repr = Sq.one Asm.(movq (reg rdi) (reg rax))

let snoc : Asm.instr -> repr -> repr = fun i seq -> Sq.(seq @ one i)

let snocs : Asm.instr list -> repr -> repr = fun ii seq -> 
  List.fold_left (Fun.flip snoc) seq ii

let neg  : repr -> repr = snoc Asm.(negq (reg rax))

let succ  : repr -> repr = snoc Asm.(incq (reg rax)) (* Or leaq *)
let pred  : repr -> repr = snoc Asm.(decq (reg rax))

(* Call a function with one argument *)
let call1 : string -> repr -> repr = fun n ->
  snocs Asm.[movq (reg rax) (reg rdi); call (name n)]


(* Additions *)
let bool : bool -> repr = fun x ->
  Sq.one Asm.(movq (imm (if x then 1L else 0L)) (reg rax))

let not  : repr -> repr  = snoc Asm.(xorq (imm 1L) (reg rax))

let is_zero  : repr -> repr  = snocs
  Asm.[test (reg rax) (reg rax);
       setz (reg al);
       movzb (reg al) (reg rax)]


type obs = out_channel -> unit     (* observation type *)

let make_function ?(locals=0) (nm:Asm.symbol) (body:repr) : repr =
  let stack_adj = 8 * if locals mod 2 = 0 then locals + 1 else locals in
  let open Sq in
  snocs Asm.[
   start_function nm;
   label nm;
   subq (imm (Int64.of_int stack_adj)) (reg rsp)] empty @
   body |>
   snocs Asm.[
   addq (imm (Int64.of_int stack_adj)) (reg rsp);
   ret]

(* No longer adding the call to print_it: this is now the job of the
   compiler
*)
let observe : repr -> obs = fun seq ch ->
  seq |>
  make_function (Asm.name "ti_main")  |>
  Sq.iter (Asm.print ch)

