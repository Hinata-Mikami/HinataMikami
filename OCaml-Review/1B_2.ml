(*下位bitから並べて考えると深さを考える必要がなくなる*)

type bnat = Z | I of bnat | O of bnat;;
exception Invalid_input;;

(*Oで始まる入力はinvalid*)
let invaild_check m =
  match m with
  | O m' -> true
  | _ -> false;;

(*入力2進数の桁数*)
let digits m =
  if invaild_check m then raise Invalid_input else
  let rec digits_counter n =
    match n with
    | Z -> 0
    | I n' -> 1 + digits_counter n'  
    | O n' -> 1 + digits_counter n'
  in digits_counter m;;

(*書き換え処理*)
let change_zero m id =
  let dm = digits m in
  (*最上位をOにする処理*)
  if id = dm then
    match m with
    | I m' -> m'
  else 
  let rec change_O m dm id =
    match (m, dm) with
    | (Z, _) -> Z
    | (I m', dm) when dm > id -> I (change_O m' (dm-1) id)
    | (O m', dm) when dm > id -> O (change_O m' (dm-1) id)
    | (I m', dm) when dm = id -> O (change_O m' (dm-1) id)
    | (I m', dm) -> I (change_O m' (dm-1) id)
    | (O m', dm) -> O (change_O m' (dm-1) id)
  in change_O m dm id;;

(*繰り上げ処理*)
let kuriage m id =
  let dm = digits m in
  (*最上位にIを付け足す処理*)
  if id = dm + 1 then I m else 
  let rec change_I x dx id =
    match (x, dx) with
    | (Z, _) -> Z
    | (I m', dm) when dm > id -> I (change_I m' (dm-1) id)
    | (O m', dm) when dm > id -> O (change_I m' (dm-1) id)
    (*繰り上げ*)
    | (O m', dm) when dm = id -> I (change_I m' (dm-1) id)
    (*もし仮に繰り上げ先がIのときは，それをOにし，その一つ上をIに*)
    | (I m', dm) when dm = id -> change_I (change_zero m id) dm (id+1)
    | (I m', dm) -> I (change_I m' (dm-1) id)
    | (O m', dm) -> O (change_I m' (dm-1) id)
  in change_I m dm id;;


(*たし算*)
let badd m n =
  let dm = digits m in
  let dn = digits n in
(*たし算における繰り上げ処理を先にしておく*)
  (*繰り上げがあるかどうかをチェック。操作した後は必ず実行*)
  let rec kuriage_check m dm n dn =
    match (m, dm, n, dn) with
    | (Z, _, Z, _) -> (m, n)
    | (I m', dm, _, dn) when dm > dn -> kuriage_check m' (dm-1) n dn
    | (O m', dm, _, dn) when dm > dn -> kuriage_check m' (dm-1) n dn
    | (_, dm, I n', dn) when dm < dn -> kuriage_check m dm n' (dn-1)
    | (_, dm, O n', dn) when dm < dn -> kuriage_check m dm n' (dn-1)
    (*繰り上げ動作の実行*)
    | (I m', dm, I n', dn) when dm = dn -> 
      let new_m = kuriage (change_zero m dm) (dm+1) in
      let new_n = change_zero n dn in
      kuriage_check new_m (digits new_m) new_n (digits new_n);
      (new_m, new_n)
    | (I m', dm, O n', dn) when dm = dn -> kuriage_check m' (dm-1) n' (dn-1)
    | (O m', dm, I n', dn) when dm = dn -> kuriage_check m' (dm-1) n' (dn-1)
    | (O m', dm, O n', dn) when dm = dn -> kuriage_check m' (dm-1) n' (dn-1)
  in kuriage_check m dm n dn

in let rec badd_cal m dm n dn =
    match (m, dm, n, dn) with
    | (I m', dm, _, dn) when dm > dn -> I (badd_cal m' (dm-1) n dn)
    | (O m', dm, _, dn) when dm > dn -> O (badd_cal m' (dm-1) n dn)
    | (_, dm, I n', dn) when dm < dn -> I (badd_cal m dm n' (dn-1))
    | (_, dm, O n', dn) when dm < dn -> O (badd_cal m dm n' (dn-1))
    | (Z, dm, Z, dn) -> Z
    | (I m', dm, O n', dn) -> I (badd_cal m' (dm-1) n' (dn-1))
    | (O m', dm, I n', dn) -> I (badd_cal m' (dm-1) n' (dn-1))
    | (O m', dm, O n', dn) -> O (badd_cal m' (dm-1) n' (dn-1))
  in badd_cal m dm n dn;;

  (*mが未定義のためうまくいかず...*)