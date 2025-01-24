(* Sequences, extended *)

include module type of Sq_21

val map : ('a -> 'b) -> 'a t -> 'b t

(* Extension: the sequence may have `notes', or `footnotes', which
   are traversed/mapped first. When concatentating a sequence,
   notes are collected together. The following designates a sequence
   as being the side-sequence: note
 *)
val as_note : 'a t -> 'a t

(* Annotations *)
type annot = int list
val add_annot : int -> 'a t -> 'a t
val get_annot : 'a t -> annot
val set_annot : annot -> 'a t -> 'a t

