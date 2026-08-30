# plugin-architecture Specification

## Purpose

Определить Zettelkasten plugin boundary поверх neutral engine и критерии принадлежности plugin functionality.

## Requirements

### Requirement: ZP-ARCH-001 — плагин зависит от ../../lib/, ../../objects/ и собственных lib/

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Граница плагина`.

Zettelkasten-CLI MUST сохранять следующий инвариант: плагин зависит от `../../lib/`, `../../objects/` и собственных `lib/`.

#### Scenario: ZP-ARCH-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-ARCH-002 — движок не зависит от плагина

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Граница плагина`.

Zettelkasten-CLI MUST сохранять следующий инвариант: движок не зависит от плагина.

#### Scenario: ZP-ARCH-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-ARCH-003 — канонические workflow

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Граница плагина`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: канонические workflow: Note, Memo, Topic, Todo и Diary.

#### Scenario: ZP-ARCH-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-ARCH-004 — top-level команды, не делегирующие файлу под .scripts/zettelkasten/, не являются функциями эт...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Граница плагина`.

Zettelkasten-CLI MUST сохранять следующий инвариант: top-level команды, не делегирующие файлу под `.scripts/zettelkasten/`, не являются функциями этого плагина.

#### Scenario: ZP-ARCH-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-ARCH-005 — новая функция включается в документацию плагина только после появления реализации в plugin di...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Граница плагина`.

Development, migration или runtime process MUST соблюдать следующее правило: новая функция включается в документацию плагина только после появления реализации в plugin directory и проверки.

#### Scenario: ZP-ARCH-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
