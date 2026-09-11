# plugin-topic-todo Specification

## Purpose

Определить Topic и Todo presentation contracts внутри Zettelkasten plugin.

## Requirements

### Requirement: ZP-TOPIC-001 — Topic получает title <key> - ключевая тема, description и непустой key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/zettelkasten/docs/requirements.adoc` → section `Topic и Todo`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Topic получает title `<key> - ключевая тема`, description и непустой `key-topic`.

#### Scenario: ZP-TOPIC-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-TODO-001 — Todo получает датированный title и начальную строку задачи согласно constructor contract

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/zettelkasten/docs/requirements.adoc` → section `Topic и Todo`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Todo получает датированный title и начальную строку задачи согласно constructor contract.

#### Scenario: ZP-TODO-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
