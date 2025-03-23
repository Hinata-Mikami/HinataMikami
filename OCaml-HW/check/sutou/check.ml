
print_endline "Checking chapter4";;

#use "ans4_1.ml";;
let fcurry x y = x *. y;;
let fpair = uncurry fcurry;;
fcurry 4.2 5.;;
fpair (4.2, 5.);;
print_endline "Checked 4-1";;

#use "ans4_2.ml";;
fib 15;;
print_endline "Checked 4-2";;

#use "ans4_3.ml";;
#trace funny;;
funny (fun x -> x *. 2.) 10 2.;;
#untrace funny;;
print_endline "Checked 4-3";;

#use "ans4_4.ml";;
print_endline "Checked 4-4";;
#use "ans4_5.ml";;
print_endline "Checked 4-5";;
#use "ans4_6.ml";;
print_endline "Checked 4-6";;

print_endline "Checked chapter4";;
