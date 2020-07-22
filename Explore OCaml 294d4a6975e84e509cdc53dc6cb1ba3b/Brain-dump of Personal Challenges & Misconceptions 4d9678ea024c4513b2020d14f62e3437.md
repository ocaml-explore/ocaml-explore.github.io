# Brain-dump of Personal Challenges & Misconceptions

Probably the most confusing for me (and I would assume quite a few beginners) was the question of...

- What came first, opam, the ocaml compiler or dune?!
    - Right at the beginning I found this quite confusing for the following reasons:
        1. OCaml is written in OCaml to compile OCaml code - the classic bootstrapping compiler problem!
        2. I can install the OCaml compiler with opam... but opam is written in OCaml!
        3. Dune is also written in OCaml, and opam is built with dune, but opam installs dune?!!

### OCaml Compiler

---

- The compiler is [recommended to be installed using opam](https://ocaml.org/docs/install.html#OPAM) - however you are immediately confronted with creating switches (see **opam** below for that challenge). In addition to this is having the following in opam which (from an outsiders perspective) can be very confusing:
    1. `ocaml-base-compiler`: official release built from the source in opam 
    2. `ocaml-variants`: differently configured versions of the OCaml compiler for example `4.09.1+musl+static+flambda` is the 4.09.1 version of the standard OCaml compiler that is compiled with [musl libc](https://musl.libc.org/) that statically compiles code (not dynamically) and has the flambda optimisation in the compiler pipeline. 
    3. `ocaml-system`: this uses the OCaml installed by the OS package manager for example `brew` on MacOS. 
    4. `ocaml`: a *virtual package* which is what most libraries will depend on if they need the OCaml compiler. 

### opam

---

- Switches are defined as "*independent installation prefixes with their own compiler and sets of installed and pinned packages*" which is a lot to take in considering it's the first thing you encournter via the link above to install OCaml. *What is an installation prefix, what does it mean for a package to be installed vs. pinned?*
- Pinning is an interesting concept coming from a [JS/NPM world](https://medium.com/@the1mills/how-to-test-your-npm-module-without-publishing-it-every-5-minutes-1c4cb4b369be) (maybe the most well-known package manager + PL ecosystem?) where you have the idea of **linking** or **locally installing**. Again the usefulness of opam for recompiling packages which depend on your changed packaged is v. useful.  (Personal experience of building a MirageOS unikernel and tracking down an `ocaml-git` bug when using Irmin)
- Repositories are also a slightly foreign concept - for most users the default will suffice but if you are cross-compiling for example then you need to build your own and so there is a disconnect (imo) for these users between how opam actually works vs. the out-of-the-box "magic" that others can take for granted.
- I think there are a lot of useful workflows or combinations of commands that are regularly used but not really documented anywhere especially through a great RW example, for instance:
    - `opam show <package> (--raw)` is especially useful for whenever I was cross-compiling and adding
    - Another simple worlfow for starting with development easily is the following (originially I was cloning from Github, building the source and then installing when I never even had to leave the terminal!):

        ```bash
        opam source <package-xyz>
        cd ./<package-xyz> 
        # [edit, fix etc.]
        opam pin add <package-xyz> --kind=path 
        ```

### dune

---

- **Compositional builds** is definitely confusing coming from a JS/NPM world - in the first instance it feels like dune is doing too much without being asked - what solidifed this idea for me was building a project with a usable library (`/lib`), an executable which makes use of that library (`/bin`) and testing (`/test`). With a simple project like this you then get a good feel with how the build process works depending on where you initiate `dune build` from.
- **Cross-compilation** perhaps a little niche but the support for cross-compilation is actually **very good but again *"once you know it is easy"!*** This links in a lot with how opam works and more "advanced" uses of dune workspaces and files.