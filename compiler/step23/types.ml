(* Type language and type representation *)
type t = string                      (* the simplest representation *)

let int  = "int"
let bool = "bool"

let eq : t -> t -> bool = (==)    (* Physical equality! *)
let to_string : t -> string = Fun.id

exception Type_error of string

let type_error : ('a, unit, string, 'd) format4 -> 'a = fun fmt ->
  Printf.ksprintf (fun s -> raise (Type_error s)) fmt

let check_type ?(msg="") (expected:t) (given:t) : unit =
  if not (eq expected given) then
    type_error "Expected type %s but found %s %s" 
      (to_string expected) (to_string given) msg
