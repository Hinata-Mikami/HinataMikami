(*プログラミング in OCaml 冬休みの課題*)
(*練習問題 2.1*)
  (*
    1.
      # - - 1;;
      - : int = 1

    2.
      # - 2+3;;
      - : int = 1

    3.
      # 9 / -4;;
      - : int = -2

    4.
      # +3 + 5;;
      - : int = 8
  *)

(*練習問題 2.2*)
  (*
    1.
      # float_of_int 3 +. 2.5;;
      - : float = 5.5
    
    2.
      # int_of_float 0.7;;
      - : int = 0
    
    3.
      # char_of_int ((int_of_char 'A') + 20);;
      - : char = 'U'
    
    4.
      # int_of_string "0xff";;
      - : int = 255

    5.
      # 5.0 ** 2.0;;
      - : float = 25.
  *)

(*練習問題 2.3*)
  (*
    1.
      8*-2
      予想："*-" の部分で構文エラーになる．
      結果："Error: Unbound value ( *- )"，つまり "*-" が未定義の演算子として解釈され構文エラーになった．
            なお，"8* -2"では"- : itn = -16"が得られた．

    2.
      int_of_string "0xfg"
      予想：16進法で"g"は使えないので型エラーになる．
      結果："Exception: Failure "int_of_string"."，つまり，引数は正しいが"int_of_string"では計算できずに例外が発生した．

    3.
      int_of_float -0.7
      予想：関数"int_of_float"の引数に"-"が取られ，Invalid_argument(p.150参照)になる．
      結果："Error: This expression has type float -> int \n but an expression was expected of type int"
            つまり，"int_of_float - 0.7"というfloat->int型とint型の引き算と解釈され，型付けエラーが起きた．
  *)

(*練習問題 2.4*)
  (*
    1.
      float_of_int int_of_float 5.0
      このままでは"float_of_int"が引数を2つ取っていると解釈されるので，
      "float_of_int(int_of_float 5.0)"として"int_of_float 5.0"が1つの引数であることを伝えればよい．

      # float_of_int(int_of_float 5.0);;
      - : float = 5.
    
    2.
      sin 3.14 /. 2.0 ** 2.0 +. cos 3.14 /. 2.0 ** 2.0
      正弦と余弦の平方の和が常に1となる性質にpi/2をあてはめたものと考えられるので，
      "sin(3.14 /. 2.0) ** 2.0 +. cos(3.14 /. 2.0) ** 2.0"とすれば良い．

      # sin(3.14 /. 2.0) ** 2.0 +. cos(3.14 /. 2.0) ** 2.0
      - : float = 1.
    
    3.
      sqrt 3 * 3 + 4 * 4
      三平方の定理と思われる．"sqrt"以降を1つの引数と解釈できるように
      "sqrt(3 * 3 + 4 * 4)"としたいが，"sqrt"は float -> float なので引数が float となるように
      "sqrt(3. *. 3. +. 4. *. 4.)"とし，さらにこの全体を int にするため
      "int_of_float(sqrt(3. *. 3. +. 4. *. 4.))"とする必要がある．

      # int_of_float(sqrt(3. *. 3. +. 4. *. 4.));;
      - : int = 5
  *)

(*練習問題 2.5*)
  (*
    a_2' : 英小文字で始まり，英数字またはアンダースコアまたはプライムのみで構成され，予約語でないので，変数名として有効である．
          # let a_2' : int = 1;;
          val a_2' : int = 1
    
    ____ : アンダースコアで始まり，アンダースコアのみで構成され，予約語でなく，アンダースコア1文字のみでないため，変数名として有効である．
          # let ____ : float = 1.;;
          val ____ : float = 1.
    
    Cat : 英小文字またはアンダースコアから始まっていないため，変数名として有効でない．
          # let Cat : char = 'a';;     
          Error: Unbound constructor Cat

    _'_'_ : アンダースコアで始まり，アンダースコアまたはプライムのみで構成され，予約語でなく，アンダースコア1文字のみでないため，変数名として有効である．
            # let _'_'_ : string = "shinagawa";;
            val _'_'_ : string = "shinagawa"

    7eleven : 英小文字またはアンダースコアで始まっていないため，変数名として有効でない．
              # let 7eleven : int = 711;;
              Error: Invalid literal 7eleven

    'ab2_ : 英小文字またはアンダースコアで始まっていないため，変数名として有効でない．
            # let 'ab2_ : float = 2.22;;
            Error: Syntax error

    _ : アンダースコア1文字のみであるため，変数名として有効でない．
        # let _ : int = 1;;
        - : int = 1
        # _;;
        Error: Syntax error: wildcard "_" not expected.
        このようにlet定義はできたが参照はできなかった．
  *)
