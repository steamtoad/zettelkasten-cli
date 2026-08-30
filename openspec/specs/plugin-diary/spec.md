# plugin-diary Specification

## Purpose

Определить Diary creation, last-diary state и bidirectional chain behavior внутри plugin.

## Requirements

### Requirement: ZP-DIARY-001 — Diary создаётся через neutral Diary constructor

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Diary`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Diary создаётся через neutral Diary constructor.

#### Scenario: ZP-DIARY-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-DIARY-002 — .last-diary хранит basename последней записи

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Diary`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.last-diary` хранит basename последней записи.

#### Scenario: ZP-DIARY-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-DIARY-003 — новая и предыдущая записи соединяются двунаправленно

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Diary`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: новая и предыдущая записи соединяются двунаправленно.

#### Scenario: ZP-DIARY-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-DIARY-004 — значение .last-diary с разделителем пути отклоняется

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Diary`.

Zettelkasten-CLI MUST сохранять следующий инвариант: значение `.last-diary` с разделителем пути отклоняется.

#### Scenario: ZP-DIARY-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-DIARY-005 — state обновляется только после успешного создания и связывания

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Diary`.

Zettelkasten-CLI MUST сохранять следующий инвариант: state обновляется только после успешного создания и связывания.

#### Scenario: ZP-DIARY-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
