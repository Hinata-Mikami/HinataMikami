(*プログラミング in OCaml 冬休みの課題*)
(*練習問題 3.1*)
  (* 1~4 *)
  let round x = (* 正の実数を小数第1位で四捨五入する関数 *)
    if floor(x) +. 0.5 > x then int_of_float(x) else int_of_float(x +. 1.0)

  let usd_to_jpy dollar = (* USドル（実数）を受け取って円（整数）に換算する関数 *)
    let rate = 114.32 in (* レートの設定 *)
    let yen = dollar *. rate in (* 円に変換 *)
    round(yen) (* 小数点以下を四捨五入 *)
  
  let jpy_to_usd yen = (* 円（整数）を受け取って，USドル（セント以下を小数にした実数）に換算する関数 *)
    let rate = 114.32 in (* レートの設定 *)
    let cent_f = yen /. rate *. 100.0 in (* 円をセントに換算 *)
    let cent = float_of_int(round(cent_f)) in (* 小数点以下を四捨五入 *)
    cent /. 100.0 (* セントからドルに換算 *)

  let usd_are_yen dollar = (* USドルが何円かを文字列として返す関数 *)
    let yen = usd_to_jpy(dollar) in
    string_of_float(dollar)^" dollars are "^string_of_int(yen)^" yen."

  let capitalize c = (* アルファベットの小文字を受け取って大文字を返す関数 *)
    let capitalize_factor = int_of_char('a') - int_of_char('A') in
    if int_of_char(c) >= 97 && int_of_char(c) <= 122 then 
      char_of_int(int_of_char(c) - capitalize_factor)
    else
      c;;

(*練習問題 3.2*)
  (*
    "a && b" 
    を書き換えると，真理値表から，
    "if a then (if b then true else false) else false"
    または，"if"の使用を一度に限ると，
    "if a then b else false"

    # if true then (if false then true else false) else false;;
    - : bool = false

    #let a = true and b = true;;
    #let a_and_b = if a then b else false;;
    - : val a_and_b : bool = true

    "a || b" 
    を書き換えると，
    "if a then true else b"

    # let a = false and b = true;;
    val a : bool = false
    val b : bool = true
    # if a then true else b;;
    - : bool = true
  *)

(*練習問題 3.3*)
  (*
    "a && b"
    を書き換えると，
    "not (not a || not b)"

    # not (not true || not true);;
    - : bool = true

    "a || b"
    を書き換えると，
    "not (not a && not b)"

    # not (not false && not false);;
    - : bool = false
  *)

(*練習問題 3.4*)
  (*
    1.
      let x = 1 in let x = 3 in let x = x + 2 in x * x
      
      予想：
      let x = 1 in (let x = 3 in (let x = x + 2 in (x * x)))
      という構造であり，let a = e1 in e2 では e1 を評価して a に束縛し，
      その後に e2 を評価するので，各式は x*x -> (x+2)*(x+2) -> (3+2)*(3+2) 
      というように参照され，評価は int = 25 になる．

      結果：
      # let x = 1 in let x = 3 in let x = x + 2 in x * x;;
      Warning 26 [unused-var]: unused variable x.

      - : int = 25
      1つ目の x はスコープ内で使用されないので警告が出た．

      2.
        let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y

        予想：
        x=2，y=3 に束縛した後，x*yにおいて各変数の参照は
        x -> y + 2 -> 3 + 2 = 5
        y -> x -> 2
        であり，+ y においては
        y -> 3
        であるから，全体の評価は int = 13 となる．
        
        結果：
        # let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y;;
        - : int = 13
      
      3.
        let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z

        予想：
        各変数のスコープを値の後ろに括弧で表示すると，
        x = 2 (y = 3 (y = x (z = y+2 (x*y*z))))
        となる．x*y*z における各変数の参照は
        x -> 2
        y -> x -> 2
        z = x + 2 -> 2 + 2 = 4
        となるので，評価結果は int = 16 になる．
        
        結果：
        # let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z;;
        Warning 26 [unused-var]: unused variable y.

        - : int = 16
        1つ目の y はスコープ内で使用されないので警告が出た．
  *)

