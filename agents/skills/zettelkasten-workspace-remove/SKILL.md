---
name: "zettelkasten-workspace-remove"
description: "Удаляет ../notes/UUID.adoc ссылки из Workspace атомарно."
---

# zt-workspace-remove

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/f9ce5160-a0f6-11f1-a6c0-fb417d1f32d1.adoc` — Навык zt-workspace-remove — редакция 2026-08-26.

## Activation

Use when explicitly removing document links from an existing Workspace.

## Sources

- `.scripts/zt-workspace-remove.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/asciidoc.zsh`
- `.scripts/lib/workspace.zsh`
- requirements `WORKSPACE-001`–`WORKSPACE-014`

## Procedure

1. Select an existing Workspace.
1. Select one or more `../notes/UUID.adoc` document links marked active, deprecated, or broken
  in a single `fzf --multi` session.
1. Remove all selected bullet links outside supported code blocks in one atomic
  Workspace rewrite.

## Required validation

Verify that exactly the selected links were removed, unselected links and links
in code blocks remain, the Workspace file mode is preserved, target documents
remain unchanged, Asciidoctor rendering succeeds and
`git diff --check -- <changed-files>`.
