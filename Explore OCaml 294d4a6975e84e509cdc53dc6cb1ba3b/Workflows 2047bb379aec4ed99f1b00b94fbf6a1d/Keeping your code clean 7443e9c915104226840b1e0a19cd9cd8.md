# Keeping your code clean

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/ocp%20indent%208fe145b1c11b4b4cbef8fcad4f53c8d8.md, ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/ocamlformat%20a16b7180fca54e2fb68fdbf4076fa354.md
REMOVE ME: Drafted: Yes
Related Workflows: Setting%20up%20useful%20OCaml%20tools%20for%20my%20editor%20fe47e509d4d445129d16f4688255d1c9.md
Short Description: Indent and reformat code to follow good styling
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Having a unified approach to formatting is important for multiple reasons: 

- Good for beginners: using tooling to help properly format, code-complete, syntax highlighting etc. removes this burden (somewhat) for new people lowering the barrier of entry for contributions.
- Easier to read: the code tends to be easier to read (or will be once the standard formatting is learnt) which helps onboard new people to a codebase and also discover bugs.

## Recommended Workflow

---

### OCamlformat

OCamlformat tends to be the tool of choice for enforcing formatting styles in a project. It requires a very simple `.ocamlformat` file in the root of the project which can specify a few configuration options. 

A bare bones file will contain the version of OCamlformat you want to use:

```
version=0.14.2
```

From there, depending on your setup and editor, you can:

- Run `ocamlformat` on builds
- Run `ocamlformat` when saving a file (works very well with VS Code)

Formatting on save should just work if you have the OCaml Platform plugin installed in VS Code (see related workflows)

### Ocp-indent

Ocp-indent is an indentation tool for OCaml. It is particularly useful for *vim* and *emacs.* If you followed the setup for those editors in the related workflow you should only need to add the following to your `.vimrc`. 

```
set rtp^="$(opam config var ocp-indent:share)/vim"
```

## Real World Examples

---

[mirage/alcotest](https://github.com/mirage/alcotest/blob/master/.ocamlformat)

[ocaml-ppx/ocamlformat](https://github.com/ocaml-ppx/ocamlformat/blob/master/.ocp-indent)