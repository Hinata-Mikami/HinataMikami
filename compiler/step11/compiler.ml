(* The second version of the compiler
   It takes an input stream
   and produces the the assembly code file
   in the given output stream
*)

let compile (ich:in_channel) (och:out_channel) : unit =
  (*Fixed in Ex2: %d -> %Ld *)
  let n = Scanf.bscanf (Scanf.Scanning.from_channel ich) "%Ld" Fun.id in
  let open Asm in
  (movq (imm n) (reg rdi) @ call "print_int") |> make_function "ti_main" |>
  write_file och
