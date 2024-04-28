let f = ref (fun y -> y + 1)
(*f = {contents : fun y -> y + 1}*)

let funny_fact x = 
  if x = 1 then 1 
  else x * (!f (x - 1));;
(*!f でf.contentsを呼び出す*)

f := funny_fact;;
(*fをfunny_factに書き換え*)

(*fはfunny_fact関数中でfunny_factに置き換わるため，else 以降は実質 x * (funny_fact (x-1))となり，再帰計算的役割を果たしている。
*)