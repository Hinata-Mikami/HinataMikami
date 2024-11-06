(* (not very) Pretty-printer of the AST, just to confirm parsing *)

type repr = string                               (* representation type *)

let int  : Int64.t -> repr = Int64.to_string

let varx : repr = "x"

(* utilities *)
let paren (x:string) : string = "(" ^ x ^ ")"
let prepend (pref:string) (s:string) : string = pref ^ s
let (>>) f g = fun x -> f x |> g

let neg  : repr -> repr = prepend "neg "  >> paren
let succ : repr -> repr = prepend "succ " >> paren
let pred : repr -> repr = prepend "pred " >> paren

(* Ex 5 *)
let bool : Bool.t -> repr = Bool.to_string
let not  : repr -> repr = prepend "not " >> paren
let is_zero : repr -> repr = prepend "is_zero " >> paren

type obs = string                                (* observation type *)
let observe : repr -> obs = Fun.id

