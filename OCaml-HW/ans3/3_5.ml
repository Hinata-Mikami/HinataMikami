(* let x = 1 and y = x *)
(* x と y は同時に束縛されるため，
   x が直前までに定義されていないと
   Error : unbound value x となる*)

let x = 0 let y = x
(* x と y は順に束縛されるため，
   y = x の段階で x は使用可能である*)

