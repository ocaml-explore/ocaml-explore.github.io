open Tyxml
open Core

let wrapper css_path title body =
  [%html
    {|
  <html>
    <head>
      <title>|} (Html.txt title)
      {|</title>
      <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono&family=Ubuntu:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
      <link rel=stylesheet href=|}
      css_path
      {| />
      <link rel="stylesheet"  href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.0.0/styles/gruvbox-dark.min.css">
      <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.0.0/highlight.min.js"></script>
      <script charset="UTF-8" src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.0.0/languages/ocaml.min.js"></script>
      <script>hljs.initHighlightingOnLoad();</script>
    </head>
    <body>
      <div style="display: flex; justify-content: center; align-content: center">
        <div style="max-width: 800px">
          |}
      body {|
        </div>
      </div>
    </body>
  </html>
|}]

let emit_toggle_list title lst =
  let to_link (link, name) =
    [%html "<li><a href=" link ">" [ Html.txt name ] "</a></li>"]
  in
  [%html
    {| 
  <details>
    <summary>|} [ Html.txt title ]
      {|</summary>
    <ul>
      |} (List.map ~f:to_link lst)
      {|
    </ul>
  </details>
|}]

let elt_to_string page = Format.asprintf "%a" (Html.pp_elt ()) page

let emit_page filename html =
  let outc = Out_channel.create filename in
  let fmt = Format.formatter_of_out_channel outc in
  Exn.protect
    ~f:(fun () -> Format.fprintf fmt "%a@." (Html.pp ~indent:true ()) html)
    ~finally:(fun () -> Out_channel.close outc)
