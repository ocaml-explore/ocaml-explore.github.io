# Fixing Bugs in 3rd Party Packages

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/The%20Joys%20of%20Dune%20Vendoring%20948cd0835a5147f3845accc3ba655dc5.md
Short Description: Track down bugs in libraries you use
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md

## Overview

---

Working with third-party packages means coming across areas for improvement or those that need fixing. Knowing how common codebases are structured and an appreciation for the tools allows you to more easily:

- Fix the bug if you know how.
- Raise an issue wherever the code is being hosted on.
- Find and comment on an existing issue with extra information you have from my own debugging.

This will also give you insight into how you can structure your own code to allow others to more easily debug it. 

There are multiple aspects to unpack in this workflow including: 

1. Getting the source code.
2. Pinning packages locally. 
3. Logging libraries 

Quite a lot of this workflow is made simpler by using the opam client. 

[opam client](../opam%20client%20af5eb8b02bdf4c17931004d79002243e.md)

## Recommended Workflow

---

### Getting the Source Code

If the library is part of the *opam-repository* then the easiest way to get the source code is using the opam client: `opam source <package>` - this can also be given an optional version constraint.

```bash
# Downloads latest version of Irmin - at time of writing 2.2.0
opam source irmin

# Download the 2.0.0 version of Irmin
opam source irmin.2.0.0
```

If you envisage wanting to make a pull request to fix something then forking and cloning the package is probably a better way to go about it.

```bash
git clone https://github.com/patricoferris/irmin.git
cd irmin
git checkout -b my-awesome-fix
```

### Locally pinning

To tell opam that you want to use a modified version of a package you **pin** it. This is like pinning a note to the package in the opam-respository that points to the source code you are developing (rather than the locally clone released version from Github). 

```bash
# In the clone irmin directory 
opam pin add irmin . --kind=path 
```

Note: it is quite common to have multiple opam packages per repository. Irmin for example has `irmin`, `irmin-unix`, `irmin-graphql`... If your changes are only for a certain package it is best to only pin that one package. `--kind=path` means we don't have to commit the changes as by default opam tries to use git pins. 

Opam will rebuild dependent projects as well - depending on what package you change and how many dependent projects you have installed in your switch this can take a bit of time.

### Subsequent Changes & Upgrading

Pinning a package tells opam where the source code is coming from but as you add new bits of code, opam doesn't see these. In order to add those you will have to run `opam upgrade` to get the latest changes of pinned packages. 

"The Joy of Dune Vendoring" linked in the resources discusses this process and the future of vendoring in OCaml.