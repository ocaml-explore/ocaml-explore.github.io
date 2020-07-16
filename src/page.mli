type t = { name : string; properties : prop list }

and prop = [ `Text of string | `Number of float | `Relation of string * string ]

val dump_html : string -> (Omd.doc -> Omd.doc) -> string * string -> unit
(** [dump_html top f (abs, rel)] will output the markdown stored at [abs] as
    HTML first applying [f] to the markdown document. You can use this, for
    example, to change the address of strings *)