(*練習問題 3.5*)
  (*
    let x = e1 and y = e2
    と
    let x = e1 let y = e2
    の違い

    上の宣言では x と y が同時束縛されるため，e2 が x を含む式であった場合の参照先は
    let x = e1 ではなくそれよりも前方で宣言・定義された x になる．一方，下の宣言では
    x の後に y が宣言されるため，e2 が x を含む式であった場合の参照先は e1 になる．
    実際に動かしてみると以下のようになった．

    # let x = 100;;
    val x : int = 100
    # let x = 3 and y = x + 2;;
    val x : int = 3
    val y : int = 102

    # let x = 100;;
    val x : int = 100
    # let x = 3 let y = x + 2;;
    val x : int = 3
    val y : int = 5
  *)

(*練習問題 3.6*)
  (* 1~3 *)
  let geo_mean p = (* 2実数の相乗平均をとる関数 *)
    let (x, y) = p in
    x *. y /. 2.0
  (*
    # geo_mean(2.0, 10.0);;
    - : float = 10.
  *)

  let bmi person = (* 身長と体重から体型を判断する関数 *)
    let (name, height, weight) = person in
    let index = weight /. (height *. height) in (* BMI を計算し，その値に従って分類*)
    if index < 18.5 then
      name^"さんはやせ型です"
    else if index < 25. then
      name^"さんは標準体型です"
    else if index < 30. then
      name^"さんは肥満体型です"
    else
      name^"さんは高度肥満です"
  (*
    # bmi("shinagawa", 175.0, 52.5);;
    - : string = "shinagawaさんはやせ型です"
  *)
  
  let sum_and_diff p = (* 2数の和と差を求める関数 *)
    let (x, y) = p in
    let sum = x + y and diff = x - y in
    (sum, diff)
  
  let f p = (* 2数の和と差 x+y と x-y から元の2数 x, y を求める関数*)
    let (sum, diff) = p in
    let x = (sum + diff) / 2 and y = (sum - diff) / 2 in
    (x, y);;
  (*
    # f (sum_and_diff (15, 4));;
    - : int * int = (15, 4)
  *)

(*練習問題 3.7*)
  (* 1, 2 *)
  let rec pow_linear (x, n) = (* n回再帰するpow関数 *)
    if n = 0 then
      1
    else
      x * pow_linear(x, n-1)
  (*
    # #trace pow_linear;;
    pow_linear is now traced.
    # pow_linear (2, 5);;
    pow_linear <-- (2, 5)
    pow_linear <-- (2, 4)
    pow_linear <-- (2, 3)
    pow_linear <-- (2, 2)
    pow_linear <-- (2, 1)
    pow_linear <-- (2, 0)
    pow_linear --> 1
    pow_linear --> 2
    pow_linear --> 4
    pow_linear --> 8
    pow_linear --> 16
    pow_linear --> 32
    - : int = 32
  *)
  
  let rec pow_log (x, n) = (* log n 回再帰するpow関数 *)
    let bit = n mod 2 and quotient = n / 2 in (* 繰り返し2乗法 *)
    if n = 0 then
      1
    else if n = 1 then
      x
    else
      if bit = 1 then
        x * pow_log(x*x, quotient)
      else
        pow_log(x*x, quotient)
  (*
    # #trace pow_log;;
    pow_log is now traced.
    # pow_log (2, 5);;
    pow_log <-- (2, 5)
    pow_log <-- (4, 2)
    pow_log <-- (16, 1)
    pow_log --> 16
    pow_log --> 16
    pow_log --> 32
    - : int = 32
  *)

(*練習問題 3.8*)
  let rec iterpow (x, n) = (* 反復的定義による指数関数 *)
    let rec mul (res, i) =
      if i = n then
        res
      else
        mul(res*x, i+1)
    in
    mul(1, 0);;

  (*
    # iterpow (2, 5);;
    iterpow <-- (2, 5)
    iterpow --> 32
    - : int = 32
  *)

(*練習問題 3.9*)
  (*
    # let cond (b, e1, e2) : int = if b then e1 else e2;;
    val cond : bool * int * int -> int = <fun>
    # let rec fact n = cond ((n = 1), 1, n * fact (n-1));;
    val fact : int -> int = <fun>
    # fact 4;;

    OCaml は値呼びであるから，

    fact <-- 4
    を受けて cond <-- ((4 = 1), 1, 4 * fact (4 - 1)) の引数から
    fact <-- 3
    の呼び出しがあり，それを受けて cond <-- ((3 = 1), 1, 3 * fact (3 - 1)) の引数から
    fact <-- 2
    (以下説明は省略)
    fact <-- 1
    fact <-- 0
    fact <-- -1
    fact <-- -2
    ......

    のように * の引数である fact の評価が cond よりも優先され，
    cond(true, _, _) の評価がいつまでも起きないため，この定義では
    うまく計算することができない．

    # #trace fact;;
    # #trace cond;;
    # fact 4;;
    fact <-- 4
    fact <-- 3
    fact <-- 2
    fact <-- 1
    fact <-- 0
    fact <-- -1
    fact <-- -2
    fact <-- -3
    ......
    fact <-- -353
    fact <-- -354
    ^Cfact <-- fact raises Stdlib.Sys.Break
  *)

