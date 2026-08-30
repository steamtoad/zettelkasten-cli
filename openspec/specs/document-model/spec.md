# document-model Specification

## Purpose

Определить canonical AsciiDoc document model, обязательные metadata и различие persistent knowledge objects и generated views.

## Requirements

### Requirement: DOC-001 — постоянные документы Zettelkasten хранятся в формате AsciiDoc

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Zettelkasten-CLI MUST сохранять следующий инвариант: постоянные документы Zettelkasten хранятся в формате AsciiDoc.

#### Scenario: DOC-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DOC-002 — постоянный документ содержит атрибуты :date:, :type:, :keywords:, :author:, :description:, :d...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Zettelkasten-CLI MUST сохранять следующий инвариант: постоянный документ содержит атрибуты `:date:`, `:type:`, `:keywords:`, `:author:`, `:description:`, `:doclink:` и `:docfilename:`.

#### Scenario: DOC-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DOC-003 — доменные типы постоянных документов

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: доменные типы постоянных документов: `note`, `memo`, `todo`, `diary`, `topic`.

#### Scenario: DOC-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DOC-004 — генерируемые представления могут использовать типы list и index

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: генерируемые представления могут использовать типы `list` и `index`; они не являются доменными типами заметок.

#### Scenario: DOC-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DOC-005 — Topic является полноценным типом документа

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Topic является полноценным типом документа.

#### Scenario: DOC-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DOC-006 — :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `:key-topic:` является действующим ключом тематической группировки и связи документов; он также сохраняет обратную совместимость.

#### Scenario: DOC-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DOC-007 — :type

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `:type:` является каноническим источником типа документа. Вывод типа из `:keywords:` допустим только как временный механизм совместимости и миграции.

#### Scenario: DOC-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DOC-008 — значение :type

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Development, migration или runtime process MUST соблюдать следующее правило: значение `:type:` должно присутствовать в `:keywords:`; `zt-check` может сообщать об отсутствии как о рекомендации до введения строгой проверки.

#### Scenario: DOC-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DOC-009 — первая пустая строка после document title или атрибутов завершает AsciiDoc header

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Формат документов и модель данных`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: первая пустая строка после document title или атрибутов завершает AsciiDoc header; атрибутоподобные строки после неё являются body и не влияют на metadata semantics.

#### Scenario: DOC-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
