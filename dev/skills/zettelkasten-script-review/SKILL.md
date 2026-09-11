---
name: "zettelkasten-script-review"
description: "Review Zettelkasten-CLI Zsh scripts for correctness, portability, layer violations, and requirement drift."
---

# Zettelkasten Script Review

## Workspace resolution

Resolve the repository through the common development contract.

## Contract loading

Load the common contract, authorization policy, affected OpenSpec capabilities, and the exact script/library dependency chain being reviewed.

## Normative scope

Common: `ARCH-013..019`, `LIB-001..006`, `STYLE-001..008`, `FZF-001..006`, `SAFE-001..005`, `CHECK-001..022`.

Authorization: L0.

## Review model

For each script report separately:

1. purpose and architectural layer;
2. what is already correct;
3. risks: quoting, spaces, empty input/cancel, macOS/Linux, Git, grep/rg/sed/awk, hard-coded paths, fzf, `cut -b`, `:type:`, `:deprecated:` and link semantics;
4. Level 1 minimal safe patch;
5. Level 2 local refactoring;
6. Level 3 system improvement after relevant roadmap primitives exist;
7. place in the future architecture.

## Workflow

1. Read the entrypoint and every sourced local library before judging behavior.
2. Trace user-controlled values and write paths to the first mutation.
3. Compare behavior against exact OpenSpec IDs and legacy implementation status.
4. Check dependency direction and duplicated neutral/plugin-specific logic.
5. Use `rg`/static inspection first; use `shellcheck` when available without treating it as semantic proof.
6. Do not edit files, Git state, external skills or user data.
7. Rank findings by data-loss/compatibility risk and cite the affected requirement IDs.

This skill is strictly read-only.
