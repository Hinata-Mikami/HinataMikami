type ('a, 'b) xml = XLf of 'b option | XBr of 'a * ('a, 'b) xml list;;
type token = PCDATA of string | Open of string | Close of string;;


let rec xml_of_tokens list =
  match list with 
    [] -> "" 
  | (Open s)::rest -> "<"^s^">"^(xml_of_tokens rest)
  | (Close s)::rest -> "</"^s^">"^(xml_of_tokens rest)
  | (PCDATA s)::rest ->s^(xml_of_tokens rest);;

let l = [Open "a"; Open "b"; Close "b";
Open "c"; PCDATA "Hello"; Close "c"; Close "a"];;

xml_of_tokens l;;