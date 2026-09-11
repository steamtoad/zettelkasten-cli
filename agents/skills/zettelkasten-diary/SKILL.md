---
name: "zettelkasten-diary"
description: "Создаёт Diary в notes/ и безопасно обновляет двустороннюю Diary chain."
---

# zt-diary

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/8404bf38-a0c8-11f1-a213-eb4e7ed49b2c.adoc` — Навык zt-diary — редакция 2026-08-26.

## Activation

Use when creating a Diary entry.

## Sources

- `.scripts/zt-diary.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DATA-003`, `FLOW-002`–`FLOW-004`

## Procedure

1. Read `.last-diary` and verify that its target exists when non-empty.
1. Create a UUID v1 core document as `notes/UUID.adoc` titled `Diary - DD-MM-YYYY`.
1. Add required metadata and agent-specific metadata.
1. Add a link to the previous Diary when it exists.
1. Add a reciprocal `Следующая запись` link to the previous Diary.
1. Update `.last-diary`.
1. Register the new Diary in `all-todays`.

## Required validation

Verify both Diary-chain directions, `.last-diary`, UUID v1, Asciidoctor
rendering of both changed Diary files, `.scripts/zt-check.zsh`, and
`git diff --check -- <changed-files>`.

Do not leave a partially updated Diary chain.
