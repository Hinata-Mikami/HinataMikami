let rec squares r =
  (*探査範囲の上限を決定。sqrt()の値は切り捨てでよい。
    (上限を議論するのはrが平方数の2倍のときであり，このときsqrt()は整数)*)
  let sup = int_of_float (sqrt ( (float_of_int r)/. 2.))
  in

  (*平方数かどうかを判定。bool型を返す*) 
  let is_square n =
    let tmp  = int_of_float (sqrt (float_of_int n))
      in if tmp * tmp = n then true else false
  in 

  (*リストの組をすべて反転させる関数*)
  let rec convert list =
    match list with
      [] -> []
    | (x, y)::rest -> (y, x)::(convert rest)
  in

  (*0<=x<=supで解に適するものを探索しリストに保存*)
  (*引数a:範囲の最小値 b:範囲の最大値 c:r*)
  let rec search_squares a b c =
    match a with
      x when x > b -> []
    | x when (x <= b) && (is_square (c - x*x)) 
    -> (x, int_of_float (sqrt ( float_of_int (c - x*x))))::(search_squares (x+1) b c)
    | x when x <= b -> search_squares (x+1) b c
  in 
  convert (search_squares 0 sup r);;

squares 48612265;;



(*構想*)
(*
  x^2 + y^2 = r
について，
  2x^2 <= r
  x^2 <= r/2
  x <= sqrt (r/2)
より，x <= sqrt (r/2)を走査すればよい
r/2 < x^2 <= r については考える必要がない。

この範囲で，あるx^2に対し
  r - x^2 = y^2
となる整数yを探す。そのためにはある整数が平方数であるかどうかを判定する関数が必要

よって，方針は
sqrt(r/2)を計算-> sup = int_of_float sqrt (r/2)
ある任意整数nが平方数であるかどうかを判定する関数を作成

0 <= x <= sup における各xについて，
r - x^2　を計算しこれが平方数であるかどうか判定 trueならリストに保存

リストを返す。

なお，x>=y>=0が条件なのに対し，このままではy>=x>=0の組として求まってしまうので，
リストの組(a, b)をすべて(b, a)に反転し出力する。

*)