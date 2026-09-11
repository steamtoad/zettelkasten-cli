---
name: "zettelkasten-reduce"
description: "Создаёт следующее поколение Topic и архивирует точный Reduce scope."
---

# zt-reduce

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/16a8604e-673d-11f1-bdee-bf66a33fc06b.adoc` — Навык zt-reduce — редакция 2026-06-13.

## Activation

Use only when explicitly reducing an active Topic into a successor generation.

## Sources

- `.scripts/zt-reduce.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `DEPR-004`–`DEPR-011`, `REDUCE-001`–`REDUCE-019`

## Procedure

1. Select one active Topic and verify its exact non-empty `:key-topic:` and
  canonical title, `:description:`, `:doclink:` and `:docfilename:`.
1. Treat only header attributes as Reduce metadata; ignore attribute-like body
  lines.
1. Select Full Copy or Clean Successor mode.
1. Verify the header boundary of every document that will become deprecated.
1. Review the complete Reduce plan and explicitly confirm it.
1. Create the canonical successor Topic with UUID v1 and the same exact
  `:key-topic:`.
1. Link old and new Topic as `Развитие` and `Основано на`.
1. Link active Note with the same `:key-topic:` to the new Topic without
  deprecating them.
1. Mark only the old Topic and active Memo with exact matching `:key-topic:` as
  deprecated.
1. Register the new Topic in `all-todays`.

## Required validation

Audit the complete changed-file scope before and after Reduce. Verify UUID v1,
successor metadata, Topic-generation links, deprecated scope, unchanged Note,
literal body preservation for Full Copy, `all-todays`, Asciidoctor rendering
of changed documents, `.scripts/zt-check.zsh`, and
`git diff --check -- <changed-files>`.

Do not perform Reduce when the intended scope is uncertain.
Use a separate migration or refinement operation when the intended result is a
new thematic line rather than the next revision of the selected Topic.
