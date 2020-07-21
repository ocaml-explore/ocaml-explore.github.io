# ocp-indent

Created: Jul 6, 2020 11:05 AM
License: LGPL v2.1 with linking exception
Related Workflows: ../Workflows%202047bb379aec4ed99f1b00b94fbf6a1d/Keeping%20your%20code%20clean%207443e9c915104226840b1e0a19cd9cd8.md
Tags: editing

## Overview

---

[Ocp-indent](https://github.com/OCamlPro/ocp-indent) is an indentation tool for OCaml. Unlike Python, the level of indentation will not change the semantics of your OCaml program, but it will make it more or less readable.  For complete styling you should use OCamlFormat and for indentation, Ocp-indent. 

## Key Concepts

---

### Tuneable Parameters

The complete set of tuneable parameters are quite nicely given in the `.ocp-indent` file for [Ocp-indent itself](https://github.com/OCamlPro/ocp-indent/blob/master/.ocp-indent). The simplest is the *base* parameter which will make sure code is indented in a standard way

```
(* base = 2 *)
let foo () = 
^^bar ....
```

### Syntax Extensions

Ocp-indent comes with useful extensions for the OCaml language - in particular you can use the *mll* extension for 

## In the Wild

---