# Zettelkasten Development Operational Contract v1

This is a derived operational reference. Normative authority remains
`AGENTS.MD` and `openspec/specs/*/spec.md`. Legacy requirements provide stable-ID
and status traceability. If these sources conflict, stop scope expansion and
report the conflict.

## Repository resolution

1. Use explicit configured `ZK_DEV_HOME`/repository root when present.
2. Otherwise use the current Git root only when it contains `AGENTS.MD`,
   `openspec/config.yaml`, and `.scripts/docs/requirements.adoc`.
3. Otherwise report `NOT_FOUND`.
4. Never infer a repository from a hard-coded home path.
5. Invoke repository scripts by exact path under the resolved root.

## Development boundary

- OpenSpec is normative truth; `.scripts/` is executable truth.
- Preserve unrelated local changes and never use destructive Git reset.
- Ordinary development does not mutate `notes/`, `all-todays/`, `workspaces/`,
  `inbox/`, `.last-diary`, or `.state/`.
- Integration tests use a temporary `ZK_HOME` unless the operation is explicitly
  read-only on the current checkout.
- Do not claim ROADMAP behavior as implemented without code, verification,
  Feature List, and legacy status alignment.
- Do not introduce a database, web service, or heavyweight dependency as a
  silent replacement for the shell workflow.
- New shell implementation is Zsh and follows project header, quoting,
  portability, executable and path rules.

## Change protocol

1. Identify affected OpenSpec capabilities and legacy requirement IDs.
2. Classify the task as patch, refactoring, behavior/migration, or architecture.
3. For behavior or contract change, update OpenSpec change/baseline before
   broadening implementation.
4. Implement the smallest compatible change.
5. Add or update verification for the changed behavior.
6. Update descriptive/legacy documentation when required by traceability.
7. Run the widest applicable verification and report skipped optional tools.

## Result matrix

- `OK`: required checks passed.
- `SKIP`: optional tool or live environment intentionally unavailable.
- `NOT_FOUND`: required repository marker/executable/input is unavailable; stop.
- `SPEC_CONFLICT`: specification/procedure/implementation disagree; stop scope expansion.
- `STATE_CONFLICT`: migration/release preconditions changed; obtain a fresh plan.
- `VALIDATION_FAILED`: required invariant or regression check failed; do not publish/apply.

## Validation

Validate the widest changed scope. A successful local unit check does not replace
repository, migration, lifecycle, or OpenSpec checks when those contracts changed.
