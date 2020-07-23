# Explore Version 2

## Brief Analysis of Current Method

---

What is ***wrong*** with the current method: 

1. Reliance on Notion - relies on reverse-engineering the Notion API, this could change at the drop of a hat or how they export things. 
2. Data representation and losing information - the export function is not lossless, the filtering and sorting of tables is gone.   
3. Inflexible - if we wanted to add `mdx` support, we can't do this that easily at all. 

What is ***good*** about the current method: 

1. Ease of adding content - Notion is great for adding content, it makes it easy to get people up and running with creating workflows, this is something that should be kept. 
2. Living document - their is a friction with documentation that the harder it is to add new things or update content, the more quickly it will all become outdated. Notion lets the content live with the build tool taking "snapshots" for displaying. 

## Proposal for New Infrastructure

---

### Principles

1. It should be easy to add new content for almost anybody that says "I have an idea for a workflow you could add" or "could we add community library `X` to do `Y`" - this makes it accessible and less likely to quickly become outdated. 
2. It should be easy to validate content - à la `mdx`.
3. It shouldn't be reliant on "unready" tools (like the Notion API) - this is too brittle and will cause more headaches than it is worth. 

### Idea

- Content - Markdown pages with YAML front-matter to record metadata and relations (User `X` related to Workflow `Y`)
- CMS - to get the "ease of adding content" we could use NetlifyCMS. This gives us control over the metadata. This is a simple portal for exposing a Github repository to users to edit markdown. I've added my own personal one below. Saving the work adds a new branch to the repo (multiple saves are commits to this branch), based on the user role they can then change the status to "read for review" (a.k.a PR) and then admin can review and merge (publish). Handling the authentication can be done with Netlify (or Github OAuth, thought this requires a server).

    ![Explore%20Version%202%20ae2747214bbd4c7bb0c1232ceacc6db6/netlifycms.png](Explore%20Version%202%20ae2747214bbd4c7bb0c1232ceacc6db6/netlifycms.png)

- Mdx - I think it would be great to incorporate Mdx like in RWO. Documentation doesn't only struggle from being outdated, it struggles from being wrong! Mdx can help mitigate this. For user wishing to add a workflow using mdx they would have to go through the traditional "clone repo, add work, make PR" approach.

### Build & Porting

- The way I see it there are two main options with this approach - one, we could use a modern static site generator like GatsbyJS which I have quite bit of experience with, but this comes with the problem of still needing an OCaml build process for the Mdx part. This could be mitigated in option two, and do it all purely in OCaml.
- In terms of porting the existing content - whilst it'll be a little tedious, it really only boils down to creating new markdown files for each of the workflows, users, tools and libraries, then adding metadata and changing internal links in the content to point to the new files where appropriate. After this the portal would handle new workflows etc.
- Build Process:
    1. `dune build` - this builds the `explore` site builder tool but also performs the tests for mdx content in the markdown files to make sure everything is as expected. 
    2. 

 

### Similarities to RWO

It feels very like RWO at the moment, the major difference being if we decide to host on Netlify then we get the added authentication with the portal.