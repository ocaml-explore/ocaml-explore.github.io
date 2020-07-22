# Thoughts whilst writing Workflows

1. If I'm building a new project (**not opam**) and I am adding CI there is no tool for installing just the dependencies I want from the dune file. `dune external-lib-deps --missing @@default` gets you part of the way there but not fully. 
    - Will *duniverse* solve this problem? Should *dune* be able to install the relevant opam packages and ask about OS system ones?
    - What does the opam-dune story look like, how tightly integrated will the two become? What jobs do they do - initialisation of opam files in dune?
2. The goal, as far as I can tell, is to unify the platform with the `opam` metadata file with its key use of versioning to support powerful compatability. 
    - This doesn't mean using the opam client (although it might be strongly recommended) - for new people is this confusing to have a metadata file called *opam* even if I'm not publishing it? Perhaps this is like asking whether I need the `package.json` file if I'm not putting it on `npm` - in which case it isn't so much of an issue.