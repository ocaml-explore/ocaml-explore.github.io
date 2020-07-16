open Core

let rel_marks n =
  let rec loop acc = function
    | n when n <= 1 -> acc
    | n -> loop ("../" ^ acc) (n - 1)
  in
  loop "" n

let rel_diff a b =
  let a_path = String.split ~on:'/' a in
  let b_path = String.split ~on:'/' b in
  let a_len = List.length a_path in
  let b_len = List.length b_path in
  if a_len < b_len then
    String.concat ~sep:"/" (List.drop b_path (b_len - a_len + 1))
  else rel_marks a_len ^ String.concat ~sep:"/" b_path

let gen_rel ~top_dir ~abso =
  let path = String.split ~on:'/' abso in
  match path with
  | t :: rest when String.equal t top_dir ->
      let file = List.last_exn path in
      let rel = List.length (List.drop_last_exn (top_dir :: rest)) in
      rel_marks rel ^ file
  | _ ->
      raise
        (Failure ("Absolute path doesn't match the expected format: " ^ abso))
