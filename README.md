# gciruelos.com

Bash static site generator. Converts Markdown posts into HTML + RSS.

## Build

```bash
make build    # Build the site (output in __site/)
make watch    # Build and serve locally on port 9999
make diff     # Compare generated site at HEAD vs origin/master
make clean    # Remove build artifacts
```

**Dependencies**: Pandoc, HTML Tidy, GNU sed, Python 3.

## Post format

Posts live in `posts/` as `.markdown` files:
```
---
title: Post Title
url: /blog/post-slug.html
---
```
Filename date prefix (e.g. `2025-10-05-`) determines the post date. `<!--more-->` marks the end of the index page teaser.
