# Adding units tests to your project

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/alcotest%20f73f1d737d8f426aa900b0e7905489fb.md
Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Related Workflows: Checking%20code%20coverage%20bfba2da357fd4cd097f16d8821dffda0.md, Meta%20programming%20with%20PPX%2040be46b47adf449da741758ba4f314c8.md
Short Description: Write unit tests and  for your OCaml project
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Testing is critical to ensuring the longevity of your project. When writing code it is very likely some new implementation will break something you wrote before. Testing provides visibility into this. 

There are lots of ways you can go about testing and a large part of this is dependent on the type of project you are working on - is it a command line tool, a library, a web-application etc. This workflow focuses mainly on writing unit tests for your OCaml code and so will likely be applicable to most applications. 

## Recommended Workflow

---

### Alcotest

Alcotest (linked in the libraries) is a unit testing framework. It has a very good example in the repository README. 

To add unit testing to your library you'll want to create a test directory with the following `dune` file. 

```
(* dune file at root *)
(test
  (name test)
  (libraries <library-public-name> alcotest))
```

The test entry point will be a `[test.ml](http://test.ml)` file, which may look something like: 

```ocaml
(* test.ml in /tests *)
let () = 
  Alcotest.run "<Your-Library>" [
    "Module1", Test_module1.tests;
    "Module2", Test_module2.tests
  ]
```

Each module can then get its own `[test-module.ml](http://test-module.ml)` which exports in the  `.mli` file, a list of Alcotest tests. 

The documentation for Alcotest has a more thorough examples and the **real world examples** section at the bottom links some libraries which are already using Alcotest to perform unit testing. 

The tests can be run from the command line with `dune runtest` - it is also common to augment your opam file's build command with running tests: 

```
build: [
 ["dune" "build" "-p" name "-j" jobs]
 ["dune" "runtest" "-p" name] {with-test}
]
```

## Alternatives

---

### QCheck

QCheck is based on Haskell's [QuickCheck](https://hackage.haskell.org/package/QuickCheck) library for property-based testing. It also offers a sub-library that can integrate directly with Alcotest.  

[c-cube/qcheck](https://github.com/c-cube/qcheck)

### Dune Expect Tests

These tests tend to be written inline with your source OCaml code using `ppx_inline_test`. To get expect tests you can use `ppx_expect` to write assertions about parts of your program. The documentation covers all of this in much more detail. 

[](https://dune.readthedocs.io/en/stable/tests.html)

## Real World Examples

---

[mirage/irmin](https://github.com/mirage/irmin/tree/master/test)

[ocaml-community/yojson](https://github.com/ocaml-community/yojson/tree/master/test)