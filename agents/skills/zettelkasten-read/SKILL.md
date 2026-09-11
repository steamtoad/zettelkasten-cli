---
name: "zettelkasten-read"
description: "Формирует объединённое представление активных notes/*.adoc по запросу."
---

# zt-read

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/8406dcc8-a0c8-11f1-ac90-7b35407f036c.adoc` — Навык zt-read — редакция 2026-08-26.

## Activation

Use to generate a combined AsciiDoc listing of active documents matching a
case-insensitive text query.

## Sources

- `.scripts/lib/paths.zsh`
- `.scripts/zt-read.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DOC-004`, `DEPR-002`

## Procedure

1. Require a non-empty search expression.
1. Search active `notes/*.adoc` documents and exclude deprecated documents.
1. Emit a header with `:type: list`.
1. Concatenate matching documents to stdout in repository order.
1. Redirect to a file only when explicitly requested.

The output is a generated view, not a permanent document. Do not register it in
`all-todays`.
