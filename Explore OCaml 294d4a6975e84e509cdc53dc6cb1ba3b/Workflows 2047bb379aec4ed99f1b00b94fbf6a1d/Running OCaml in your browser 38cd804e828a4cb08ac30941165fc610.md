# Running OCaml in your browser

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/js_of_ocaml%200701e868172543d09c7a67c2cb7e4c5b.md
Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Short Description: Use js_of_ocaml to run OCaml code in browsers
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

OCaml byte-code can be compiled to Javascript to run in your browser using the `js_of_ocaml` compiler linked in the libraries tag. This allows you to write statically type-checked OCaml code to run in a website rather than dynamically typed Javascript - this gives you more guarantees over what errors you will get at runtime. 

## Recommended Workflow

---

### js_of_ocaml

Dune has built-in support for compiling byte-code to JS. Consider a "hello-world" example: 

```ocaml
(* main.ml *)
let () = print_endline "Hello World"
```

This can be built with `dune build`, with the `js_of_ocaml` package installed (to get the compiler) and the following dune file: 

```
(executable
 (name main)
 (modes js))
```

## Alternatives

---

### Bucklescript

An alternative is to use Bucklescript to compile your OCaml code to Javascript. At this point you will have to leave dune behind you and venture into the world of Bucklescript and `npm` - [this post on discuss OCaml](https://discuss.ocaml.org/t/js-of-ocaml-vs-bucklescript/2293/7) might be worthwhile reading to find out which is best for you. 

[BuckleScript · A faster, simpler and more robust take on JavaScript.](https://bucklescript.github.io/)

## Real World Examples

---

[janestreet/incr_dom](https://github.com/janestreet/incr_dom)