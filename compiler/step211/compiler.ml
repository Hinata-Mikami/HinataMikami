(* Another implementation of lang.mli: Code-generator *)

(* Assumptions:
   %rdi always contains the value of the variable x

  There are no function calls in expressions (so, no need to save
  caller-save registers)
   ...
*)

(* repr = Asm.instr * int*)
(* 0 -> var x *)
(* 1 -> integer expression (int, neg, succ, pred)*)
(* 2 -> boolean expression (bool, not, is_zero(int)) *)
(* -1 -> invalid expression*)

type repr =                             (* representation type *)
    (Asm.instr * int)       (* instruction sequence placing the result in %rax *)

let int  : Int64.t -> repr = fun x -> 
  (Asm.(movq (imm x) (reg rax)), 1)



let varx : repr = (Asm.(movq (reg rdi) (reg rax)), 0)

(* Or use something like: add Int Asm.(negq rax) *)

let neg  : repr -> repr = fun (seq, i) -> 
  match i with
  | 0 | 1 -> (Asm.(seq @ negq (reg rax)), 1)
  | 2 | _ -> (Asm.(seq @ negq (reg rax)), -1)


let succ  : repr -> repr = fun (seq, i) -> 
  match i with 
  | 0 | 1 -> (Asm.(seq @ incq (reg rax)), 1)  (* Or leaq *)
  | 2 | _ -> (Asm.(seq @ incq (reg rax)), -1)

let pred  : repr -> repr = fun (seq, i) -> 
  match i with
  | 0 | 1 -> (Asm.(seq @ decq (reg rax)), 1)
  | 2 | _ -> (Asm.(seq @ decq (reg rax)), -1)



(* Ex7 *)
let bool : Bool.t -> repr = fun x ->
  match x with
  | true -> (Asm.(movq (imm 1L) (reg rax)), 2)
  | false -> (Asm.(movq (imm 0L) (reg rax)), 2)

let not : repr -> repr = fun (seq, i) -> 
  match i with
  | 0 | 2 -> (Asm.(seq @ xorq (imm 1L) (reg rax)), 2)
  | 1 | _ -> (Asm.(seq @ xorq (imm 1L) (reg rax)), -1)

let is_zero : repr -> repr = fun (seq, i) -> 
  match i with
  | 0 | 1 -> (Asm.(seq @ testq (reg rax) (reg rax) @ setz (reg al) @ movzb (reg al) (reg rax)), 2)
  | 2 | _ -> (Asm.(seq @ testq (reg rax) (reg rax) @ setz (reg al) @ movzb (reg al) (reg rax)), -1)



(* Call a function with one argument *)
let call1 : string -> Asm.instr -> Asm.instr = fun n seq ->
  Asm.(seq @ movq (reg rax) (reg rdi) @ call (name n))

type obs = out_channel -> unit     (* observation type *)

let observe : repr -> obs = fun (seq, i) ch ->
  match i with
  | 2 -> 
    let open Asm in
    seq |>
    call1 "print_bool" |>
    make_function (name "ti_main")  |>
    write_file ch
  | 0 | 1 ->
    let open Asm in
    seq |>
    call1 "print_int" |>
    make_function (name "ti_main")  |>
    write_file ch
  | _ -> ()

