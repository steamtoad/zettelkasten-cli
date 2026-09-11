## MODIFIED Requirements

### Requirement: DEVAGENT-002 — точка входа агента разработки — AGENTS.MD

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Zettelkasten-CLI MUST сохранять следующий инвариант: точка входа агента разработки — `AGENTS.MD`; repo-local development skills находятся в `dev/skills/zettelkasten-*` и не заменяют существующие внешние managed operational skills, привязанные к top-level `scripts/zt-*.zsh`.

#### Scenario: Development entrypoint and skills are resolved

- **WHEN** Marta starts a repository task
- **THEN** it uses `AGENTS.MD`, executable truth from `scripts/`, and the relevant procedure from `dev/skills/`

#### Scenario: DEVAGENT-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEVAGENT-003 — каждый development skill перед действием разрешает корень репозитория

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development process MUST resolve the repository root only when it contains `AGENTS.MD`, `openspec/config.yaml` and `scripts/docs/requirements.adoc`; otherwise it MUST report `NOT_FOUND`. The process MUST load shared references from the resolved `dev/skills/` tree and invoke repository-local scripts by exact paths below `scripts/`.

#### Scenario: Invalid layout is rejected

- **WHEN** a candidate root lacks `scripts/docs/requirements.adoc`
- **THEN** repository resolution reports `NOT_FOUND` rather than silently using the old `.scripts/` or `skills/` paths

### Requirement: DEVAGENT-004 — OpenSpec является normative truth, scripts/ — executable truth

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Zettelkasten-CLI MUST сохранять следующий инвариант: OpenSpec является normative truth, `scripts/` — executable truth, development skills in `dev/skills/` — procedural truth, legacy requirements — traceability truth, Feature List — descriptive truth; расхождение между слоями явно диагностируется.

#### Scenario: New layout is the declared source of truth

- **WHEN** a check compares documentation, procedures and implementation
- **THEN** it uses `scripts/` and `dev/skills/` as canonical repository paths

### Requirement: DEVAGENT-011 — scripts/dev/zt-agent-skills-check.zsh проверяет packaging development skills

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development process MUST use `scripts/dev/zt-agent-skills-check.zsh` to verify packaging of `dev/skills/`, canonical references, authorization levels and OpenSpec requirement references.

#### Scenario: Skill packaging check uses relocated tree

- **WHEN** the agent skills check runs
- **THEN** it checks `dev/skills/` and fails on stale repository references to `.scripts/` or root `skills/`
