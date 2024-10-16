(* An elementary (too elementary) emulator for a tiny subset of
   x86-64, just enough to run the assembly code in Sec 2 of Notes

   It also serves to remind the CPU architecture and introduce assembly
   language. It emulates at the level of assembly instructions
   (since we won't be dealing with instruction encoding in the class)
   and illutrates instruction format, operands, addressing modes, etc.
   Therefore it is deliberately trivial, for the sake of explanation

*)

type word = int              (* Should probably be int64, but conversions
                                get in the way *)

(* Architecture Registers (64 bit) *)
type reg = int
let   rax = 0 and rbx = 1 and rcx = 2 and rdx = 3 and rsi = 4 and rdi = 5
  and rbp = 6 and rsp = 7 and r8  = 8 and r9  = 9 and r10 =10 and r11 = 11
  and r12 =12 and r13 =13 and r14 =14 and r15 =15

type cpu_state = {
    rip: int ref;      (* instruction pointer *)
    regs: word array;  (* register file *)
    (* Flags *)
    sf: bool ref;      (* set if negative *)
    zf: bool ref;      (* set if zero *)
    halted: bool ref;
 }


type instr = 
  (* The same mnemonic movq is used for several intructions (with different
     opcodes). We stay close to hardware and keep this distinction
  *)
  | MOV_toreg of reg * rm
  | MOV_frreg of reg * rm 
  | MOV_immr of int * reg
  | MOV_imm  of int * rm
  | ADD_imm  of int * rm
  | ADD_toreg  of reg * rm
  | ADD_frreg  of reg * rm
  | SUB_imm  of int * rm
  | SUB_toreg  of reg * rm
  | SUB_frreg  of reg * rm
  | CMP_imm  of int * rm
  | CMP_toreg of reg * rm
  | CMP_frreg of reg * rm
  | CALL of extprog
  | JMP of int
  | JLE of int
  | RET
 (* addressing mode for addressing a register or memory *)
 and rm =
  | Reg of reg
  | Ind of reg         (* access memory at the address in reg *)
  | Off of int * reg   (* access memory at the address in reg + offset *)

 (* calls to BIOS, so to speak: emulated as a pseudo-op *)
 and extprog =
  | ReadInt            (* read an integer *)
  | PrintInt           (* print an integer *)

(* One can say that memory is just one big array
   Actually, keeping in mind memory banks and page permissions, etc.
   it is not wrong to consider memory a collection of several distinct
   areas
*)
type memory = {
   instructions : instr array;
   data         : word array;
 }

(* Main CPU loop *)
let cpu_loop {rip;regs;sf;zf;halted} (mem:memory) : unit = 
  (* execute an instruction and update the state *)
  let execute : instr -> unit = function
   | MOV_toreg (rd, Reg rs) ->
     regs.(rd) <- regs.(rs)
   | MOV_toreg (rd, Ind rs) ->
     regs.(rd) <- mem.data.(regs.(rs))
   | MOV_toreg (rd, Off(off,rs)) ->
     regs.(rd) <- mem.data.(regs.(rs) + off)
   | MOV_frreg (rs, Reg rd) ->
     regs.(rd) <- regs.(rs)
   | MOV_frreg (rs, Ind rd) ->
     mem.data.(regs.(rd)) <- regs.(rs) 
   | MOV_frreg (rs, Off(off,rd)) ->
     mem.data.(regs.(rd) + off) <- regs.(rs)
   | MOV_immr  (imm,rd) ->
     regs.(rd) <- imm
   | MOV_imm (imm, Reg rd) ->
     regs.(rd) <- imm
   | MOV_imm (imm, Ind rd) ->
     mem.data.(regs.(rd)) <- imm
   | MOV_imm (imm, Off(off,rd)) ->
     mem.data.(regs.(rd) + off) <- imm

   | ADD_toreg (rd, Reg rs) ->
     let t = regs.(rd) + regs.(rs) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | ADD_toreg (rd, Ind rs) ->
     let t = regs.(rd) + mem.data.(regs.(rs)) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | ADD_toreg (rd, Off(off,rs)) ->
     let t = regs.(rd) + mem.data.(regs.(rs) + off) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | ADD_frreg (rs, Reg rd) ->
     let t = regs.(rd) + regs.(rs) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | ADD_frreg (rs, Ind rd) ->
     let t = mem.data.(regs.(rd)) + regs.(rs) in
     mem.data.(regs.(rd)) <- t; sf := t < 0; zf := t = 0
   | ADD_frreg (rs, Off(off,rd)) ->
     let t =  mem.data.(regs.(rd) + off) + regs.(rs) in
     mem.data.(regs.(rd) + off) <- t; sf := t < 0; zf := t = 0
   | ADD_imm (imm, Reg rd) ->
     let t = regs.(rd) + imm in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | ADD_imm (imm, Ind rd) ->
     let t = mem.data.(regs.(rd)) + imm in
     mem.data.(regs.(rd)) <- t; sf := t < 0; zf := t = 0
   | ADD_imm (imm, Off(off,rd)) ->
     let t = mem.data.(regs.(rd) + off) + imm in
     mem.data.(regs.(rd) + off) <- t; sf := t < 0; zf := t = 0

   | SUB_toreg (rd, Reg rs) ->
     let t = regs.(rd) - regs.(rs) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | SUB_toreg (rd, Ind rs) ->
     let t = regs.(rd) - mem.data.(regs.(rs)) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | SUB_toreg (rd, Off(off,rs)) ->
     let t = regs.(rd) - mem.data.(regs.(rs) + off) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | SUB_frreg (rs, Reg rd) ->
     let t = regs.(rd) - regs.(rs) in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | SUB_frreg (rs, Ind rd) ->
     let t = mem.data.(regs.(rd)) - regs.(rs) in
     mem.data.(regs.(rd)) <- t; sf := t < 0; zf := t = 0
   | SUB_frreg (rs, Off(off,rd)) ->
     let t =  mem.data.(regs.(rd) + off) - regs.(rs) in
     mem.data.(regs.(rd) + off) <- t; sf := t < 0; zf := t = 0
   | SUB_imm (imm, Reg rd) ->
     let t = regs.(rd) - imm in
     regs.(rd) <- t; sf := t < 0; zf := t = 0
   | SUB_imm (imm, Ind rd) ->
     let t = mem.data.(regs.(rd)) - imm in
     mem.data.(regs.(rd)) <- t; sf := t < 0; zf := t = 0
   | SUB_imm (imm, Off(off,rd)) ->
     let t = mem.data.(regs.(rd) + off) - imm in
     mem.data.(regs.(rd) + off) <- t; sf := t < 0; zf := t = 0

   | CMP_toreg (rd, Reg rs) ->
     let t = regs.(rd) - regs.(rs) in
     sf := t < 0; zf := t = 0
   | CMP_toreg (rd, Ind rs) ->
     let t = regs.(rd) - mem.data.(regs.(rs)) in
     sf := t < 0; zf := t = 0
   | CMP_toreg (rd, Off(off,rs)) ->
     let t = regs.(rd) - mem.data.(regs.(rs) + off) in
     sf := t < 0; zf := t = 0
   | CMP_frreg (rs, Reg rd) ->
     let t = regs.(rd) - regs.(rs) in
     sf := t < 0; zf := t = 0
   | CMP_frreg (rs, Ind rd) ->
     let t = mem.data.(regs.(rd)) - regs.(rs) in
     sf := t < 0; zf := t = 0
   | CMP_frreg (rs, Off(off,rd)) ->
     let t =  mem.data.(regs.(rd) + off) - regs.(rs) in
     sf := t < 0; zf := t = 0
   | CMP_imm (imm, Reg rd) ->
     let t = regs.(rd) - imm in
     sf := t < 0; zf := t = 0
   | CMP_imm (imm, Ind rd) ->
     let t = mem.data.(regs.(rd)) - imm in
     sf := t < 0; zf := t = 0
   | CMP_imm (imm, Off(off,rd)) ->
     let t = mem.data.(regs.(rd) + off) - imm in
     sf := t < 0; zf := t = 0


   | JMP off ->
     rip := !rip + off
   | JLE off ->
     if !zf || !sf then rip := !rip + off

   | CALL ReadInt ->
     Scanf.scanf " %d" (fun x -> regs.(rax) <- x)
   | CALL PrintInt ->
     Printf.printf "val %d\n" regs.(rdi)
   | RET ->
     halted := true
  in

  (* main loop *)
  while(not !halted) do
   let i = mem.instructions.(!rip) in
   incr rip;
   execute i
  done

(* Later on we see a more pleasant way to enter assembly,
   using tagless-final style
*)
let mymain = [|                         
  SUB_imm   (40,  Reg rsp);
  CALL      ReadInt;
  MOV_frreg (rax, Off (8,rsp));
  MOV_imm   (0,   Off (24,rsp));
  MOV_imm   (1,   Off (16,rsp));
  JMP       5;   (* L5 *)
  CALL      ReadInt;    (* L6 *)
  MOV_frreg (rax, Ind rsp);
  MOV_toreg (rax, Ind rsp);
  ADD_frreg (rax, Off (24,rsp));
  ADD_imm   (1,   Off (16,rsp));
  MOV_toreg (rax, Off (16,rsp));
  CMP_toreg (rax, Off (8,rsp));
  JLE       (-8);         (* to L6 *)
  MOV_toreg (rax, Off (24,rsp));
  MOV_frreg (rax, Reg rdi);
  CALL      PrintInt;
  ADD_imm   (40,  Reg rsp);
  RET
 |]

(* Reset and start working. Basically this is what happens if you boot up *)
let reset : instr array -> unit = fun instructions ->
  let data_len = 1000 in
  let mem = {instructions; data = Array.make data_len 0} in
  let cpu = {rip = ref 0;
             regs = Array.make 16 0;
             sf = ref false; zf = ref false; halted = ref false } in
  cpu.regs.(rsp) <- data_len - 1;
  cpu_loop cpu mem

let () = reset mymain

;;
