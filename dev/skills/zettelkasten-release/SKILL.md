---
name: "zettelkasten-release"
description: "Prepare and publish a Zettelkasten-CLI version through verified dry-run, explicit apply, and separate Git actions."
---

# Zettelkasten Release

## Workspace resolution

Resolve the repository through the common development contract.

## Contract loading

1. load the common development contract;
2. load the authorization policy;
3. load `references/zettelkasten-release-contract-v1.md`;
4. inspect publication, validation, specification and changed-capability requirements.

## Normative scope

Common: `PUB-001..026`, `CHECK-001..022`, `SPEC-001..007`, `SAFE-001..005`, `DEVAGENT-010..012`.

Authorization: L0/L2 for preparation and dry-run; L3 for publication apply, commit, tag or push.

## Workflow

1. Inspect Git status and release scope without changing either.
2. Verify OpenSpec, implementation, tests, Feature List and legacy status are aligned for the intended release.
3. Run repository tests and development checks.
4. Run `scripts/zt-develop-publish-version.zsh --dry-run` with the intended destination configuration.
5. Review exact mirror deletions and copied root artifacts. A successful dry-run is not apply authorization.
6. If explicitly authorized, run the same publication semantics with `--apply`; stop on destination or validation drift.
7. Treat `git add/commit/tag/push` as separate actions. Perform only those explicitly requested.
8. Report release artifacts, checks, publication result and unperformed Git actions.

Never use release preparation to discard unrelated local changes.
