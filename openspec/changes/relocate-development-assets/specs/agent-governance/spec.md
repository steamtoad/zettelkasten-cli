## MODIFIED Requirements

### Requirement: AGENT-001 — operational инструкции агентов организованы вокруг обязательной точки входа AGENTS.MD, управляемых skill и canonical repository layout

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: operational инструкции агентов организованы вокруг обязательной точки входа `AGENTS.MD`, управляемых OpenClaw-навыков `zettelkasten-*`, OpenSpec normative baseline, фактического поведения в `scripts/` и legacy traceability в `scripts/docs/requirements.adoc`.

#### Scenario: Canonical agent sources are discoverable

- **WHEN** development agent resolves the repository
- **THEN** it finds executable truth under `scripts/`, legacy traceability under `scripts/docs/requirements.adoc`, and repo-local development skills under `dev/skills/`

### Requirement: AGENT-003 — каждый top-level скрипт scripts/zt-*.zsh имеет ровно один соответствующий управляемый навык

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: каждый top-level скрипт `scripts/zt-*.zsh` имеет ровно один соответствующий управляемый навык `zettelkasten-*`.

#### Scenario: Script-to-skill mapping survives relocation

- **WHEN** skills review scans the repository
- **THEN** it resolves top-level scripts from `scripts/` and validates the existing one-to-one managed mapping

### Requirement: AGENT-006 — агент читает только навыки, относящиеся к текущей задаче

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: агент читает только навыки, относящиеся к текущей задаче; маршрутизация `zt-*` → `zettelkasten-*` задаётся в `AGENTS.MD` и runtime-каталоге skills, а repo-local development procedures находятся в `dev/skills/`.

#### Scenario: Relevant repo-local skill is selected

- **WHEN** development work is routed
- **THEN** only the relevant `dev/skills/zettelkasten-*` procedure is loaded

#### Scenario: AGENT-006 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-012 — Git-версионируемый scripts/docs/managed-skills.adoc является integration contract

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Git-версионируемый `scripts/docs/managed-skills.adoc` является integration contract между checkout Zettelkasten и внешним OpenClaw state: он фиксирует имя skill, класс, mapping на script, Detailed Note и SHA-256 активного `SKILL.md`.

#### Scenario: Manifest remains valid after path migration

- **WHEN** skills review validates the manifest after migration
- **THEN** script mappings resolve under `scripts/`, while managed skill files remain resolved from the external runtime layer
