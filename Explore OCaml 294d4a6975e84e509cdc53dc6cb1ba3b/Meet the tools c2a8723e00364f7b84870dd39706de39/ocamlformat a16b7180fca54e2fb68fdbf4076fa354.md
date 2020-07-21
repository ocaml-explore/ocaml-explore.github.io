# ocamlformat

Created: Jul 6, 2020 11:03 AM
Related Workflows: ../Workflows%202047bb379aec4ed99f1b00b94fbf6a1d/Keeping%20your%20code%20clean%207443e9c915104226840b1e0a19cd9cd8.md
Tags: editing

## Overview

---

[OCamlFormat](https://github.com/ocaml-ppx/ocamlformat) is a tool for applying formatting decisions to an OCaml project - it supports 

## Key Concepts

---

### Versioning

Like dune and opam, OCamlFormat uses versioning to ensure different installations of the tool don't mangle lots of code by accident when different versions are used. This is likely the only required property to set in the `.ocamlformat` file. 

It's important to note that OCamlFormat will not be able to change the formatting of syntactically incorrect code.

### Options

The full, tuneable options list can be seen with `ocamlformat --help` but some of the more prevalent ones are: 

- *parse-docstring=true:*  this will ensure OCamlFormat
- *break-infix*

## In the Wild

---