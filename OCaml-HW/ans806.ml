(* while (condition) do body done*)
let rec whle condition body =
  if condition () then
  begin 
    body(); whle condition body 
  end;;

(* for ()*)
let rec fr k up_or_down k_end body =
  if up_or_down = "up" then
    if (k = k_end) = false then
      begin 
        body(); fr (k+1) up_or_down k_end body
      end
    else body()
  else
    if (k = k_end) = false then
      begin 
        body(); fr (k-1) up_or_down k_end body
      end
    else body();;
    

