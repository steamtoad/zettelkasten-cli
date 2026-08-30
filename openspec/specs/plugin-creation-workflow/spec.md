# plugin-creation-workflow Specification

## Purpose

Определить canonical interactive creation workflows Zettelkasten plugin.

## Requirements

### Requirement: ZP-CREATE-001 — workflow спрашивает непустое название и создаёт объект через соответствующий constructor движка

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Интерактивные workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: workflow спрашивает непустое название и создаёт объект через соответствующий constructor движка.

#### Scenario: ZP-CREATE-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-CREATE-002 — созданный документ регистрируется в дневном all-todays

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Интерактивные workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: созданный документ регистрируется в дневном `all-todays`.

#### Scenario: ZP-CREATE-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-CREATE-003 — после успешного создания документ открывается в Vim и готовая ссылка печатается в stdout

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Интерактивные workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: после успешного создания документ открывается в Vim и готовая ссылка печатается в stdout.

#### Scenario: ZP-CREATE-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-CREATE-004 — отмена обязательного выбора не создаёт непривязанный документ

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Интерактивные workflow`.

Zettelkasten-CLI MUST сохранять следующий инвариант: отмена обязательного выбора не создаёт непривязанный документ.

#### Scenario: ZP-CREATE-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-CREATE-005 — ошибка constructor или регистрации завершает workflow ненулевым кодом

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Интерактивные workflow`.

Zettelkasten-CLI MUST сохранять следующий инвариант: ошибка constructor или регистрации завершает workflow ненулевым кодом.

#### Scenario: ZP-CREATE-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
