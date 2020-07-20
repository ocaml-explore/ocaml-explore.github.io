open Core

let read_file filename =
  let file = In_channel.create filename in
  Exn.protect
    ~f:(fun () -> String.concat ~sep:"\n" (In_channel.input_lines file))
    ~finally:(fun () -> In_channel.close file)

let output_file str filename =
  let outc = Out_channel.create filename in
  Exn.protect
    ~f:(fun () -> Out_channel.fprintf outc "%s\n" str)
    ~finally:(fun () -> Out_channel.close outc)

let replace_spaces str =
  let re = Re.compile (Re.str "%20") in
  Re.replace_string re ~by:" " str

let replace regex by str =
  let re = Re.compile (Re.str regex) in
  Re.replace_string re ~by str

let replace_all f s =
  let rec aux str =
    let new_str = f str in
    if String.equal new_str str then new_str else aux new_str
  in
  aux s

let notion_strip str =
  let space_regexp = Re.Str.(replace_first (regexp ",\\|/\\|-") " ") in
  let empty_regexp = Re.Str.(replace_first (regexp ")\\|(\\|&\\|\\?\\|!") "") in
  let double_space = Re.Str.(replace_first (regexp "  ") " ") in
  let truncate str =
    if String.length str >= 50 then String.sub str ~pos:0 ~len:50 else str
  in
  replace_all space_regexp str
  |> replace_all empty_regexp
  |> replace_all double_space
  |> truncate

(* Changing markdown links in the code to html links whilst leaving others unchanged *)
let alter_md_links pages page_path str =
  try
    (* Convert links to remote notion pages to local versions *)
    if
      String.equal
        (Uri.host_with_default ~default:"not-notion" (Uri.of_string str))
        "www.notion.so"
    then
      let file = List.last_exn (String.split ~on:'/' str) in
      match
        List.find
          ~f:(fun abso ->
            String.equal
              String.(concat ~sep:" " (List.drop_last_exn (split ~on:'-' file)))
              String.(
                concat ~sep:" "
                  (List.drop_last_exn
                     (String.split ~on:' '
                        Filename.(chop_extension (basename abso))))))
          pages
      with
      | Some path ->
          Filename.chop_extension
            (Paths.rel_diff (fst (Core.Filename.split page_path)) path)
          ^ ".html"
      | None -> str
    else
      let scheme = Uri.(scheme (of_string str)) in
      if
        Option.equal String.equal scheme (Some "https")
        || Option.equal String.equal scheme (Some "http")
      then str
      else Filename.chop_extension str ^ ".html"
  with Invalid_argument s ->
    print_endline
      ("Not changing url for: " ^ str ^ " because Invalid_argument to " ^ s);
    str

(* Custom Omd AST Modifiers *)
(* XXX: Most (all) of our links appear in paragraphs, some in "Concats" *)
let change_url_omd f ast =
  let aux (b : Omd.block) =
    match b.bl_desc with
    | Omd.Paragraph inline -> (
        match inline.il_desc with
        | Omd.Link link ->
            let link = { link with destination = f link.destination } in
            {
              b with
              bl_desc = Omd.Paragraph { inline with il_desc = Link link };
            }
        | Omd.Concat lst ->
            let new_lst =
              List.map
                ~f:(fun elt ->
                  match elt.il_desc with
                  | Omd.Link link ->
                      {
                        elt with
                        il_desc =
                          Omd.Link
                            { link with destination = f link.destination };
                      }
                  | _desc -> elt)
                lst
            in
            {
              b with
              bl_desc =
                Omd.Paragraph { inline with il_desc = Omd.Concat new_lst };
            }
        | _ -> b)
    | _ -> b
  in
  List.map ~f:aux ast

let name_from_file file =
  let separated = String.split ~on:' ' (Filename.basename file) in
  String.(concat ~sep:" " (List.drop_last_exn separated))

let title_from_file link =
  let split = Re.Str.(split (regexp "%20") (Filename.basename link)) in
  String.concat ~sep:" " (List.drop_last_exn split)

(* Create a toggle list for properties of DB entries *)
let gen_omd_list hd lst : Omd.block list =
  let html_lst =
    List.map
      ~f:(fun link ->
        ( Filename.chop_extension (String.strip ~drop:(Char.equal ' ') link)
          ^ ".html",
          title_from_file link ))
      lst
  in
  [
    {
      bl_desc =
        Omd.Html_block Html_gen.(elt_to_string (emit_toggle_list hd html_lst));
      bl_attributes = [];
    };
  ]

(* Some pages have headers with properties like related workflows
   - this needs parsed and rendered nicely. *)
let change_and_extract_headers ast =
  let rec change_concat_lst = function
    | [] -> []
    | (x : Omd.inline) :: xs -> (
        match x.il_desc with
        | Omd.Text txt -> (
            try
              let prop_type = List.hd (String.split_on_chars ~on:[ ':' ] txt) in
              match prop_type with
              | Some str ->
                  if
                    List.mem
                      [ "Related Workflows"; "Libraries"; "Platform" ]
                      str ~equal:String.equal
                  then
                    match String.split_on_chars ~on:[ ':'; ',' ] txt with
                    | _hd :: links ->
                        gen_omd_list str links :: change_concat_lst xs
                    | _ -> change_concat_lst xs
                  else change_concat_lst xs
              | None -> change_concat_lst xs
            with Invalid_argument _ -> change_concat_lst xs)
        | _ -> change_concat_lst xs)
  in
  let aux (b : Omd.block) =
    match b.bl_desc with
    | Omd.Paragraph inline -> (
        match inline.il_desc with
        | Omd.Concat lst -> (
            match List.hd lst with
            | Some omd -> (
                match omd.il_desc with
                | Omd.Text _txt -> (
                    try
                      match change_concat_lst lst with
                      | [] -> [ b ]
                      | lst -> Stdlib.List.flatten lst
                    with Invalid_argument _ -> [ b ])
                | _ -> [ b ])
            | None -> [ b ])
        | _ -> [ b ])
    | _ -> [ b ]
  in
  Stdlib.List.flatten (List.map ~f:aux ast)
