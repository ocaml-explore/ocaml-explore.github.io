open Tyxml

type t = { name : string; path : string; pages : Page.t option list }

let row_to_page row : Page.t option =
  let page_name = Utils.notion_strip (List.hd row) in
  let rec aux props_acc p : Page.t =
    match p with
    | [] -> { name = page_name; properties = props_acc }
    | prop :: ps when Filename.extension prop = ".md" ->
        aux (`Relation (prop, prop) :: props_acc) ps
    | prop :: ps -> aux (`Text prop :: props_acc) ps
  in
  if page_name = "" then None else Some (aux [] row)

let from_csv (abso, _rel) =
  let extracted_name =
    Core.(
      List.drop_last
        (String.split ~on:' ' Filename.(basename (chop_extension abso))))
  in
  let name =
    match extracted_name with
    | Some s -> Core.(String.concat ~sep:" " s)
    | None -> failwith ("Filename generation failed for: " ^ abso)
  in
  let path = Filename.chop_extension abso ^ ".html" in
  let ic = Utils.read_file abso |> Csv.of_string in
  let _remove_header = Csv.Rows.next ic in
  {
    name;
    path;
    pages = Csv.fold_left ~f:(fun acc row -> row_to_page row :: acc) ~init:[] ic;
  }

(* XXX: Probably a nicer way of doing this, but CSVs don't have the fullname of the linked page :( 
 * It is also possible to get clashes (dune and dune-release for dune) - take the shortest string to break ties *)
let get_url _db name files =
  let re = Re.compile (Re.str ("/" ^ name)) in
  let filter s = List.length (Re.matches re ("/" ^ Filename.basename s)) > 0 in
  let possible_links = List.filter (fun s -> filter (fst s)) files in
  let rec get_smallest smallest sofar = function
    | [] -> smallest
    | (abso, rel) :: xs ->
        let len = String.length abso in
        if len < sofar then get_smallest (abso, rel) len xs
        else get_smallest smallest sofar xs
  in
  if List.length possible_links = 1 then List.hd possible_links
  else
    let first = List.hd possible_links in
    get_smallest first (String.length (fst first)) possible_links

let to_html top_dir db files =
  let gen_page (page : Page.t) =
    let url =
      Filename.chop_extension
        (Paths.rel_diff db.path (fst (get_url db page.name files)))
      ^ ".html"
    in
    [%html {|<li><a href="|} url {|">|} [ Html.txt page.name ] {|</a></li>|}]
  in
  let body =
    [%html
      {|
    <div> 
      <h1>|} [ Html.txt db.name ]
        {|</h1>
    </div>
    <div>
      <ul>|}
        (List.map gen_page
           (List.map Option.get (List.filter Option.is_some db.pages)))
        {|</ul>
    </div>
  |}]
  in
  let rel_css = Paths.rel_diff db.path (top_dir ^ "/main.css") in
  Html_gen.(emit_page db.path (wrapper rel_css db.name body))
