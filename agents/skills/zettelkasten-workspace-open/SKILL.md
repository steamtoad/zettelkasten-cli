---
name: "zettelkasten-workspace-open"
description: "Печатает выбранный Workspace без изменения файлов."
---

# zt-workspace-open

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4cccee12-6759-11f1-8781-67f2f996162c.adoc` — Навык zt-workspace-open — редакция 2026-06-13.

## Activation

Use when explicitly printing an existing Workspace for inspection or piping.

## Sources

- `.scripts/zt-workspace-open.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/workspace.zsh`
- requirements `WORKSPACE-001`–`WORKSPACE-008`, `WORKSPACE-011`, `WORKSPACE-014`

## Procedure

1. Verify that at least one Workspace exists.
1. Select one Workspace.
1. Print its complete content to stdout without modifying it.

## Required validation

When behavior is changed, compare stdout byte-for-byte with the selected
Workspace and verify that repository files remain unchanged.
