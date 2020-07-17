# opam files

Your project's opam file is the key to unlocking the power of the OCaml Platform. It will be used for much more than just publishing your library for others to use - with it for example you can:

- Automate the installation of external dependencies
- Give users points of contact - like where to submit issues
- Pin your project locally making it much easier to develop other tools and do continuous integration

### Versioning

One of the best features of opam files is versioning. Every file begins with `opam-version`, a field indicating what version of opam your project uses.  

### Example File

Below is a very minimal opam file and underneath explanations for parts which need them:

```
opam-version: "2.0"
version: "~dev"
synopsis: "A short sentence about your project"
maintainer: "<username> <email>"
authors: "<username1> <email1>"
license: "ISC"
homepage: "<github-page-or-similar>"
bug-reports: "<github-issues-page-or-similar>"
depends: [
  "ocaml"   {>= "4.07.0"}
  "dune"    {>= "2.0.0"}
  "zarith"
  "alcotest" {with-test}
]
build: [
  ["dune" "build" "-p" name "-j" jobs]
  ["dune" "runtest" "-p" name] {with-test}
]
```