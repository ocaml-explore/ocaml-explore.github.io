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
  let _mds =
    List.iter
      (fun page ->
        Page.dump_html dist_dir
          (fun compose ->
            Utils.change_and_extract_headers
              Utils.(change_url_omd (alter_md_links pages page) compose))
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
