---
name: "zettelkasten-getlink"
description: "Возвращает notes-relative ссылку на активный core document."
---

# zt-getlink

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/8405fa06-a0c8-11f1-8744-1f2cea904d3e.adoc` — Навык zt-getlink — редакция 2026-08-26.

## Activation

Use when the user needs a notes-relative AsciiDoc link to an existing core document.

## Sources

- `.scripts/lib/paths.zsh`
- `.scripts/zt-getlink.zsh`
- `.scripts/lib/asciidoc.zsh`
- requirements `LINK-001`, `DEPR-002`, `FZF-002`

## Procedure

1. Exclude deprecated documents.
1. Select the active document by `:description:`.
1. Return `link:UUID.adoc[Description]`, suitable for links between documents inside `notes/`.
1. Do not edit either source or target document unless the user requests a
  relationship change.

Cancellation produces no output and changes nothing.
