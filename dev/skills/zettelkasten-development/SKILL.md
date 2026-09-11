---
name: "zettelkasten-development"
description: "Implement a scoped Zettelkasten-CLI source change with OpenSpec traceability and regression verification."
---

# Zettelkasten Development

## Workspace resolution

Resolve the repository exactly as defined in `references/zettelkasten-development-contract-v1.md`. Require `AGENTS.MD`, `openspec/config.yaml`, and `scripts/docs/requirements.adoc`; otherwise report `NOT_FOUND`.

## Contract loading

Before acting:

1. load `references/zettelkasten-development-contract-v1.md`;
2. load `references/skill-authorization-policy-v1.md`;
3. read only the OpenSpec capabilities and legacy requirement IDs touched by the requested change;
4. inspect the exact scripts/libs/tests that implement those contracts.

Derived references never override OpenSpec.

## Non-negotiable boundary

- Preserve unrelated local changes.
- Do not mutate user Vault data during ordinary implementation.
- Use Zsh, existing layers, `ZK_HOME`, and current object/link semantics.
- Do not silently convert ROADMAP requirements to implemented behavior.
- Do not expand a local fix into a migration or architecture redesign without contract scope.

## Normative scope

Common: `ARCH-001..019`, `LIB-001..006`, `STYLE-001..008`, `SAFE-001..005`, `CHECK-001..022`, `ROADMAP-001..004`, `DEVAGENT-001..012`.

Authorization: L1 for a bounded patch; L2 for an explicitly requested coordinated behavior/spec change.

## Workflow

1. Resolve repository and inspect Git status without changing it.
2. Identify affected requirement IDs and the implementation path from entrypoint to libraries/object/plugin layers.
3. Classify the work as patch, refactoring, behavior change, migration, or architecture change.
4. If observable behavior or public contract changes, update the OpenSpec change/baseline first; do not implement undocumented behavior.
5. Implement the smallest compatible patch. Preserve stable UUID/link/storage contracts unless the task is an authorized migration.
6. Add or update focused regression tests. Use a temporary `ZK_HOME` for integration behavior.
7. Update `scripts/docs/features.adoc` for newly confirmed behavior and legacy traceability when IDs/statuses changed.
8. Run applicable tests, `dev/scripts/zt-openspec-check.zsh`, `dev/scripts/zt-agent-skills-check.zsh`, `git diff --check`, and `zt-check` where the changed behavior touches Vault semantics.
9. Report changed contracts, files, checks, skipped optional tools, and remaining gaps.

Do not commit, tag, push, publish, or apply a persistent-data migration unless separately authorized.
