# Zettelkasten Release Operational Contract v1

This reference supplements the common development contract for releases.

## Release protocol

1. Verify OpenSpec/implementation/Feature List alignment for the release scope.
2. Run relevant tests and static development checks.
3. Run `zt-develop-publish-version.zsh --dry-run` against the intended destination.
4. Review additions, changes and deletions; do not infer approval from a clean dry-run.
5. `--apply` requires explicit L3 publication authorization.
6. Commit, tag and push are separate Git mutations and require explicit request.
7. Never use publication to clean unrelated local changes or repair a dirty tree.
