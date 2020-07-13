open Core

let read_file filename =
  let file = In_channel.create filename in
  Exn.protect ~f:(fun () ->
    String.concat ~sep:"\n" (In_channel.input_lines file))
    ~finally:(fun () -> In_channel.close file)

let output_file str filename = 
  let outc = Out_channel.create filename in
  Exn.protect ~f:(fun () -> Out_channel.fprintf outc "%s\n" str)
  ~finally:(fun () -> Out_channel.close outc)

let replace_spaces str =
  let re = Re.compile (Re.str "%20") in 
    Re.replace_string re ~by:"\ " str

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
  let truncate str = if String.length str >= 50 then String.sub str ~pos:0 ~len:50 else str in 
    replace_all space_regexp str |> replace_all empty_regexp |> replace_all double_space
    |> truncate


(* Custom Omd AST Modifiers *)
(* XXX: Most (all) of our links appear in paragraphs *)
let change_url_omd f ast =  
  let aux (b : Omd.block) = match b.bl_desc with 
    | Omd.Paragraph inline -> begin match inline.il_desc with 
      | Omd.Link link -> 
        let link = { link with destination = f link.destination } in 
          { b with bl_desc = Omd.Paragraph ({ inline with il_desc = Link link}) }
      | _ -> b
      end
    | _ -> b
  in 
    List.map ~f:aux ast
