# development-agent Specification

## Purpose

Определить repo-local development agent Marta, development skill boundaries, authorization, OpenSpec workflow и validation tooling.

## Requirements

### Requirement: DEVAGENT-001 — Marta является специализированным агентом разработки zettelkasten-cli

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Marta является специализированным агентом разработки `zettelkasten-cli`; runtime knowledge-management операции и изменение пользовательского Vault не входят в её обычный development scope.

#### Scenario: DEVAGENT-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEVAGENT-002 — точка входа агента разработки — AGENTS.MD

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Zettelkasten-CLI MUST сохранять следующий инвариант: точка входа агента разработки — `AGENTS.MD`; repo-local development skills находятся в `dev/skills/zettelkasten-*` и не заменяют существующие внешние managed operational skills, привязанные к top-level `zt-*.zsh`.

#### Scenario: DEVAGENT-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEVAGENT-003 — каждый development skill перед действием разрешает корень репозитория, загружает общий operat...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: каждый development skill перед действием разрешает корень репозитория, загружает общий operational contract, authorization policy и только релевантный OpenSpec scope.

#### Scenario: DEVAGENT-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-004 — OpenSpec является normative truth, scripts/ — executable truth, development skills — procedu...

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Zettelkasten-CLI MUST сохранять следующий инвариант: OpenSpec является normative truth, `scripts/` — executable truth, development skills — procedural truth, legacy requirements — traceability truth, Feature List — descriptive truth; расхождение между слоями явно диагностируется и не маскируется fallback-поведением агента.

#### Scenario: DEVAGENT-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEVAGENT-005 — поведенческое изменение сначала оформляется как OpenSpec change или как явное обновление base...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: поведенческое изменение сначала оформляется как OpenSpec change или как явное обновление baseline, после чего реализуется минимальный совместимый patch и соответствующие проверки.

#### Scenario: DEVAGENT-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-006 — read-only review skill не изменяет repository, пользовательские документы, Git index или exte...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: read-only review skill не изменяет repository, пользовательские документы, Git index или external managed skill state.

#### Scenario: DEVAGENT-006 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-007 — development agent не использует destructive Git reset, checkout поверх локальных изменений ил...

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Zettelkasten-CLI MUST сохранять следующий инвариант: development agent не использует destructive Git reset, checkout поверх локальных изменений или иные операции, уничтожающие несвязанные изменения пользователя.

#### Scenario: DEVAGENT-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEVAGENT-008 — интеграционные проверки development agent выполняются на временном Zettelkasten через ZK_HOME...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: интеграционные проверки development agent выполняются на временном Zettelkasten через `ZK_HOME`, если тест прямо не является read-only проверкой текущего checkout.

#### Scenario: DEVAGENT-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-009 — сложная migration или массовая mutation требует отдельного dry-run/plan, проверки Git precond...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: сложная migration или массовая mutation требует отдельного dry-run/plan, проверки Git preconditions, явного scope и проверки целостности после применения.

#### Scenario: DEVAGENT-009 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-010 — release workflow сначала выполняет dry-run публикации и verification

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: release workflow сначала выполняет dry-run публикации и verification; apply, commit, tag и push не считаются подразумеваемыми одним фактом подготовки release.

#### Scenario: DEVAGENT-010 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-011 — dev/scripts/zt-agent-skills-check.zsh проверяет packaging development skills, canonical refe...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: `dev/scripts/zt-agent-skills-check.zsh` проверяет packaging development skills, canonical references, authorization levels и корректность OpenSpec requirement references.

#### Scenario: DEVAGENT-011 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEVAGENT-012 — OpenSpec checker сохраняет ID, status и Scenario traceability

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агент разработки и repo-local development skills`.

Development, migration или runtime process MUST соблюдать следующее правило: `dev/scripts/zt-openspec-check.zsh` проверяет, что все действующие legacy requirement ID host CLI и Zettelkasten plugin покрыты OpenSpec baseline ровно один раз, сохраняют legacy status и имеют проверяемый Scenario.

#### Scenario: Legacy status drift is rejected

- **GIVEN** legacy requirement и соответствующий OpenSpec requirement имеют разные status
- **WHEN** `dev/scripts/zt-openspec-check.zsh` проверяет baseline
- **THEN** checker SHALL завершиться ненулевым кодом
- **AND** diagnostic SHALL назвать requirement ID и оба status
