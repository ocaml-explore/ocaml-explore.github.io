(* Returns all files with absolute and relative paths *)
let all_files root =
  let rec walk acc = function
    | [] -> acc
    | dir :: dirs ->
        let dir_content = Array.to_list (Sys.readdir dir) in
        let added_paths =
          List.rev_map (fun f -> Filename.concat dir f) dir_content
        in
        let fs = List.fold_left (fun acc f -> f :: acc) [] added_paths in
        let new_dirs = List.filter (fun f -> Sys.is_directory f) fs in
        walk (fs @ acc) (new_dirs @ dirs)
  in
  walk [] [ root ]

let build dist_dir =
  let all = all_files dist_dir in
  let pages = List.filter (fun f -> Filename.extension f = ".md") all in
  let csvs = List.filter (fun f -> Filename.extension f = ".csv") all in
  let alter_md_links page_path str =
    try
      (* Convert links to remote notion pages to local versions *)
      if
        Uri.host_with_default ~default:"not-notion" (Uri.of_string str)
        = "www.notion.so"
      then
        let file = Core.List.last_exn (String.split_on_char '/' str) in
        match
          Core.List.find
            ~f:(fun abso ->
              String.(concat " " (split_on_char '-' file))
              = Filename.(remove_extension (basename abso)))
            pages
        with
        | Some path ->
            Filename.remove_extension
              (Paths.rel_diff (fst (Core.Filename.split page_path)) path)
            ^ ".html"
        | None -> str
      else Filename.chop_extension str ^ ".html"
    with Invalid_argument s ->
      print_endline
        ("Not changing url for: " ^ str ^ " because Invalid_argument to " ^ s);
      str
  in
  let _mds =
    List.iter
      (fun page ->
        Page.dump_html dist_dir
          (Utils.change_url_omd (alter_md_links page))
          page)
      pages
  in
  let dbs = List.map (fun csv -> Database.from_csv csv) csvs in
  List.iter (fun dbs -> Database.to_html dist_dir dbs pages) dbs

let command =
  Core.Command.basic
    ~summary:
      "🐫  Onotion - a tool for exporting and building Notion Workspaces as \
       websites  🐫"
    Core.Command.Let_syntax.(
      let%map_open mode = anon (maybe ("mode - <export|build>" %: string))
      and output =
        flag "-o"
          (optional_with_default "notion" string)
          ~doc:"folder for exported folder"
      in
      fun () ->
        match mode with
        | Some "export" -> Lwt_main.run (Export.export_task output ())
        | Some "build" -> build output
        | _ -> print_endline "Please specify either to export or build")

let () = Core.Command.run command
