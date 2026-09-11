---
name: "zettelkasten-refine"
description: "Выделяет выбранные документы Topic в новую тематическую линию."
---

# zt-refine

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/33bd2ad2-9fcf-11f1-b52c-7b91862f4ed4.adoc` — Навык zt-refine — редакция 2026-08-24.

## Activation

Use only when explicitly extracting selected active documents from one active
Topic into a new thematic line.

## Sources

- `.scripts/zt-refine.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `REFINE-001`–`REFINE-014`

## Procedure

1. Select one active canonical source Topic.
1. Enter a non-empty new thematic key that differs from the source and has no
  active Topic.
1. Explicitly select active Memo, Note, Todo, or Diary with the exact source
  `:key-topic:`.
1. Explicitly choose whether to archive the source Topic. If it is archived,
  every unselected active candidate document is archived with it, while the
  selected documents move to the new thematic line.
1. Review the complete Refine plan and explicitly confirm it.
1. Let Refine stage all changes, rekey selected documents, replace reciprocal
  Topic links, archive the source bundle when requested, add provenance links,
  and register the new Topic in `all-todays`.
1. Verify the result before accepting it.

## Required validation

Verify the new canonical Topic, exact selected-document scope, unchanged
unselected documents when the source remains active, archived unselected
documents when the source is archived, removed old reciprocal links, new
reciprocal links, mutual provenance links, optional source-bundle deprecation,
`all-todays`, Asciidoctor rendering, `.scripts/zt-check.zsh`, and
`git diff --check -- <changed-files>`.

On apply failure or interruption, verify that rollback restored every existing
document and removed the new Topic.
