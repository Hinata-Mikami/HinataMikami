(*プログラミング in OCaml 冬休みの課題*)
(*練習問題 4.1*)
  let curry f x y = f (x, y)
  let uncurry f (x, y) =  f x y
  (*
    val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c = <fun>
    # let curried_avg = curry average;;
    val curried_avg : float -> float -> float = <fun>
    # let avg = uncurry curried_avg in avg (4.0, 5.3);;
    - : float = 4.65
  *)
  let average (x, y) = (x +. y) /. 2.0

(*練習問題 4.2*)
  let rec repeat f n x = 
    if n > 0 then repeat f (n - 1) (f x) else x

  let fib n =
    let (fibn, _) = 
      let next_pair (a, b) = (b, a + b) (* 1回ごとの操作*)
      in repeat next_pair n (0, 1) 
    in fibn;;
  (*
    # fib 5;;
    - : int = 5
  *)

(*練習問題 4.3*)
  (*
    let rec funny f n =
      if n = 0 then 
        id
      else if n mod 2 = 0 then 
        funny (f $ f) (n / 2)
      else
        funny (f $ f) (n / 2) $ f

    なお，$ は関数の合成を表す．
    # ($);;
    - : (’a -> ’b) -> (’c -> ’a) -> ’c -> ’b = <fun>

    funny f 3 を考えてみる．
    funny f 3 -->* funny (f $ f) 1 $ f
              -->* funny (g $ g) 0 $ g $ f  ただし，g = f $ f
              -->* funny id $ g $ f
              -->* g $ f
              -->  f^3
    funny f n は n が奇数の時は funny (f $ f) n/2 $ f，偶数の時は funny (f $ f) n/2
    に評価される．言い換えると，n を右シフトした n>> と，はみ出た桁 a0 に対して，
    funny (f $ f) n>> $ f^a0 という式が返ってくる．また，funny f 0 --> id であるから，
    最後の桁がはみ出たときにはそれまでの結果がそのまま置かれるだけである．これは繰り返し二乗法による累乗の計算と
    同じ形の計算であるから，funny f n は f^n (f を n 回合成した関数)を返す．  
  *)

(*練習問題 4.4*)
  (*
    let k x y = x
    let s x y z = x z (y z)

    k とまったく同じことをする関数 t を宣言(let t x y = x)すると，

    #s k t 1
    s <-- <fun>
    s --> <fun>
    s* <-- <fun>
    s* --> <fun>
    s** <-- <poly>
    t <-- <poly>
    t --> <fun>
    k <-- <poly>
    k --> <fun>
    k* <-- <poly>
    k* --> <poly>
    s** --> <poly>
    - : int = 1

    となった．fun や poly の型と中身を追っていくと，

    s <-- k ('a -> 'b -> 'a) 
    s --> (('a -> 'b) -> 'a -> 'c)
    これを s* とおいて，
    s* <-- t ('a -> ('b -> 'a))
    s* --> ('a -> 'c = 'a)
    これを s** とおいて，
    s** <-- 1 ('a = int)
    t <-- 1 ('a = int)
    t --> ('b -> 1)
    k <-- 1 ('a = int)
    k --> ('b -> 1)
    これを k* とおいて，
    k* <-- t ('b = ('d -> 'e -> 'd))
    k* --> 1 ('a = int)
    s** --> 1 ('c = 'a = int)
    - : int = 1

    のようになる．また，計算ステップは以下のようになる．

    s k k 1 --> k 1 (k 1)
            --> 1

    以上により，s k k は恒等演算子として働く．
  *)

(*練習問題 4.5*)
  (*
    let twice f x = f (f x)

    関数適用は左結合であるから，
    twice twice f x の解釈は twice (twice f) x となるので，
    
    twice twice f x --> twice f (twice f x)
                    --> twice f (f (f x))
                    --> f (f (f (f x)))
    のように評価される．
  *)

(*練習問題 4.6*)
  (*
    fun x y -> y
    (- : 'a -> 'b -> 'b = <fun>)

    'b -> 'b は恒等演算であるから，'a -> (s k k 'b) となれば良い．よって，
    fun x y -> y は，k (s k k) x y と表すことができる．

    この評価列は
    k (s k k) x y --> (k (s k k) x) y
                  --> s k k y
                  --> y
  *)
