---
name: "zettelkasten-workspace-create"
description: "Создаёт новый безопасный Workspace в workspaces/."
---

# zt-workspace-create

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4ccc2d38-6759-11f1-9540-9f2f4694fb3d.adoc` — Навык zt-workspace-create — редакция 2026-06-13.

## Activation

Use when explicitly creating a new manually editable Workspace.

## Sources

- `.scripts/zt-workspace-create.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/workspace.zsh`
- requirements `WORKSPACE-001`–`WORKSPACE-009`, `WORKSPACE-014`

## Procedure

1. Enter a non-empty semantic Workspace title without path separators.
1. Verify that the generated `workspaces/<name>.adoc` path remains inside
  `workspaces/`.
1. Do not overwrite an existing Workspace.
1. Verify that the new file contains its title and the `Документы` section.

## Required validation

Verify the resulting path, unchanged existing files, Asciidoctor rendering and
`git diff --check -- <changed-files>`.
