# Adding tests to your project

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/alcotest%20f73f1d737d8f426aa900b0e7905489fb.md
Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Related Workflows: Checking%20code%20coverage%20bfba2da357fd4cd097f16d8821dffda0.md, Meta-programming%20with%20PPX%2040be46b47adf449da741758ba4f314c8.md
Short Description: Write tests for your OCaml project
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Testing is critical to ensuring the longevity of your project. When writing code it is very likely some new implementation will break something you wrote before. Testing provides visibility into this. 

There are lots of ways you can go about testing and a large part of this is dependent on the type of project you are working on - is it a command line tool, a library, a web-application etc. This workflow focuses mainly on writing unit tests for your OCaml code and so will likely be applicable to most applications. 

## Recommended Workflow

---

### Testing a library with Alcotest

Alcotest (linked in the libraries) is a unit testing framework. It has a very good example in the repository README. 

To add unit testing to your library you'll want to create a test directory with the following `dune` file. 

```
; located in tests/dune
(test
  (name test)
  (libraries <library-public-name> alcotest))
```

The test entry point will be a `test.ml` file, which may look something like: 

```ocaml
(* tests/test.ml *)
let () = 
  Alcotest.run "Numbers" [
    "Fib", Test_fib.tests;
  ]
```

Each module can then get its own `test-module.ml` which exports in the  `.mli` file, a list of Alcotest tests. 

```ocaml
(* tests/test_fib.ml *)
let test_int () = 
	Alcotest.(check int) "fib of 10" 55 fib2

let tests = [
	"test_int", `Quick, test_int
]

(* tests/test_fib.mli *)
val tests : unit Alcotest.test_case list
```

The documentation for Alcotest has a more thorough examples and the **real world examples** section at the bottom links some libraries which are already using Alcotest to perform unit testing. 

The tests can be run from the command line with `dune runtest` - it is also common to augment your opam file's build command with running tests: 

```
build: [
 ["dune" "build" "-p" name "-j" jobs]
 ["dune" "runtest" "-p" name] {with-test}
]
```

### Testing executables with MDX

Alcotest offers a flexible but relatively simple way for testing functionality within components of your program. If you project is a CLI tool or an executable run from the command-line you will need another tool for testing it.

Mdx allows you to write markdown with executable blocks, this could be in pure OCaml or in shell script. With dune's promote feature you can take snapshots of what *expect* your program to produce and ensure subsequent code doesn't break this. 

If it does make changes (ones you want) you can promote the new changes to your file and commit the results. If you have ever worked with [ReactJS and Jest snapshots](https://jestjs.io/docs/en/snapshot-testing), it is very similar. 

Take for example a simple CLI tool that takes a number and prints that number plus one.

```ocaml
(* --- bin/main.ml -------------- *)
let () =
  if Array.length Sys.argv < 2 
	then print_endline "Need to supply a number"
  else print_int (int_of_string Sys.argv.(1) + 2)
```

Which with an appropriate opam file can be built with the following dune file. In order to make to globally available with a `public_name` we need the opam file.  

```
(* --- bin/dune -------------- *)
(executable
 (name main)
 (public_name main))
```

Now we can build a simple test of the CLI tool using mdx. In a `tests/bin` folder we writes a `test.md` file and pass it some tests in markdown code blocks. 

```markdown
# Testing the command line 

## Should print that a number should be supplied 
```sh
$ main
```

## Should print that 11 
```sh
$ main 10
```

## Should print that 0 
```sh
$ main -1
```
```

And add a dune file: 

```
(mdx
 (files test.md)
 (packages main))
```

Now when we run `dune runtest` we'll be greeted with a diff of our markdown file with the proposed outputs of our small shell scripts. We can add these to the file by promoting them with `dune promote` then commit them to the repository. If tests fail in the future we will get the diff and can decided whether to promote them or not. 

```diff
## Should print that a number should be supplied 
 ```sh
 $ main
+Need to supply a number
 ```
 
 ## Should print that 11 
 ```sh
 $ main 10
+11
 ```
 
 ## Should print that 0 
 ```sh
 $ main -1
+0
 ```
```

## Alternatives

---

### QCheck

[QCheck](https://github.com/c-cube/qcheck) is based on Haskell's [QuickCheck](https://hackage.haskell.org/package/QuickCheck) library for property-based testing. It also offers a sub-library that can integrate directly with Alcotest.  

### Dune Expect Tests

These tests tend to be written inline with your source OCaml code using `ppx_inline_test`. To get expect tests you can use `ppx_expect` to write assertions about parts of your program. The [documentation](https://dune.readthedocs.io/en/stable/tests.html) covers all of this in much more detail. 

## Real World Examples

---

[Yojson](https://github.com/ocaml-community/yojson/tree/master/test) is good example of using Alcotest to unit test the different aspects of the library. [Dune-release](https://github.com/ocamllabs/dune-release/tree/master/tests/bin), part of the OCaml Platform, uses Mdx to ensure the CLI tool is properly tested.