(*練習問題 3.10*)
  (*
    let fib n =
      let rec fib_pair n =
        if n = 1 then (1, 0)
        else
          let (i, j) = fib_pair (n - 1) in
          (i + j, i)
      in
      let (i, _) = fib_pair n in i;;
    
    fib 4 -> (i, _) = fib_pair 4 in i
          -> (i, _) = (if 4 = 1 then (1, 0) else let (i, j) = fib_pair (4 - 1) in (i + j, i)) in i
          -> (i, _) = ((i, j) = fib_pair 3 in (i + j, i)) in i
          -> (i, _) = ((i, j) = (if 3 = 1 then (1, 0) else let (i, j) = fib_pair (3 - 1) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = fib_pair 2 in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = (if 2 = 1 then (1, 0) else let (i, j) = fib_pair (2 - 1) in (i + j, i)) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = ((i, j) = fib_pair 1 in (i + j, i)) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = ((i, j) = (if 1 = 1 then (1, 0) else let (i, j) = fib_pair (1 - 1) in (i + j, i)) in (i + j, i)) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = ((i, j) = (1, 0) in (i + j, i)) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = (1 + 0, 1) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = ((i, j) = (1, 1) in (i + j, i)) in (i + j, i)) in i
          -> (i, _) = ((i, j) = (1 + 1, 1) in (i + j, i)) in i
          -> (i, _) = ((i, j) = (2, 1) in (i + j, i)) in i
          -> (i, _) = (2 + 1, 2) in i
          -> (i, _) = (3, 2) in i
          -> i = 3 in i
          -> 3
    
    フィボナッチ数列 1, 1, 2, 3, ... より，fib 4 ->* 3 は正しいと言える．
  *)

(*練習問題 3.11*)
  (* 1 *)
  let rec gcd (m, n) = (* ユークリッドの互除法で最大公約数を求める関数 *)
    let n = (min m n) and m = (max m n) in
    if m mod n = 0 then
      n
    else
      gcd(m mod n, n)
  
  (*
    # gcd (1234, 432);;
    gcd <-- (1234, 432)
    gcd <-- (370, 432)
    gcd <-- (62, 370)
    gcd <-- (60, 62)
    gcd <-- (2, 60)
    gcd --> 2
    gcd --> 2
    gcd --> 2
    gcd --> 2
    gcd --> 2
    - : int = 2
  *)

  (* 2 *)
  let rec comb (n, m) = (* 2項係数を再帰的に計算する関数 *)
    if m = 0 || m = n then
      1
    else
      comb(n-1, m) + comb(n-1, m-1)
  
  (*
    # comb (3, 2);;
    comb <-- (3, 2)
    comb <-- (2, 1)
    comb <-- (1, 0)
    comb --> 1
    comb <-- (1, 1)
    comb --> 1
    comb --> 2
    comb <-- (2, 2)
    comb --> 1
    comb --> 3
    - : int = 3
  *)

  (* 3 *)
  let iterfib n = (* 末尾再帰的関数によりフィボナッチ数を計算する関数 *)
    let rec fib (i, f1, f2) =
      if i = n then
        f1
      else
        fib (i + 1, f2, f1 + f2)
    in
    fib (1, 1, 1)

    (*
      # iterfib 6;;
      - : int = 8
      # iterfib 50;;
      - : int = 12586269025

      "iterfib 100" は整数型に収まらないようであった．
    *)
  
  (* 4 *)
  let max_ascii sequence = (* 文字列中でASCII コードが最大の文字を返す関数 *)
    let n = String.length sequence in
    let rec seeker (largest, i) =
      let ascii = int_of_char(sequence.[i]) in
      let largest = (max ascii largest) in
      if i = n - 1 then
        largest
      else
        seeker(largest, i + 1)
    in
    char_of_int(seeker(0, 0))

  (*
    # max_ascii "Shinagawa Takuya";;
    - : char = 'y'
  *)

(*練習問題 3.12*)
  let arctan_approx n = (* arctan 1 の n項近似を(相互でない)再帰により計算する関数 *)
    let rec pos_and_neg (res, i) =
      if i = n then
        res
      else
        if i mod 2 = 0 then
          let term = 1.0 /. float_of_int(2 * i + 1) in
          pos_and_neg (res +. term, i + 1)
        else
          let term = -1.0 /. float_of_int(2 * i + 1) in
          pos_and_neg (res +. term, i + 1)
    in
    pos_and_neg (0.0, 0)

  (*
    # arctan_approx 300 *. 4.;;
    - : float = 3.13825932951559139
    # arctan_approx 800 *. 4.;;   
    - : float = 3.14034265407807567
    # arctan_approx 2000 *. 4.;;
    - : float = 3.14109265362104129
  *)

(*練習問題 3.13*)
  (*
    3.7 で定義した pow をカリー化する

    let rec pow_linear (x, n) = (* n回再帰するpow関数 *)
      if n = 0 then
        1
      else
        x * pow_linear(x, n-1)
  *)

  let pow n x = (* カリー化した線形再帰pow関数 *)
    let rec mul i =
      if i = n then
        1
      else
        x * mul (i + 1)
    in
    mul 0
  
  let cube x = pow 3 x (* pow の部分適用における cube の定義 *)

  (*
    # pow 5 2;;
    - : int = 32
    # cube 5;;
    - : int = 125
  *)

  (*
    引数の順番を変えるなら
    let pow_rev x n = pow n x
    また，
    let cube x = pow_rev x 3

    # let pow_rev x n = pow n x;;
    val pow_rev : int -> int -> int = <fun>
    # pow_rev 2 5;;
    - : int = 32
    # let cube x = pow_rev x 3;;
    val cube : int -> int = <fun>
    # cube 3;;
    - : int = 27
  *)

(*練習問題 3.14*)
  let trapezoid a b h = (* 台形の面積を求める関数 *)
    (a +. b) *. h /. 2.0

  let integral f a b = (* 関数fをaからbまで台形近似により定積分する関数 *)
    let n = 1000.0 in (* 区間数 ≒ 精度 *)
    let delta = (b -. a) /. n in
    let rec pile i =
      if i = int_of_float(n) then
        0.0
      else
        let upper = f (a +. float_of_int(i) *. delta) and
            bottom = f (a +. float_of_int(i+1) *. delta) in
        trapezoid upper bottom delta +. pile (i + 1)
    in
    pile 0
  
  (*
    n = 100. のとき
    # let pi = 3.14159265358979;;
    val pi : float = 3.14159265358979
    # integral sin 0. pi;;
    - : float = 1.99983550388744402

    n = 1000. のとき
    # let pi = 3.14159265358979;;
    val pi : float = 3.14159265358979
    # integral sin 0. pi;;
    - : float = 1.99999835506566215

    n が大きい方が真の値 2 に近かった．
  *)

(*練習問題 3.15*)
  (*
    int -> int -> int -> int
    これは
    int -> (int -> (int -> int))
    f a:int = fun b:int -> c:int -> {a, b, c の式}
    であるから，
    let f = fun a -> fun b -> fun c -> a + b * c
    のようにすれば良い．
  *)
  let i_i_i_i a b c = a + b * c
  (*
    # let i_i_i_i a b c = a + b * c;;
    val i_i_i_i : int -> int -> int -> int = <fun>
  *)

  (*
    (int -> int) -> int -> int
    これは
    (int -> int) -> (int -> int)
    f a:(int -> int) -> {a の式}
    であるから，
    let f = fun g a -> g a + a 
    のようにすれば良い．
  *)
  let ii_i_i f a = f a + a
  (*
    # let ii_i_i f a = f a + a;;
    val ii_i_i : (int -> int) -> int -> int = <fun>
  *)

  (*
    (int -> int -> int) -> int
    これは
    (int -> (int -> int)) -> int
    f a:int -> int -> int -> {a の式}
    であるから，
    let f = fun g -> g 1 1 + 1
  *)
  let iii_i g = ((g 1) 1) + 1 (* 括弧は無くても良い *)
  (*
    # let iii_i g = ((g 1) 1) + 1;;
    val iii_i : (int -> int -> int) -> int = <fun>
    # let g a b = a * b;;
    val g : int -> int -> int = <fun>
    # iii_i g;;
    - : int = 2
  *)
