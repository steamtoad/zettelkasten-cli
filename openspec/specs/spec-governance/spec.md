# spec-governance Specification

## Purpose

Определить authority, traceability и lifecycle нормативных требований Zettelkasten-CLI между OpenSpec baseline, legacy stable IDs, implementation и Feature List.

## Requirements

### Requirement: SPEC-001 — нормативным baseline требований является openspec/specs/*/spec.md

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Zettelkasten-CLI MUST сохранять следующий инвариант: нормативным baseline требований является `openspec/specs/*/spec.md`; статус `IMPLEMENTED` в legacy traceability подтверждается фактическим поведением разработанных функций.

#### Scenario: SPEC-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: SPEC-002 — перед назначением статуса IMPLEMENTED требование проверяется по коду и подходящему сценарию п...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Development, migration или runtime process MUST соблюдать следующее правило: перед назначением статуса `IMPLEMENTED` требование проверяется по коду и подходящему сценарию проверки, тесту или dry-run.

#### Scenario: SPEC-002 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: SPEC-003 — при добавлении, изменении или удалении реализованной функции одновременно обновляется .script...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Development, migration или runtime process MUST соблюдать следующее правило: при добавлении, изменении или удалении реализованной функции одновременно обновляется `scripts/docs/features.adoc`.

#### Scenario: SPEC-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: SPEC-004 — новая редакция требований не удаляет действующие требования к реализованным функциям без явно...

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Zettelkasten-CLI MUST сохранять следующий инвариант: новая редакция требований не удаляет действующие требования к реализованным функциям без явного решения, миграции или перевода функции в deprecated.

#### Scenario: SPEC-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: SPEC-005 — будущие обязательные свойства получают статус ROADMAP до появления подтверждённой реализации

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Development, migration или runtime process MUST соблюдать следующее правило: будущие обязательные свойства получают статус `ROADMAP` до появления подтверждённой реализации.

#### Scenario: SPEC-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: SPEC-006 — требования и Feature List не должны утверждать наличие отсутствующей реализации

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Zettelkasten-CLI MUST сохранять следующий инвариант: требования и Feature List не должны утверждать наличие отсутствующей реализации.

#### Scenario: SPEC-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: SPEC-007 — этот файл сохраняет непрерывную legacy traceability host CLI и прежние стабильные ID

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Управление спецификацией`.

Zettelkasten-CLI MUST сохранять следующий инвариант: этот файл сохраняет непрерывную legacy traceability host CLI и прежние стабильные ID; Zettelkasten plugin дополняется отдельными `ZP-*` требованиями в `scripts/zettelkasten/docs/requirements.adoc`, не переиспользуя существующие ID; каждый действующий legacy ID должен иметь соответствующее OpenSpec requirement.

#### Scenario: SPEC-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
