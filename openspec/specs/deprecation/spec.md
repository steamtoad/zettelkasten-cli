# deprecation Specification

## Purpose

Определить canonical deprecated semantics, immutability/visibility rules и lifecycle interactions.

## Requirements

### Requirement: DEPR-001 — наличие атрибута :deprecated

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: наличие атрибута `:deprecated:` помечает архивный документ.

#### Scenario: DEPR-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DEPR-002 — zt-find, zt-read, zt-edit и zt-getlink исключают deprecated-документы из обычной выдачи

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-find`, `zt-read`, `zt-edit` и `zt-getlink` исключают deprecated-документы из обычной выдачи.

#### Scenario: DEPR-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DEPR-003 — новые индексаторы и селекторы обязаны явно определять политику обработки deprecated-документов

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Development, migration или runtime process MUST соблюдать следующее правило: новые индексаторы и селекторы обязаны явно определять политику обработки deprecated-документов.

#### Scenario: DEPR-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: DEPR-004 — Reduce архивирует выбранную исходную Topic и активные Memo с точным совпадением :key-topic:

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Reduce архивирует выбранную исходную Topic и активные Memo с точным совпадением `:key-topic:`.

#### Scenario: DEPR-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DEPR-005 — Reduce никогда автоматически не архивирует Note

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Reduce никогда автоматически не архивирует Note.

#### Scenario: DEPR-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEPR-006 — deprecated Note не перепривязываются к новой Topic при Reduce

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Zettelkasten-CLI MUST сохранять следующий инвариант: deprecated Note не перепривязываются к новой Topic при Reduce.

#### Scenario: DEPR-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEPR-007 — при последовательном Reduce одной линии предыдущая Topic архивируется, а новая Topic остаётся...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: при последовательном Reduce одной линии предыдущая Topic архивируется, а новая Topic остаётся активной.

#### Scenario: DEPR-007 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DEPR-008 — Reduce не обязан и не должен неявно обеспечивать глобальную уникальность активной Topic по зн...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Reduce не обязан и не должен неявно обеспечивать глобальную уникальность активной Topic по значению `:key-topic:`.

#### Scenario: DEPR-008 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DEPR-009 — при добавлении :deprecated

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: при добавлении `:deprecated:` атрибут записывается последним атрибутом заголовка документа, непосредственно перед первой пустой строкой.

#### Scenario: DEPR-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DEPR-010 — операция архивирования изменяет только заголовок AsciiDoc и никогда не добавляет :deprecated

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: операция архивирования изменяет только заголовок AsciiDoc и никогда не добавляет `:deprecated:` в тело документа или в конец файла.

#### Scenario: DEPR-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DEPR-011 — если границы заголовка нельзя определить однозначно, операция архивирования завершается ошибк...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Deprecated`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: если границы заголовка нельзя определить однозначно, операция архивирования завершается ошибкой без изменения документа.

#### Scenario: DEPR-011 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
