# uuid Specification

## Purpose

Зафиксировать UUID v1 identity contract для постоянных документов и platform-specific generation behavior.

## Requirements

### Requirement: UUID-001 — система использует UUID v1 / time-based UUID

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `UUID`.

Zettelkasten-CLI MUST сохранять следующий инвариант: система использует UUID v1 / time-based UUID. Хронологическая сортировка допустима как полезное свойство, но строгая монотонность UUID не гарантируется.

#### Scenario: UUID-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: UUID-002 — на Linux UUID генерируется командой uuidgen -t

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `UUID`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: на Linux UUID генерируется командой `uuidgen -t`.

#### Scenario: UUID-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: UUID-003 — на macOS UUID генерируется командой uuid, а не неподдерживаемым вариантом uuidgen -t

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `UUID`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: на macOS UUID генерируется командой `uuid`, а не неподдерживаемым вариантом `uuidgen -t`.

#### Scenario: UUID-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: UUID-004 — механизм генерации UUID нельзя заменять вариантом без поддержки UUID v1 без отдельной миграции

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `UUID`.

Zettelkasten-CLI MUST сохранять следующий инвариант: механизм генерации UUID нельзя заменять вариантом без поддержки UUID v1 без отдельной миграции.

#### Scenario: UUID-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: UUID-005 — UUID одновременно является идентификатором документа, именем файла и целью внутренних ссылок

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `UUID`.

Zettelkasten-CLI MUST сохранять следующий инвариант: UUID одновременно является идентификатором документа, именем файла и целью внутренних ссылок.

#### Scenario: UUID-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: UUID-006 — существующие UUID и ссылки нельзя переименовывать без процедуры миграции

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `UUID`.

Zettelkasten-CLI MUST сохранять следующий инвариант: существующие UUID и ссылки нельзя переименовывать без процедуры миграции.

#### Scenario: UUID-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
