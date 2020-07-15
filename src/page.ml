type t = { name : string; properties : prop list }

and prop = [ `Text of string | `Number of float | `Relation of string * string ]

let dump_html top_dir modifier (abs, _rel) =
  if Sys.file_exists (Utils.replace_spaces abs) then
    let filename = Utils.replace_spaces abs in
    let title =
      Core.(
        List.last_exn (String.split ~on:'/' (Filename.chop_extension filename)))
    in
    let file = Utils.read_file filename in
    if Sys.file_exists (Filename.chop_extension filename ^ ".html") = false then
      let modified_omd = modifier (Omd.of_string file) in
      Html_gen.(
        emit_page
          (Filename.chop_extension filename ^ ".html")
          (wrapper top_dir title
             [ Tyxml.Html.Unsafe.data (Omd.to_html modified_omd) ]))
