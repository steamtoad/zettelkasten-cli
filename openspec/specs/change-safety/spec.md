# change-safety Specification

## Purpose

Определить preflight, scope isolation, rollback/dry-run roadmap и preference for minimal compatible changes.

## Requirements

### Requirement: SAFE-001 — изменяющая данные операция выполняет доступные предварительные проверки до первой записи

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Безопасность изменений`.

Development, migration или runtime process MUST соблюдать следующее правило: изменяющая данные операция выполняет доступные предварительные проверки до первой записи.

#### Scenario: SAFE-001 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: SAFE-002 — прерванная операция не должна оставлять частично созданные документы, связи или deprecated-метки

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Безопасность изменений`.

Целевая архитектура или поведение MUST сохранять следующий target contract: прерванная операция не должна оставлять частично созданные документы, связи или deprecated-метки; для сложных операций требуется rollback или описанная процедура восстановления.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: SAFE-002 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: SAFE-003 — разрушительные и массовые операции должны поддерживать предварительный просмотр или явное под...

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Безопасность изменений`.

Целевая архитектура или поведение MUST сохранять следующий target contract: разрушительные и массовые операции должны поддерживать предварительный просмотр или явное подтверждение.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: SAFE-003 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: SAFE-004 — операция не изменяет документы, не входящие в явно выбранную область действия

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Безопасность изменений`.

Zettelkasten-CLI MUST сохранять следующий инвариант: операция не изменяет документы, не входящие в явно выбранную область действия.

#### Scenario: SAFE-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: SAFE-005 — локальный совместимый патч предпочтительнее большого рефакторинга без миграционного обоснования

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Безопасность изменений`.

Development, migration или runtime process MUST соблюдать следующее правило: локальный совместимый патч предпочтительнее большого рефакторинга без миграционного обоснования.

#### Scenario: SAFE-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
