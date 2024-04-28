let array_iteri f array =
  let i = ref 0 in
  let condition = ref true in
  while !condition = true do
    begin
      try f !i array.(!i); i := !i + 1 
      with Invalid_argument "index out of bounds" -> condition := false
    end
  done;;  

(* Test *)
array_iteri (fun i s -> print_string "Station #"; print_int i;
print_string ": "; print_endline s) [|"Tokyo"; "Shinagawa"; "Shin-Yokohama"; "Nagoya"; "Kyoto"; "Shin-Osaka"|];;

(*
Station #0: Tokyo
Station #1: Shinagawa
Station #2: Shin-Yokohama
Station #3: Nagoya
Station #4: Kyoto
Station #5: Shin-Osaka
- : unit = ()
*)