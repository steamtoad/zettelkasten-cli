# Zettelkasten Migration Operational Contract v1

This reference supplements the common development contract for migrations.

## Exact-scope migration protocol

1. Identify source state, target state, affected paths/documents and stable IDs.
2. Verify compatibility requirements and existing links before mutation.
3. Produce a dry-run/plan that lists every mutation class.
4. Verify Git/worktree preconditions required by the migration.
5. Apply only after L3 authorization for the displayed scope.
6. Never mix unrelated refactoring into the migration transaction.
7. Run `zt-check` and migration-specific link/metadata/lifecycle checks after apply.
8. Preserve or document recovery/rollback material until verification succeeds.

Any scope or precondition drift invalidates the previous plan.
