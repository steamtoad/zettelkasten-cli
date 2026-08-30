---
name: "zettelkasten-migration"
description: "Plan and apply explicit Zettelkasten-CLI data or layout migrations with dry-run, Git preflight, and integrity checks."
---

# Zettelkasten Migration

## Workspace resolution

Resolve the repository through the common development contract.

## Contract loading

1. load the common development contract;
2. load the authorization policy;
3. load `references/zettelkasten-migration-contract-v1.md`;
4. read every OpenSpec capability that defines the source and target storage semantics.

## Normative scope

Common: `MIGR-001..009`, `SAFE-001..005`, `PATH-001..011`, `UUID-001..006`, `LINK-001..007`, `DEPR-001..011`, `TOPIC-001..005`, `CHECK-001..022`.

Authorization: L0 for audit/dry-run planning; L3 for apply.

## Safety rule

Never apply a migration based only on an old plan or on the fact that the user requested a broad redesign. The apply scope must match a fresh plan and current Git/data preconditions.

## Workflow

1. Identify exact source state, target state, affected paths/documents and invariants that cannot change.
2. Inspect current Git/worktree state and migration-specific prerequisites.
3. Run or construct the canonical dry-run/plan; enumerate every file/link/metadata class that would change.
4. Verify collision, UUID, link, deprecated, Topic and Diary/Workspace implications relevant to the migration.
5. Obtain explicit L3 apply authorization for the displayed scope when apply is requested.
6. Apply only the migration; do not bundle unrelated cleanup/refactoring.
7. Run `zt-check`, link/metadata-specific verification and `git diff --check` immediately after apply.
8. If verification fails, stop and follow the documented recovery/rollback strategy; do not improvise destructive Git recovery.
9. Report changed objects, preserved identities, verification and any manual follow-up.
