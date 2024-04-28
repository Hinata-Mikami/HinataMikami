type 'a tree = Lf | Br of 'a * 'a tree * 'a tree;;

(*1-2-3-4*)
let t1 = Br(1, Lf, Br(2, Lf, Br(3, Lf, Br(4, Lf, Lf))));;

(*1-2-4-3*)
let t2 = Br(1, Lf, Br(2, Lf, Br(4, Br(3, Lf, Lf), Lf)));;

(*1-3-2-4*)
let t3 = Br(1, Lf, Br(3, Br(2, Lf, Lf), Br(4, Lf, Lf)));;

(*1-4-2-3*)
let t4 = Br(1, Lf, Br(4, Br(2, Lf, Br(3, Lf, Lf)), Lf));;

(*1-4-3-2*)
let t5 = Br(1, Lf, Br(4, Br(3, Br(2, Lf, Lf), Lf), Lf));;

(*2-1-3-4*)
let t6 = Br(2, Br(1, Lf, Lf), Br(3, Lf, Br(4, Lf, Lf)));;

(*2-1-4-3*)
let t7 = Br(2, Br(1, Lf, Lf), Br(4, Br(3, Lf, Lf), Lf));;

(*3-1-2-4*)
let t8 = Br(3, Br(1, Lf, Br(2, Lf, Lf)), Br(4, Lf, Lf));;

(*3-2-1-4*)
let t9 = Br(3, Br(2, Br(1, Lf, Lf), Lf), Br(4, Lf, Lf));;

(*4-1-2-3*)
let t10 = Br(4, Br(1, Lf, Br(2, Lf, Br(3, Lf, Lf))), Lf);;

(*4-1-3-2*)
let t11 = Br(4, Br(1, Lf, Br(3, Br(2, Lf, Lf), Lf)), Lf);;

(*4-2-1-3*)
let t12 = Br(4, Br(2, Br(1, Lf, Lf), Br(3, Lf, Lf)), Lf);;

(*4-3-1-2*)
let t13 = Br(4, Br(3, Br(1, Lf, Br(2, Lf, Lf)), Lf), Lf);;

(*4-3-2-1*)
let t14 = Br(4, Br(3, Br(2, Br(1, Lf, Lf), Lf), Lf), Lf);;