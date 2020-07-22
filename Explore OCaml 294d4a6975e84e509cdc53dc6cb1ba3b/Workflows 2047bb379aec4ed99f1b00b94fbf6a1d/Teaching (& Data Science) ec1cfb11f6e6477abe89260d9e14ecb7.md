# Teaching (& Data Science)

Libraries: ../Community%20Libraries%207088de737dff4e97934677e854bc7de8/owl%209c4ae49c13a04a2bb0232370f2eb9216.md
REMOVE ME: Drafted: Yes
Short Description: Setup Jupyter Notebooks with OCaml
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Beginner%207994c560f3ee4d2f98c13b14be0a8065.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Teachers%209c24549abbc14de8be59002ea1bd42b3.md

## Overview

---

Jupyter notebooks combine an interactive read-evaluate-print-loop (REPL) with markdown text (with support for LATEX) to offer a unique solution for people wanting to teach, explore OCaml or perform more data-centric operations (ML models etc.) 

From a learning point-of-view, students are more concerned with *syntax* and *concepts* rather than tooling (in the beginning). Much like `utop` the REPL format is great for learning, but with **jupyter** you can also write notes, explain algorithms etc. 

## Recommended Workflow

---

### Locally Running an OCaml Jupyter Notebook

The best way to get *ocaml-juptyer* up and running is through `opam` and installing `jupyter` using `pip` the python package manager. More information on python and `pip` can be found in their [documentation](https://docs.python.org/3/installing/index.html).

With `pip` and `opam` installed, the following should represent a typical way of getting started with a jupyter notebook with an OCaml kernel.

```bash
$ pip install jupyter # Install jupyter
$ opam install jupyter # Install jupyter opam package 
$ opam install jupyter-archimedes  # Jupyter-friendly 2D plotting library
$ ocaml-jupyter-opam-genspec
$ jupyter kernelspec install [ --user ] --name ocaml-jupyter "$(opam var share)/jupyter"
```

Further documentation can be found at in the [OCaml Jupyter repository](https://github.com/akabe/ocaml-jupyter). 

### Presentation tools

For teachers or presenters you can use the [RISE](https://rise.readthedocs.io/en/stable/) tool to present your code and text in the browser from a running OCaml Jupyer Notebook. It will generate interactive slides from the code and text blocks in your notebook. 

## Alternatives

---

### Using Docker to run a Notebook

Using the link below, a jupyter notebook can be created inside a docker container and connected to a port so users can begin coding fairly quickly. This involves a second level of indirection in installing docker. 

- *Limitations - the dockerfiles exposed here are very data-science oriented (i.e. large images with many preinstalled packages) and only go up to OCaml 4.07.*

```bash
docker run -it -p 8888:8888 akabe/ocaml-jupyter-datascience -v $PWD:/notebooks akabe/ocaml-jupyter-datascience
# Go to http://localhost:8888/?token=<token>
```

[akabe/docker-ocaml-jupyter-datascience](https://github.com/akabe/docker-ocaml-jupyter-datascience)

## Real World Examples

---

[](https://kcsrk.info/ocaml/prolog/jupyter/notebooks/2020/01/19/OCaml-Prolog-Jupyter/)