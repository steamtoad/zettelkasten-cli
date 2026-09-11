---
name: "zettelkasten-memo"
description: "Создаёт Memo в notes/ с ordinary Topic binding и special-workflow overrides."
---

# zt-memo

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a3e62d8-a0c6-11f1-86f3-637b047238e1.adoc` — Навык zt-memo — редакция 2026-08-26.

## Activation

Use when creating a Memo.

## Sources

- `AGENTS.md`
- `.scripts/zt-memo.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DOC-006`, `LINK-002`–`LINK-005`, `FLOW-002`–`FLOW-004`, `AGENT-015`

## Procedure

1. Search active documents for duplicates and strong semantic matches.
2. Determine whether a special workflow in `AGENTS.md` applies before choosing ordinary binding.
3. For an ordinary Memo, select an active Topic when one clearly fits unless the user forbids Topic binding.
4. Treat `.scripts/zt-memo.zsh` as the mechanical behavior reference, not as an unattended deterministic primitive. Execute it only in an appropriate interactive terminal; otherwise reproduce its required filesystem semantics exactly.
5. Create a UUID v1 core document as `notes/UUID.adoc` titled `Memo - <name> от DD-MM-YYYY`.
6. Add required metadata, `:type: memo`, `memo` keyword, and agent metadata.
7. For ordinary Topic binding, inherit exact `:key-topic:` and relevant keywords excluding `topic`, and add reciprocal Memo ↔ Topic links.
8. Apply special workflow overrides. In particular, an OpenClaw Memo must not receive `:key-topic:` or a Topic link and may link only to closely related active Memo.
9. Add justified reciprocal Memo links and register the Memo in `all-todays`.

## Required validation

Verify UUID v1, metadata, applicable special workflow, requested binding, reciprocal links, duplicate links, `all-todays`, Asciidoctor rendering, `.scripts/zt-check.zsh`, and `git diff --check -- <changed-files>`.
