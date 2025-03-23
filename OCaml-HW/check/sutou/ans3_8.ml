(* 練習問題 3.8 *)

let iterpow (x,n) = 
  let rec subiter (i,res) = 
    if i = n + 1 
    then res
    else subiter (i+1, res *. x)
  in
  subiter (1,1.);;