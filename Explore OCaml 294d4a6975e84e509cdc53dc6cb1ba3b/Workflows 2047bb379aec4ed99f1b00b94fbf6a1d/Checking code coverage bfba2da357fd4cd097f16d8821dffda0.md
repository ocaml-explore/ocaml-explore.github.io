# Checking code coverage

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/bisect%2057731217c9134fefbdb3a8548fde2496.md
Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Related Workflows: Adding%20tests%20to%20your%20project%20a53ff6e7d3914ff89fad69fa603a309a.md
Short Description: Use the bisect tool to discover how much of your code is being tested
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Code coverage can be a good indicator into how well your code does what it is supposed to do. Of course, the goal is not to blindly chase 100% coverage, but to use the output to help you write correct and maintainable code. 

## Recommended Workflow

---

Setting up code coverage requires changes to your `dune` file for the libraries you want to cover. You will also need to update your opam file to depend on `ppx_bisect`. The opam file will add `bisec_ppx` as a dependency: 

```
depends: [
	...
  "bisect_ppx" {dev & >= "2.0.0"}
] 
```

And in the a library we want to cover, say a library called `numberz` we need to add a preprocessor. 

```
(library
 (name numberz)
 (public_name numberz)
 (preprocess (pps bisect_ppx --conditional)))
```

To run the tests with bisect enabled and to get the summary of the coverage you can run: 

```bash
# This will produce the bisect results 
BISECT_ENABLE=yes dune runtest --force

# Tells you in the terminal 
bisect-ppx-report summary

# Produces coverage in _coverage directory
bisect-ppx-report html
```

## Real World Examples

---

[arenadotio/ocaml-mssql](https://github.com/arenadotio/ocaml-mssql)