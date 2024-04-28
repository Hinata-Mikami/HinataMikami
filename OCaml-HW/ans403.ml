let rec funny f n =
  if n = 0 then id
  else if n mod 2 = 0 then funny (f $ f) (n / 2)
  else funny (f $ f) (n / 2) $ f;;

  (* n=0のとき id,
     n=1のとき funny (f $ f) 0 $ f = id $ f = f
     n=2のとき funny (f $ f) 1 = id $ (f $ f) = (f $ f)
  のように，n個のfの合成関数を返すもの。   
  *)