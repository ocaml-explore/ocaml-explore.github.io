# Setting up useful OCaml tools for my editor?

Platform: ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/Visual%20Studio%20Code%2014e32d99506e4f42a462bed0a706187b.md, ../Meet%20the%20tools%20c2a8723e00364f7b84870dd39706de39/merlin%20bb56a8747cb240efbd89db334e6e1f0d.md
REMOVE ME: Drafted: Yes
Related Workflows: Keeping%20your%20code%20clean%207443e9c915104226840b1e0a19cd9cd8.md
Resources: ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/Vim%20from%20Scratch%20bae7b1234e5446e19caad52ef211e354.md, ../Further%20Reading%20e586ad911323446196997e9cdc77d17f/Emacs%20from%20Scratch%20ec099ab070a8423b8cfbafe95875dc1f.md
Short Description: Add syntax highlighting and code completion in your project
Users: ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Library%20Authors%2033d664dd3a4d487a9f707092c9bd4b6b.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Beginner%207994c560f3ee4d2f98c13b14be0a8065.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Teachers%209c24549abbc14de8be59002ea1bd42b3.md, ../Archetypical%20Users%20e3ac9b12886f4eb382d8d03da27ab6ff/Application%20Developers%205158b951046948ae8080c5faae4c5485.md

## Overview

---

Having a helpful development environment can boost productivity and help catch errors early. OCaml has a powerful type system which reduces runtime errors, with a good editor setup you'll be able to catch them before you run `dune build`.

## Recommended Workflow

---

The recommended editor for OCaml is **Visual Studio Code** - an editor with a rich ecosystem of useful plugins, themes and developer tools. 

To get the best setup, there is a marketplace plugin and an opam package that must be installed. 

```bash
# This is the language server protocol for OCaml
opam install ocaml-lsp-server

# Install the OCaml Platform on VS Code Marketplace 
```

From here make sure to add a `workplace` to VS Code for your project. And watch out for the following errors: 

- VS Code might complain about not being able to find `ocaml-lsp` - this is done on a per switch basis and clicking on the dialog box should let you pick the switch you installed it on.

## Alternatives

---

### VS Code

Other extensions exist which offer support for OCaml and Reason including: 

[hackwaly/vscode-ocaml](https://github.com/hackwaly/vscode-ocaml)

[reasonml-editor/vscode-reasonml](https://github.com/reasonml-editor/vscode-reasonml)

### Vim

The to use with vim is merlin. OCaml LSP is the next generation of merlin, but for vim you will need merlin installed. There is also a useful opam plugin for getting up and running with the merlin features:

```bash
opam install merlin ocp-indent 
opam user-setup install 
```

To get code completion you will need to enable omnipresent in your `.vimrc` file: 

```
filetype plugin on
set omnifunc=syntaxcomplete#Complete
```

Then whilst in `INSERT` mode type `ctrl+c ctrl+o` to see completions for something like `List.m`. 

For syntax errors you need to add *syntastic* as a vim plugin. For this you'll need a vim plugin manager like pathogen. The [syntastic documentation](https://github.com/vim-syntastic/syntastic) will let you get started and then add the following to your `.vimrc` file. 

```
execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_ocaml_checkers = ['merlin']
```

For more features and information be sure to read the wiki on merlin linked in the resources. 

### Emacs

The workflow for emacs is very similar to vim. 

```bash
opam install merlin ocp-indent 
opam user-setup install 
```

After that the documentation in "Emacs from Scratch" linked in the resources tag will guide you through setting up OCaml with emacs.