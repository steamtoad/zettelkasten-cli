---
name: "zettelkasten-validation"
description: "Run and interpret Zettelkasten-CLI repository, OpenSpec, skill, shell, and temporary-Vault validation checks."
---

# Zettelkasten Validation

## Workspace resolution

Resolve the repository through the common development contract.

## Contract loading

Load the common contract, authorization policy, and the OpenSpec requirements for the scope being validated.

## Normative scope

Common: `CHECK-001..022`, `STYLE-001..008`, `SPEC-001..007`, `DEVAGENT-006..012`, `DOC-001..009`, `LINK-001..007`, `DEPR-001..011`.

Authorization: L0 for repository/static checks and read-only validation. Temporary test fixtures may be created outside user data as part of the explicit validation request.

## Workflow

1. Determine the narrowest sufficient validation scope: files, capability, integration workflow, or whole repository.
2. Run `.scripts/dev/zt-openspec-check.zsh` and `.scripts/dev/zt-agent-skills-check.zsh` when their artifacts are in scope.
3. Run relevant regression tests; prefer `tests/zt-all.zsh` for full repository validation.
4. For Vault semantics, create/use a temporary `ZK_HOME` and run `.scripts/zt-check.zsh` there unless the user explicitly requested read-only validation of a real Vault.
5. Run `git diff --check` on changed files. Run `shellcheck`/`asciidoctor`/`openspec validate --all` when available and applicable.
6. Distinguish `FAIL`, `NOT_FOUND`, and optional-tool `SKIP` diagnostics.
7. Group failures by requirement ID and identify the smallest safe next action.

Never add `--fix`, perform migration apply, or modify user documents in this skill.
