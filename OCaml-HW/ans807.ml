let rec iter f = function
   [] -> ()
  | a :: rest -> begin f a; iter f rest end;;

let array_iter f array =
  let index = ref 0 in
  let condition = ref true in
  while !condition = true do
    begin
        try f array.(!index); index := !index + 1
        with Invalid_argument "index out of bounds" -> condition := false
    end
  done;;  

(*Test*)
array_iter (fun s -> print_string "Station: "; print_endline s)
[|"Tokyo"; "Shinagawa"; "Shin-Yokohama";
"Nagoya"; "Kyoto"; "Shin-Osaka"|];;

(*
Station: Tokyo
Station: Shinagawa
Station: Shin-Yokohama
Station: Nagoya
Station: Kyoto
Station: Shin-Osaka
- : unit = ()
*)