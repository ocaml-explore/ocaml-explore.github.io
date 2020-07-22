# Profiling my project?

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/dune%207063fd3c0d5d4074b7a5c0d97933149c.md
REMOVE ME: Drafted: Yes
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/A%20Brief%20Trip%20through%20Space%20Time%20b0e475d9dbb441b689c136e26d109b1d.md, ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/Profiling%20OCaml%20Code%20955474bf5a1b4aa3b3c228e3da0f50c9.md
Short Description: Profile the memory and peformance of your application
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

For profiling programs there tend to be two main properties that most developers care about: 

1. Performance
2. Memory Usage

OCaml is a garbage-collected programming language, but there are ways to alleviate the the strain on the GC. There is also good support for profiling the performance of your program to find the sections that are consuming the most execution time. 

## Recommended Workflow

---

### Memory

To enable memory profiling (much like with fuzzing) you need to install specific variants of the OCaml compiler - in particular it must have `+spacetime` in its package name. 

Spacetime monitors the OCaml heap - this is where values are stored if they are not represented as unboxed integers. You can set the interval you want spacetime to monitor at by issuing: 

```bash
ocamlopt -o <executable> somefile.ml
OCAML_SPACETIME_INTERVAL=1000 <executable>
```

***Note: this is a little dependent on what shell you use, for example with fish you will have to preprend `env` to the `OCAML...` command.*** 

The workflow is very similar to `gprof` with OCaml in that you run the instrumented version which produces additional files, and then use a tool to make sense of the results. If we have some `mem_test.ml` file we want to profile, the series of commands may look something like this: 

```bash
# Create a new spacetime enable switch 
opam switch create 4.10.0+spacetime
eval $(opam env)

# Install the memory profiling view
opam install prof_spacetime 

# Compile your code
ocamlopt -o mem_test mem_test.ml

# Run the executable with profiling enabled 
OCAML_SPACETIME_INTERVAL=1000 ./mem_test

# Process the results - fill in your unique <id>
prof_spacetime process spacetime-<id>

# View the results in a browser 
prof_spacetime serve -p spacetime-<id>.p
```

### Performance

Perf is a tool that can be used to profile programs without any additional instrumentation. 

## Alternatives

---

### Performance with `gprof`

***Note: gprof is only supported up to version 4.08.0 of the OCaml compiler. Additionally, because of the required linking options with Clang and MacOS you may encounter the following error "**the clang compiler does not support -pg option on versions of OS X 10.9 and later**"*** 

[Gprof](https://sourceware.org/binutils/docs/gprof/) is the GNU profiler and can be used to track how much time is spent in different parts of your application. Like memory profiling this requires additional instrumentation in your binaries. However, unlike spacetime profiling, it doesn't require a specific switch, just some flags to be set. 

In the simplest case (compiling by hand) the following is sufficient: 

```bash
# Create compatible compiler in new switch  
opam switch create 4.08.0
eval $(opam env)

# Compile the code with profiling enabled 
ocamlopt -p -o test test.ml 

# Run the code
./test

# View the results 
gprof test | less 
```

If you are using dune to build your project you will need something like the following in your dune file at the root of your project: 

```
(env
 (perf
  (flags (:standard -p))))
```

There after the process is very similar: 

```
# Compile the program with profiling enabled 
dune build --profile perf 

# Run the program
_build/default/test.exe

# See the profiling results 
gprof _build/default/test.exe | less 
```

### Real World Examples

---