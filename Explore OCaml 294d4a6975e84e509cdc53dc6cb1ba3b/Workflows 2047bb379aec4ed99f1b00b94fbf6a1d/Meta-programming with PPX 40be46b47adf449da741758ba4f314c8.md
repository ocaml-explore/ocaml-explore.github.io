# Meta-programming with PPX

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/ppxlib%2037e855f600f54f9799c2e34397faa7e9.md
Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/An%20Introduction%20to%20OCaml%20PPX%20Ecosystem%2006ee81c2a7464c6c9d8a421d851071eb.md
Short Description: Automate code generation with meta-programming
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Ppx allows programmers to meta-program directly on the abstract syntax tree of OCaml code. This means simple tasks like writing comparison functions or hashing functions can be automated through clever inference on types.  

## Recommended Workflow

---

### Using PPX libraries

Dune comes with ppx support which makes it very easy to start using different ppx libraries to meta-program in OCaml. In this example we will add `ppx_hash` to a small example. 

Suppose we have type of person - to generate a hashing function we label it with a type attribute:

```ocaml
(* person.ml file *)
open Core

type person = {
	name: string;
	age: int;
} [@@deriving hash]

let () = 
	let p = { name = "Alice"; age = 42 } in 
		Printf.fprintf stdout "%i\n" (hash_person p)
```

This example illustrates that ppx libraries can make assumptions - `ppx_hash` expects the Jane Street Core standard library to be open in order to use some of the functions that are there that aren't in the standard library packaged by OCaml. 

The dune file will be:

```
(executable
  (name person)
	(libraries core)
	(preprocess (pps ppx_hash)))
```

### Writing PPX libraries

To write your own ppx library you are strongly encourage to use `ppxlib` (linked in the libraries section). It provides a wrapper around the compiler hooks that ppx uses to modify the AST. The user documentation does a very good job at getting you started writing your own ppx libraries. 

[ppxlib's user manual - ppxlib documentation](https://ppxlib.readthedocs.io/en/latest/)

In addition to that, the article in the resources tag does a very thorough job of explaining how to use ppxlib. 

## Real World Examples

---

[ocaml-ppx/ppx_deriving_yojson](https://github.com/ocaml-ppx/ppx_deriving_yojson)

[ocaml-ppx/ppx_deriving_protobuf](https://github.com/ocaml-ppx/ppx_deriving_protobuf)