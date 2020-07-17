# Incorporating non-OCaml code into your project

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/cstruct%20c5b3b9a06ba248ceb3e2e27e17d3d5eb.md
Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/A%20Beginners%20Guide%20to%20OCaml%20Internals%202bb35cb1864f4b33bf40f31b11ac4acf.md, ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/Communication%20between%20C%20and%20Objective%20Caml%20fafade4513184ea29737b465a2362046.md
Short Description: Add C or Rust code to your OCaml project
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md

## Overview

---

Sometimes OCaml just can't do what lower level languages can do or you want to use pre-existing code written in C or Rust from OCaml. 

## Recommended Workflow

---

### Interacting with C

To interact with C code you need to use the Foreign Function Interface (FFI) in OCaml and make some changes to your `dune` files to incorporate the extra code. To use a foreign C function in OCaml you need to add: 

```ocaml
external <ocaml-name> : <type-of-function> = "<c-function-name>"
```

And then in your dune file you need to include the C code: 

```
(executable
 (name main)
 (foreign_stubs
  (language c)
  (names <c-filename>)))
```

Take care with the difference between how C represents runtime values and how OCaml represents them (covered in the linked resources page). See this dune documentation page for more options for the `foreign_stubs` and this OCaml manual page for a more formal introduction to the C FFI.

### Interfacing with C Structs

There is a `cstruct` library linked in the libraries tag that allows you to read and write structs from the C programming language. 

### Interacting with Rust

Coming soon...

## Real World Examples

---

### Using C code

[mirage/digestif](https://github.com/mirage/digestif/tree/master/src-c/native)

### Using Cstruct

[mirage/ocaml-git](https://github.com/mirage/ocaml-git)