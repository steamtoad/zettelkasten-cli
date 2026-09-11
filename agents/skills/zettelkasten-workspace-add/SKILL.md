---
name: "zettelkasten-workspace-add"
description: "Добавляет активные core documents в Workspace через ../notes/UUID.adoc."
---

# zt-workspace-add

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/8407ad42-a0c8-11f1-8ac5-b3894660bac6.adoc` — Навык zt-workspace-add — редакция 2026-08-26.

## Activation

Use when explicitly adding active permanent documents to an existing Workspace.

## Sources

- `.scripts/zt-workspace-add.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/asciidoc.zsh`
- `.scripts/lib/workspace.zsh`
- requirements `WORKSPACE-001`–`WORKSPACE-014`

## Procedure

1. Select an existing Workspace.
1. Select one or more active Note, Memo, Todo, Diary, or Topic documents.
1. Add each document as `link:../notes/UUID.adoc[...]` under `Документы`.
1. Treat an already present target as a successful idempotent no-op.

## Required validation

Verify relative links, absence of duplicates, exclusion of deprecated documents,
unchanged target documents, Asciidoctor rendering and
`git diff --check -- <changed-files>`.
