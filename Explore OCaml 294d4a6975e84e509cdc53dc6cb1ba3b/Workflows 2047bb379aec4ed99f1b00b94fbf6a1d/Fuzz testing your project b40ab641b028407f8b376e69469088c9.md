# Fuzz-testing your project

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/bun%2078ac8d6aa4b343b9a6658c4d2ec7a757.md
REMOVE ME: Drafted: No
Related Workflows: Adding%20units%20tests%20to%20your%20project%20a53ff6e7d3914ff89fad69fa603a309a.md
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/An%20Introduction%20to%20Fuzzing%20Ocaml%20with%20AFL%20Crowbar%20%20a2f244adab7b472b9af0713ab443c6e9.md
Short Description: Make fuzz tests to find bugs in your code
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md

## Overview

---

Fuzz testing (or fuzzing) is a way to find test cases that break your code programmatically using instrumented binaries. This can extremely useful for complex parsers or protocols which are expected to cope with a large variety of inputs.

## Recommended Workflow

---

To get started with fuzzing your project you will need to do the following: 

1. Install AFL on your machine 
2. Install an AFL variant of the OCaml compiler into a new switch
3. Install crowbar and bun using opam 

This Github repository and the accompanying article found in the resource tag are a great place to start. 

[NathanReb/ocaml-afl-examples](https://github.com/NathanReb/ocaml-afl-examples)

## Real World Examples

---