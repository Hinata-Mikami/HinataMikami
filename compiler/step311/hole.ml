(* Questions/holes *)

(* This generative functor constructs holes/questions of a new kind *)
module Hole() = struct
  type 'a t = ..                        (* type of holes, extensible
                                           indexed by the type of values 
                                           to plug
                                        *)

  type plug = {p: 'a. 'a t -> 'a option}
  (* plug forms a monoid *)
  let empty    : plug = {p = fun _ -> None}
  let compose {p=p1} {p=p2} : plug =
  {p = fun x -> match p1 x with Some x -> Some x | None -> p2 x}

  (* should also be generative *)
  module Make(S:sig type hname         (* How to identify a hole: int, string *)
                  type res           (* The type of values to be plugged *)
                  val error_msg : hname -> 'a
              end)
  = struct
    open S
    type 'a t += H : hname -> res t

    let hole : hname -> res t = fun n -> H n

    let plug : (hname*res) -> plug = fun (name,v) ->
      let p : type a. a t -> a option = function 
        | H n when n = name -> Some v
        | _     -> None
      in {p}

    let plugs : (hname*res) list -> plug = fun lst ->
      let p : type a. a t -> a option = function 
        | H n   -> List.assoc_opt n lst
        | _     -> None
      in {p}

    let error : plug =
      let p : type a. a t -> a option = function 
        | H n -> error_msg n
        | _     -> None
      in {p}
  end
end
