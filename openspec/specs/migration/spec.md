# migration Specification

## Purpose

Определить совместимые, проверяемые и Git-safe migration procedures для документов, путей, Topic semantics и metadata normalization.

## Requirements

### Requirement: MIGR-001 — сначала сохраняется совместимость с текущими документами и workflow

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: сначала сохраняется совместимость с текущими документами и workflow.

#### Scenario: MIGR-001 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-002 — новый механизм добавляется до удаления старого

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: новый механизм добавляется до удаления старого.

#### Scenario: MIGR-002 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-003 — после добавления нового механизма выполняется проверяемая миграция данных

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: после добавления нового механизма выполняется проверяемая миграция данных.

#### Scenario: MIGR-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-004 — старый механизм удаляется только после успешной миграции и проверки

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: старый механизм удаляется только после успешной миграции и проверки.

#### Scenario: MIGR-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-005 — массовое переименование UUID, файлов или ссылок запрещено без плана миграции, резервной копии...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: массовое переименование UUID, файлов или ссылок запрещено без плана миграции, резервной копии и проверки ссылочной целостности.

#### Scenario: MIGR-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-006 — перед изменением семантики Topic или Reduce выполняется аудит активных Topic на согласованнос...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: перед изменением семантики Topic или Reduce выполняется аудит активных Topic на согласованность заголовка, `:description:`, `:doclink:` и `:key-topic:`.

#### Scenario: MIGR-006 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-007 — для каждой Topic, у которой отображаемое название расходится с :key-topic:, явно выбирается о...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: для каждой Topic, у которой отображаемое название расходится с `:key-topic:`, явно выбирается одно из решений: восстановить её как следующую редакцию прежней линии либо выделить новую тематическую линию.

#### Scenario: MIGR-007 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-008 — миграция в новую тематическую линию явно определяет переносимые документы, сохраняет историче...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: миграция в новую тематическую линию явно определяет переносимые документы, сохраняет исторические ссылки и не создаёт новых связей с deprecated Topic.

#### Scenario: MIGR-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: MIGR-009 — нормализация расположения :deprecated

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Миграции`.

Development, migration или runtime process MUST соблюдать следующее правило: нормализация расположения `:deprecated:` выполняется отдельной проверяемой миграцией и не смешивается с изменением содержания документов.

#### Scenario: MIGR-009 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
