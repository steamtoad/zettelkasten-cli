---
name: "zettelkasten-check"
description: "Проверяет целостность notes/, ссылок, Workspace и Diary."
---

# zt-check

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/f9ce19e8-a0f6-11f1-b679-0b3a133cc561.adoc` — Навык zt-check — редакция 2026-08-26.

## Activation

Use after changes to `notes/`, document links, metadata, `all-todays`, Workspaces, `.last-diary`, or Diary chain,
and when diagnosing repository integrity.

## Sources

- `.scripts/lib/paths.zsh`
- `.scripts/zt-check.zsh`
- `.scripts/lib/asciidoc.zsh`
- `.scripts/docs/requirements.adoc`, section `Проверки`

## Procedure

1. Run `.scripts/zt-check.zsh` from the repository root.
1. Treat a non-zero exit code or `ERROR` as a failed integrity check.
1. Review `WARN` recommendations separately.
1. Do not let `zt-check` substitute for UUID v1, Asciidoctor rendering,
  reciprocal-link, duplicate-entry, or special-workflow checks.
1. Report unrelated pre-existing errors without silently fixing them.

`zt-check` is read-only and must not modify documents.
