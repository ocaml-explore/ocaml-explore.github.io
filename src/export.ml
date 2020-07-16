open Lwt.Infix
open De
module Basic = Yojson.Basic
module C = Cohttp_lwt_unix.Client
module Conf = Export_config

(* Gzip Decompression cobbled together from https://github.com/mirage/decompress/blob/master/test/test.ml *)
let emitter_from_string x =
  let pos = ref 0 in
  fun i ->
    let len = min (String.length x - !pos) (Bigstringaf.length i) in
    Bigstringaf.blit_from_string x ~src_off:!pos i ~dst_off:0 ~len;
    pos := !pos + len;
    len

let producer_to_string () =
  let buf = Buffer.create 0x100 in
  ( (fun o len -> Buffer.add_string buf (Bigstringaf.substring o ~off:0 ~len)),
    fun () -> Buffer.contents buf )

let failwith_on_error_msg = function
  | Ok v -> v
  | Error (`Msg err) -> failwith err

let i = bigstring_create io_buffer_size

let o = bigstring_create io_buffer_size

let decompress str =
  let refill = emitter_from_string str in
  let flush, content = producer_to_string () in
  let s = Gz.Higher.uncompress ~i ~o ~refill ~flush in
  let _meta = failwith_on_error_msg s in
  content ()

(* The Notion API lets you enqueue an export task - then 
   it hits the getTask endpoint until the status reaches success 
   at which point it gets the zip from an S3 bucket *)

let get_task ~body () =
  let headers =
    Conf.notion_headers ~len:(String.length body) |> Cohttp.Header.of_list
  in
  let body = Cohttp_lwt.Body.of_string body in
  let rec get_export_url () =
    try%lwt
      let%lwt resp =
        C.post ~headers ~body (Uri.of_string Conf.get_tasks)
        >>= fun (_res, body) ->
        Cohttp_lwt.Body.to_string body >|= decompress >>= fun b ->
        print_endline b;
        Lwt.return (Basic.from_string b)
      in
      let%lwt state, status =
        match resp with
        | `Assoc assoc -> (
            match List.assoc "results" assoc with
            | `List lst -> (
                match List.hd lst with
                | `Assoc first ->
                    Lwt.return
                      (List.assoc "state" first, first)
                | _ ->
                    Lwt.fail (Failure "Wanted an Assoc to get state and status")
                )
            | _ -> Lwt.fail (Failure "Wanted a List"))
        | _ -> Lwt.fail (Failure "Wanted an Assoc from response")
      in
      (match (state, status) with
      | `String state, assoc when "success" = state -> (match List.assoc "status" assoc with
        | `Assoc values -> Lwt.return values
        | _ -> Lwt.fail (Failure "Expected status to be an assoc"))
      | `String state, _status  when "in_progress" = state -> Lwt_unix.sleep 1.0 >>= fun () -> get_export_url ()
      | _, _ -> Lwt.fail (Failure "Unknown Notion API Error"))
    with
    | Failure msg -> Lwt.fail (Failure ("Error from get_task: " ^ msg))
    | exn -> Lwt_io.print "Failed in getting tasks" >>= fun () -> Lwt.fail exn
  in
  let%lwt data = get_export_url () in
  let _typ = List.assoc "type" data in
  let zip = List.assoc "exportURL" data in
  let url =
    match zip with `String url -> url | _ -> failwith "No String URL found"
  in
  Lwt.return url

let enqueue_task () =
  let body = Conf.enqueue_body |> Cohttp_lwt.Body.of_string in
  let headers =
    Conf.notion_headers ~len:(String.length Conf.enqueue_body)
    |> Cohttp.Header.of_list
  in
  C.post ~headers ~body (Uri.of_string Conf.enqueue_task)
  >>= fun (_res, body) ->
  Cohttp_lwt.Body.to_string body >|= decompress >>= fun body ->
  Lwt.return (Basic.from_string body) >>= function
  | `Assoc assoc -> (
      match
        try List.assoc "taskId" assoc
        with Not_found ->
          print_endline (Basic.to_string (`Assoc assoc));
          raise Not_found
      with
      | `String task_id -> Lwt.return ("{ \"taskIds\": [\"" ^ task_id ^ "\"]}")
      | _ -> Lwt.fail (Failure "TaskId is not a string"))
  | _ -> Lwt.fail (Failure "Could not get TaskId")

let get_zip output uri =
  C.get (Uri.of_string uri) >>= fun (_res, body) ->
  Lwt_unix.(openfile (output ^ ".zip") [ O_CREAT; O_RDWR ] 777) >>= fun fd ->
  Cohttp_lwt.Body.to_string body >>= fun body ->
  let byte_body = Bytes.of_string body in
  Lwt_unix.write fd (Bytes.of_string body) 0 (Bytes.length byte_body)

let export_task output () =
  try%lwt
    enqueue_task () >>= fun task_id ->
    get_task ~body:task_id () >>= fun export_endpoint ->
    Lwt_io.print "Downloading export to zip folder..." >>= fun () ->
    get_zip output export_endpoint >>= fun _ -> Lwt.return ()
  with
  | Failure msg -> Lwt_io.print ("[INTERNAL FAILURE] " ^ msg)
  | exn -> Lwt_io.print "Failed early... " >>= fun () -> Lwt.fail exn
