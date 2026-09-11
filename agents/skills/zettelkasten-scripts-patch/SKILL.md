---
name: "zettelkasten-scripts-patch"
description: "Исправляет только отсутствующий финальный LF в Zsh-скриптах."
---

# zt-scripts-patch

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/43e11350-62c7-11f1-897b-ab5d17afde58.adoc` — Навык zt-scripts-patch — редакция 2026-06-08.2.

## Activation

Use only to repair missing final LF in `.scripts/*.zsh`.

## Sources

- `.scripts/zt-scripts-patch.zsh`
- requirements `CHECK-006`, `STYLE-003`, `STYLE-004`

## Procedure

1. Inspect the script and note that it currently uses a hard-coded
  `$HOME/zettelkasten/.scripts` path.
1. Limit changes strictly to adding missing final LF.
1. Do not mix formatting repair with functional script changes.
1. Run `zsh -n` for changed scripts.
1. Run `.scripts/zt-check.zsh` and `git diff --check -- <changed-files>`.

The script is executable. Run it only when the user requests this maintenance
operation.
