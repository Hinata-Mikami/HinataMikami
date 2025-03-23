(*float_of_int int_of_float 5.0;;*)
float_of_int (int_of_float 5.0);;

(*sin 3.14 /. 2.0 ** 2.0 +. cos 3.14 /. 2.0 ** 2.0;;*)
(sin (3.14 /. 2.0)) ** 2.0 +. (cos (3.14 /. 2.0)) ** 2.0;;

(*sqrt 3 * 3 + 4 * 4;;*)
int_of_float(sqrt(float_of_int(3 * 3 + 4 * 4)));;