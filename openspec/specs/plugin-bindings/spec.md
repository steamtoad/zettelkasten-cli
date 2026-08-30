# plugin-bindings Specification

## Purpose

Определить Note/Memo binding behavior внутри Zettelkasten plugin.

## Requirements

### Requirement: ZP-BIND-001 — Memo может быть привязано к активной Topic через fzf

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Note и Memo bindings`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Memo может быть привязано к активной Topic через `fzf`.

#### Scenario: ZP-BIND-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-BIND-002 — Note может быть привязана к активному Memo через fzf

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Note и Memo bindings`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Note может быть привязана к активному Memo через `fzf`.

#### Scenario: ZP-BIND-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-BIND-003 — Memo наследует обязательный key-topic выбранной Topic и нормализованные keywords

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Note и Memo bindings`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Memo наследует обязательный `key-topic` выбранной Topic и нормализованные keywords; Note наследует `key-topic`, когда он присутствует у выбранного Memo.

#### Scenario: ZP-BIND-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-BIND-004 — привязка записывается двусторонними AsciiDoc-ссылками

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Note и Memo bindings`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: привязка записывается двусторонними AsciiDoc-ссылками.

#### Scenario: ZP-BIND-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-BIND-005 — выбор ограничен активными документами с соответствующим каноническим type

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Note и Memo bindings`.

Zettelkasten-CLI MUST сохранять следующий инвариант: выбор ограничен активными документами с соответствующим каноническим `type`; Topic без header `:key-topic:` не предлагается для привязки Memo.

#### Scenario: ZP-BIND-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-BIND-006 — отсутствие fzf диагностируется до создания Note или Memo

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Note и Memo bindings`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: отсутствие `fzf` диагностируется до создания Note или Memo.

#### Scenario: ZP-BIND-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
