---
name: "zettelkasten-scripts-review"
description: "Собирает scripts и libraries Zettelkasten для read-only аудита."
---

# zt-scripts-review

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/bee03a34-62c4-11f1-ac62-17fe6cf6c401.adoc` — Навык zt-scripts-review — редакция 2026-06-08.

## Activation

Use to collect all CLI scripts and libraries for review without changing them.

## Sources

- `.scripts/zt-scripts-review.zsh`
- requirements `CHECK-007`, `LIB-004`

## Procedure

1. Run `.scripts/zt-scripts-review.zsh`.
1. Review each `.scripts/*.zsh` and `.scripts/lib/*.zsh` section.
1. Compare behavior with requirements and feature list.
1. Separate confirmed behavior, defects, risks, and roadmap proposals.
1. Do not modify scripts unless the user requests implementation.

The operation is read-only.
