---
name: "zettelkasten-edit"
description: "Выбирает и редактирует активный core document внутри notes/."
---

# zt-edit

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/84052a54-a0c8-11f1-9bf9-7b57a74a4e70.adoc` — Навык zt-edit — редакция 2026-08-26.

## Activation

Use when selecting an active document by description and editing it.

## Sources

- `.scripts/lib/paths.zsh`
- `.scripts/zt-edit.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DEPR-002`, `FZF-002`, `FZF-005`

## Procedure

1. Operate on active documents in `notes/`.
1. Exclude documents containing `:deprecated:`.
1. Select by `:description:` and retain the UUID filename as the stable identity.
1. Preserve unrelated user content and existing UUID.
1. After any edit, run task-appropriate checks, Asciidoctor rendering,
  `.scripts/zt-check.zsh`, and `git diff --check -- <changed-files>`.

Cancellation must not change any file.
