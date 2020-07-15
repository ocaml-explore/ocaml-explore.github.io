(* Returns all files with absolute and relative paths *)
let all_files root =
  let rec walk acc = function
    | [] -> acc
    | (dir, _) :: dirs ->
        let dir_content = Array.to_list (Sys.readdir dir) in
        let added_paths =
          List.rev_map (fun f -> (Filename.concat dir f, f)) dir_content
        in
        let fs = List.fold_left (fun acc f -> f :: acc) [] added_paths in
        let new_dirs = List.filter (fun f -> Sys.is_directory (fst f)) fs in
        walk (fs @ acc) (new_dirs @ dirs)
  in
  walk [] [ (root, "") ]

let build dist_dir =
  let all = all_files dist_dir in
  let pages = List.filter (fun f -> Filename.extension (fst f) = ".md") all in
  let csvs = List.filter (fun f -> Filename.extension (fst f) = ".csv") all in
  List.iter
    (fun (a, b) ->
      print_endline ("ABS: " ^ a);
      print_endline b)
    csvs;
  let change_ext str =
    try Filename.chop_extension str ^ ".html"
    with Invalid_argument _ ->
      print_endline str;
      str
  in
  let _mds =
    List.iter
      (fun page ->
        Page.dump_html dist_dir (Utils.change_url_omd change_ext) page)
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
