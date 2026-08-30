# Zettelkasten Development Skill Authorization Policy v1

This is agent UX and safety policy, not a persistent-data Requirement.

## L0 — read-only

No mutation authorization is required. Examples: script review, architecture
review, OpenSpec coverage check, validation and dry-run planning.

## L1 — bounded repository patch

An explicit request to fix or improve a scoped source/docs/test issue authorizes
bounded edits inside that scope after relevant contracts are loaded.

## L2 — coordinated behavior/spec change

A change spanning normative behavior, multiple implementation layers, tests and
documentation requires an explicit user request for that change. The agent may
carry the full coherent change without asking a redundant confirmation for each
file, but must not expand into unrelated migration or release operations.

## L3 — migration, destructive lifecycle or publication

Persistent-data migration, mass mutation, release apply, commit, tag and push
require an explicit operation-specific request. Dry-run/plan does not imply apply.
If the plan materially changes, obtain a fresh explicit authorization.

Authorization never permits weakening an invariant, overwriting unrelated local
changes, or bypassing required verification.
