type ('a, 'b) sum = Left of 'a | Right of 'b;;

(*① f1: 'a * ('b, 'c) sum -> ('a * 'b, 'a * 'c) sum*)
let f1 (a, sum) =
  match sum with
    Left b -> Left (a, b)
  | Right c -> Right (a, c);;


(*② f2: ('a * 'b, 'a * 'c) sum -> 'a * ('b, 'c) sum*)
let f2 sum =
  match sum with
    Left (a, b) -> (a, Left b)
  | Right (a, c) -> (a, Right c);;

(*③ f3: ('a, 'b) sum * ('c, 'd) sum -> (('a * 'c, 'b * 'c) sum, ('a * 'd, 'b * 'd) sum) sum*)
let f3 (sum1, sum2) =
  match (sum1, sum2) with
    (Left a, Left c) -> Left (Left (a, c))
  | (Left a, Right d) -> Right (Left (a, d))
  | (Right b, Left c) -> Left (Right (b, c))
  | (Right b, Right d) -> Right (Right (b, d));;

(*④ f4: (('a * 'c, 'b * 'c) sum, ('a * 'd, 'b * 'd) sum) sum -> ('a, 'b) sum * ('c, 'd) sum*)
let f4 sum =
  match sum with
    Left (Left (a, b)) -> (Left a, Left b)
  | Right (Left (a, b)) -> (Left a, Right b)
  | Right (Right (a, b)) -> (Right a, Right b)
  | Left (Right (a, b)) -> (Right a, Left b);;

(*⑤ f5: ('a -> 'b) * ('c -> 'b) -> ('a, 'c) sum -> 'b*)
let f5 (f1, f2) sum =
  match sum with
    Left a -> f1 a
  | Right c -> f2 c;;

(*⑥ f6: (('a, 'b) sum -> 'c) -> ('a -> 'c) * ('b -> 'c)*)
let f6 f = (fun a -> f (Left a)), (fun b -> f (Right b))

(*⑦ f7: ('a -> 'b, 'a -> 'c) sum -> 'a -> ('b,'c) sum*)
let f7 sum =
  match sum with
    Left (a, b) -> fun a -> Left a  
  | Right (a, b) -> fun b -> Right b;;