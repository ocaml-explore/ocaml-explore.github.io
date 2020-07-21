# Initialising a new Library

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: No
Short Description: Build the scaffolding for your solution to a problem
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md

## Overview

---

Getting started with a project should be simple - ideally a single command would initialise some kind of wizard to guide you through setting a project up. Much like the `npm init` command which takes answers to populate the `package.json` file. 

This is important because it is very easy to make mistakes in setting up a repository for a new project and the ideal workflow for a library author would to start writing code almost immediately.

## Recommended Workflow

---

Dune is the best tool for doing something like this (although AFAIK there's no out-of-the-box support for initialising this with opam integration). 

Dune Terminology: 

[Overview - dune documentation](https://dune.readthedocs.io/en/stable/overview.html?highlight=%22installed%20world%22#terminology)

The key ones include:

- **package** - a package is a set of libraries, executables, … that are built and installed as one by opam.
- **project** - a project is a source tree, maybe containing one or more packages
- **workspace** - the workspace is the subtree starting from the root. It can contain any number of projects that will be built simultaneously by dune.

From the documentation: 

> `dune init` can be used to quickly add new projects, libraries, tests, or executables without having to manually create dune files, or it can be composed to programmatically generate parts of a multi-component project.

---

All in all I think the terminoloygy and documentation is a little confusing for the following reasons: 

1. The terms are all quite overloaded and finding the terminology page on the *readthedocs* page is not easy... for instance "I want to build a new OCaml project" `===` "I want to build *a source tree containing one or more packages which can be built and installed as one by opam"*? 

    [Welcome to dune's documentation! - dune documentation](https://dune.readthedocs.io/en/stable/)

2. From the definition of **package and then reference in project** it feels like there is a very tight coulpling between opam and dune. Whilst there is a good integration I believe the two are flexible enought to use separately, and powerful when combined.