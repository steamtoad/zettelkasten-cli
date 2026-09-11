---
name: "zettelkasten-keytopic"
description: "Создаёт Topic как notes/UUID.adoc с metadata, связями и all-todays."
---

# zt-keytopic

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/84066bb2-a0c8-11f1-8b69-43764282ec04.adoc` — Навык zt-keytopic — редакция 2026-08-26.

## Activation

Use when creating a new Topic.

## Sources

- `.scripts/zt-keytopic.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DOC-005`, `DOC-006`, `FLOW-002`–`FLOW-004`

## Procedure

1. Search active Topic documents for duplicates and semantic overlap.
1. Create a UUID v1 core document as `notes/UUID.adoc` titled `<name> - ключевая тема`.
1. Add required metadata, `:type: topic`, `topic` keyword, and
  `:key-topic: <name>`.
1. Add agent-specific metadata.
1. Add only strong, justified reciprocal relationships.
1. Register the Topic in `all-todays`.

## Required validation

Verify UUID v1, metadata, exact `:key-topic:`, reciprocal links, `all-todays`,
Asciidoctor rendering, `.scripts/zt-check.zsh`, and
`git diff --check -- <changed-files>`.
