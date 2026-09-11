---
name: "zettelkasten-find"
description: "Строит root-relative AsciiDoc-индекс поиска по активным notes/*.adoc."
---

# zt-find

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/840592f0-a0c8-11f1-8dcc-5b07adb9ae5d.adoc` — Навык zt-find — редакция 2026-08-26.

## Activation

Use to generate an AsciiDoc search index for a case-insensitive text query.

## Sources

- `.scripts/lib/paths.zsh`
- `.scripts/zt-find.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DOC-004`, `DEPR-002`, `FZF-005`

## Procedure

1. Require a non-empty search expression.
1. Search active `notes/*.adoc` documents and exclude deprecated documents.
1. Emit an AsciiDoc representation with `:type: index`.
1. Use each matching document's UUID filename and `:description:` and emit root-relative links as `link:notes/UUID.adoc[Description]`.
1. Write to stdout unless the user explicitly requests an output file.

Generated indexes are views, not permanent documents. Do not register them in
`all-todays` or assign permanent-document metadata.
