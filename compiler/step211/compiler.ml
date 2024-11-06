(* Another implementation of lang.mli: Code-generator *)

(* Assumptions:
   %rdi always contains the value of the variable x

  There are no function calls in expressions (so, no need to save
  caller-save registers)
   ...
*)


type repr =                             (* representation type *)
    Asm.instr         (* instruction sequence placing the result in %rax *)

let int  : Int64.t -> repr = fun x -> 
  Asm.(movq (imm x) (reg rax))


let varx : repr = Asm.(movq (reg rdi) (reg rax))

(* Or use something like: add Int Asm.(negq rax) *)

let neg  : repr -> repr = fun seq -> Asm.(seq @ negq (reg rax))

let succ  : repr -> repr = fun seq -> Asm.(seq @ incq (reg rax))  (* Or leaq *)
let pred  : repr -> repr = fun seq -> Asm.(seq @ decq (reg rax)) 

(* Call a function with one argument *)
let call1 : string -> repr -> repr = fun n seq ->
  Asm.(seq @ movq (reg rax) (reg rdi) @ call (name n)) 

type obs = out_channel -> unit     (* observation type *)

let observe : repr -> obs = fun seq ch ->
  let open Asm in
  seq |>
  call1 "print_int" |>
  make_function (name "ti_main")  |>
  write_file ch
