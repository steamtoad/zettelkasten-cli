---
name: "zettelkasten-delta-spec"
description: "Use for «добавь дельтаспек в Zettelkasten» or «добавь дельтаспек в Цеттелькастен»."
---

# Zettelkasten Delta Spec

Use when the user says «добавь дельтаспек в Zettelkasten», «добавь дельтаспек в Цеттелькастен» or asks for a Zettelkasten-CLI OpenSpec delta change.

1. Read the complete base skill at `/Users/steamtoad/.openclaw/workspace/skills/openspec-delta-spec/SKILL.md` and follow it.
2. Work only in `/Users/steamtoad/dev/zettelkasten-cli`.
3. Read repository instructions, `openspec/config.yaml` and the complete repo-local `skills/zettelkasten-openspec-change/SKILL.md`; then load affected baseline specs, implementation, tests, Feature List and matching legacy IDs.
4. Preserve canonical Zettelkasten ownership and stable traceability. Keep ROADMAP status distinct from verified implementation status.
5. Classify normative changes under the repository authorization policy; do not expand into data migration or destructive mutation merely because the delta describes it.
6. Declare the project test naming context as `tests_dir=tests`, `test_prefix=zt-`, `test_extension=.zsh`. For example, `fix-runtime-layout` requires primary test `tests/zt-runtime-layout.zsh`.
7. Create the change under that repository's `openspec/changes/<change-name>/`; do not implement or archive it without a separate explicit request.
8. Validate with `openspec validate <change-name> --strict`, `openspec validate --all` when broad, `.scripts/dev/zt-openspec-check.zsh`, and `git diff --check`.
9. Report affected stable IDs, compatibility/migration/destructive-operation impact and validation status.
