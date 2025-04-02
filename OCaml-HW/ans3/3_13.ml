let pow x n =
  let rec pow_rec v m acc =
    if m = 0 then acc
    else pow_rec v (m - 1) (v * acc)
  in pow_rec x n 1;;


  let pow2 n x =
    let rec pow_rec v m acc =
      if m = 0 then acc
      else pow_rec v (m - 1) (v * acc)
    in pow_rec x n 1;;
  
  
let cube x = pow2 3 x;;

(*powから定義されたcube*)
let cube x = pow x 3;;