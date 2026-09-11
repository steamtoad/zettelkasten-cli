# memo-chains Specification

## Purpose

Определить continuation chains для Memo, link labels, inheritance и branching semantics.

## Requirements

### Requirement: CHAIN-001 — Memo может иметь не более одной основной линии продолжения

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Memo Chains`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Memo может иметь не более одной основной линии продолжения.

#### Scenario: CHAIN-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: CHAIN-002 — Memo может иметь произвольное число дополнительных веток

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Memo Chains`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Memo может иметь произвольное число дополнительных веток.

#### Scenario: CHAIN-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: CHAIN-003 — первая ссылка продолжения, созданная zt-continue, называется Следующее memo

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Memo Chains`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: первая ссылка продолжения, созданная `zt-continue`, называется `Следующее memo`.

#### Scenario: CHAIN-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHAIN-004 — дополнительные ссылки продолжения, созданные zt-continue, называются Ветка

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Memo Chains`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: дополнительные ссылки продолжения, созданные `zt-continue`, называются `Ветка: <description>`.

#### Scenario: CHAIN-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHAIN-005 — каждая Memo, созданная через zt-continue, имеет одну обратную ссылку Предыдущее memo

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Memo Chains`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: каждая Memo, созданная через `zt-continue`, имеет одну обратную ссылку `Предыдущее memo`.

#### Scenario: CHAIN-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHAIN-006 — zt-check проверяет структуру, цели и взаимность Memo Chain

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Memo Chains`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-check` проверяет структуру, цели, взаимность и циклы Memo Chain вне opaque AsciiDoc blocks.

#### Scenario: CHAIN-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
