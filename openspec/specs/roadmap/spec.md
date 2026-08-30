# roadmap Specification

## Purpose

Определить правила развития будущих mechanisms без преждевременного объявления их реализованными.

## Requirements

### Requirement: ROADMAP-001 — новые механизмы проектируются так, чтобы позднее их можно было встроить в zcreate

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Развитие проекта`.

Целевая архитектура или поведение MUST сохранять следующий target contract: новые механизмы проектируются так, чтобы позднее их можно было встроить в `zcreate`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ROADMAP-001 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ROADMAP-002 — каждое изменение оценивается по пользе сейчас, совместимости с текущим workflow и пользе для...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Развитие проекта`.

Development, migration или runtime process MUST соблюдать следующее правило: каждое изменение оценивается по пользе сейчас, совместимости с текущим workflow и пользе для будущей архитектуры.

#### Scenario: ROADMAP-002 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: ROADMAP-003 — новые типы документов и команды сначала получают формальное описание модели данных и поведения

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Развитие проекта`.

Development, migration или runtime process MUST соблюдать следующее правило: новые типы документов и команды сначала получают формальное описание модели данных и поведения.

#### Scenario: ROADMAP-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: ROADMAP-004 — отдельные функции Inbox, SQLite и zcreate получают статус IMPLEMENTED только после подтвержде...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Развитие проекта`.

Development, migration или runtime process MUST соблюдать следующее правило: отдельные функции Inbox, SQLite и `zcreate` получают статус `IMPLEMENTED` только после подтверждения кода, тестов и обновления Feature List; наличие raw/processed staging не означает реализацию импорта Inbox в постоянные документы.

#### Scenario: ROADMAP-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
