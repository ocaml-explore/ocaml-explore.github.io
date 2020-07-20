# Compiling for Y on X

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/OCaml%20on%20Baremetal%20Shakti%20RISC%20V%20Processor%20c88def6eb57b47699d0b4415b0711207.md
Short Description: Compile code to run on different architectures
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Cross-compiling in OCaml is still an experimental feature, but there are plans to make it a fully supported one in the future. 

Cross-compiling allows a programmer on an *x86* machine to compile OCaml code to run on a *RISC-V* device. **Usually the target architecture is the same as the architecture our machine is running on. This is particularly useful for embedded devices running architectures like *ARM-32, ESP-32 or RISC-V*. 

## Recommended Workflow

---

Dune has built-in support for cross-compilation thanks to toolchains in OCamlfind. To work with cross-compiling you will need the following: 

1. The appropriate cross-compiling toolchains installed - OCaml uses a C compiler to build the OCaml compiler so a cross-compiling C compiler will be necessary. 
2. A switch with a cross-compiling repository setup - this will handle installing the OCaml cross-compiler.

Luckily, that is fairly easy. Below, in real world examples, there are some repositories you can use. Instructions for installing say the *RISC-V* cross-compiler can be found in [this Dockerfile](https://github.com/patricoferris/ocaml-on-riscv/blob/trunk/opam/Dockerfile). In the future the OCaml compiler will support cross-compilation out-of-the-box but for now you will have to use some modified versions of the compiler. 

## Real World Examples

---

### Example opam repositories

[Well-typed lightbulbs](https://github.com/well-typed-lightbulbs)

[mirage-shakti-iitm](https://github.com/mirage-shakti-iitm)