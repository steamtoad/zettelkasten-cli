---
name: "zettelkasten-note"
description: "Создаёт Note в notes/ и применяет ordinary или special binding rules."
---

# zt-note

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a3ed218-a0c6-11f1-8a62-9300ba1e2f41.adoc` — Навык zt-note — редакция 2026-08-26.

## Activation

Use when creating a developed Note.

## Sources

- `AGENTS.md`
- `.scripts/zt-note.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `LINK-006`–`LINK-012`, `FLOW-002`–`FLOW-006`, `AGENT-015`

## Procedure

1. Search active documents for duplicates and strong semantic matches.
2. Determine whether a special workflow in `AGENTS.md` applies before choosing ordinary binding.
3. Treat `.scripts/zt-note.zsh` as the mechanical behavior reference, not as an unattended deterministic primitive. Execute it only in an appropriate interactive terminal; otherwise reproduce its required filesystem semantics exactly.
4. Create a UUID v1 core document as `notes/UUID.adoc` using the requested or source title.
5. Add required metadata, `:type: note`, `note` keyword, and agent metadata.
6. When explicitly bound to a Memo, inherit its `:key-topic:` and relevant keywords excluding `memo`, and add reciprocal Note ↔ Memo links.
7. Apply special workflow overrides after the script semantics. In particular, an OpenClaw Note must receive `:key-topic: Open Claw`, the required active Topic link, and its reciprocal Topic backlink even though `zt-note.zsh` only offers a Memo selector.
8. Add other justified reciprocal relationships and register the Note in `all-todays`.

## Required validation

Verify UUID v1, metadata, applicable special workflow, requested binding, reciprocal links, duplicate links, `all-todays`, Asciidoctor rendering, `.scripts/zt-check.zsh`, and `git diff --check -- <changed-files>`.
