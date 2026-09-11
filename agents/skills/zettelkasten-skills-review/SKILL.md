---
name: "zettelkasten-skills-review"
description: "Проверяет managed skills по Git-manifest, SHA-256, scripts и Detailed Notes."
---

# zt-skills-review

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a3f3a00-a0c6-11f1-ab31-538925ff1938.adoc` — Навык zt-skills-review — редакция 2026-08-26.

## Activation

Use to validate and audit all active managed OpenClaw skills whose names start with `zettelkasten-`.

## Sources

- `.scripts/zt-skills-review.zsh`
- `.scripts/docs/managed-skills.adoc`
- `AGENTS.md`
- requirements `AGENT-001`–`AGENT-015`
- managed skills root from `ZK_SKILLS_HOME` or `$HOME/.openclaw/workspace/skills`

## Procedure

1. Run `.scripts/zt-skills-review.zsh`.
2. Require exact agreement between manifest entries and runtime `zettelkasten-*/SKILL.md` files.
3. Verify SHA-256, operational/meta class, top-level script mapping, and required active Detailed Note.
4. Review every emitted `SKILL.md` section after mechanical validation.
5. Compare operational procedures with requirements, executable behavior, features, and Detailed references.
6. Report specification/implementation, procedure, documentation, manifest, and trigger-description conflicts separately.
7. Treat `.agent-skills/` only as a read-only historical archive.
8. Create or update durable skills only through Skill Workshop.

The review operation is read-only. Missing roots, incomplete manifests, extra runtime skills, hash drift, broken script mappings, or missing/deprecated required Detailed Notes are errors.
