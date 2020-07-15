let enqueue_task = "https://www.notion.so/api/v3/enqueueTask"

let enqueue_path = "/api/v3/enqueueTask"

let notion_headers ~len =
  let cookies_user =
    match (Sys.getenv_opt "notion_cookies", Sys.getenv_opt "active_user") with
    | Some cookies, Some user -> (cookies, user)
    | _ ->
        failwith
          "Add an environement variable for notion_cookies and \
           notion_active_user"
  in
  [
    ("accept", "*/*");
    ("accept-encoding", "gzip");
    ("accept-language", "en-GB,en-US;q=0.9,en;q=0.8");
    ("content-length", string_of_int len);
    ("content-type", "application/json");
    ("cookie", fst cookies_user);
    ("notion-client-version", "22.7.28");
    ("origin", "https://www.notion.so");
    ( "referer",
      "https://www.notion.so/Explore-OCaml-294d4a6975e84e509cdc53dc6cb1ba3b" );
    ("sec-fetch-dest", "empty");
    ("sec-fetch-mode", "cors");
    ("sec-fetch-site", "same-origin");
    ("x-notion-active-user-header", snd cookies_user);
  ]

let get_tasks = "https://www.notion.so/api/v3/getTasks"

let get_tasks_path = "/api/v3/getTasks"

let enqueue_body =
  "{\"task\":{\"eventName\":\"exportSpace\",\"request\":{\"spaceId\":\"6cc70d1a-8467-49c9-9f0f-8cfeb160bb58\",\"exportOptions\":{\"exportType\":\"markdown\",\"timeZone\":\"Europe/London\",\"locale\":\"en\"}}}}"
