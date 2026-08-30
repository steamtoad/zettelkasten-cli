---
name: "zettelkasten-openspec-change"
description: "Design and maintain Zettelkasten-CLI OpenSpec changes, baseline requirements, and stable legacy traceability."
---

# Zettelkasten OpenSpec Change

## Workspace resolution

Resolve the repository through the common development contract. Never operate on an arbitrary `openspec/` directory without the repository markers.

## Contract loading

1. load the common development contract;
2. load the authorization policy;
3. read `openspec/config.yaml`;
4. inspect affected baseline specs, implementation, tests, Feature List, and matching legacy requirement IDs.

## Normative scope

Common: `SPEC-001..007`, `AGENT-001..015`, `DEVAGENT-001..012`, `MIGR-001..009`, `SAFE-001..005`, `ROADMAP-001..004`.

Authorization: L0 for analysis/draft; L2 when the user explicitly asks to change normative behavior or baseline contracts.

## Workflow

1. State the problem, current behavior, desired behavior and non-goals.
2. Identify affected capabilities and every relevant stable legacy ID.
3. Decide whether the work is a proposal/delta change or a direct baseline synchronization already authorized by the task.
4. Write requirements in observable/verifiable form with MUST/SHALL and at least one Scenario per normative requirement.
5. Mark compatibility, migration, destructive-operation and architecture impact explicitly.
6. Keep ROADMAP status distinct from verified implementation status in legacy traceability.
7. Add design only where architecture, migration, rollback/recovery or rejected alternatives need explanation.
8. Make implementation tasks trace directly to proposal/spec/design.
9. Run `openspec validate --all` when available and always run `.scripts/dev/zt-openspec-check.zsh`.
10. Report any baseline/implementation mismatch instead of silently editing code outside the requested change.

Do not delete or reuse stable legacy requirement IDs.
