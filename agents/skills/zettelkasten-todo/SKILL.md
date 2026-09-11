---
name: "zettelkasten-todo"
description: "Создаёт Todo как notes/UUID.adoc и регистрирует его в all-todays."
---

# zt-todo

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/84074208-a0c8-11f1-afb9-3308f69004ac.adoc` — Навык zt-todo — редакция 2026-08-26.

## Activation

Use when creating a Todo document.

## Sources

- `.scripts/zt-todo.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DOC-003`, `FLOW-002`–`FLOW-004`

## Procedure

1. Search active Todo and related documents for duplicates.
1. Create a UUID v1 core document as `notes/UUID.adoc` titled `TODO - <name> от DD-MM-YYYY`.
1. Add required metadata, `:type: todo`, `todo` keyword, and agent metadata.
1. Add section `== TODO` with the first unchecked task.
1. Register the Todo in `all-todays`.
1. Add relationships only when explicitly useful.

## Required validation

Verify UUID v1, metadata, Todo structure, `all-todays`, Asciidoctor rendering,
`.scripts/zt-check.zsh`, and `git diff --check -- <changed-files>`.
