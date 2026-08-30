# plugin-all-todays Specification

## Purpose

Определить регистрацию plugin-created documents в daily activity log.

## Requirements

### Requirement: ZP-TODAY-001 — плагин создаёт all-todays/YYYY-MM-DD.adoc при необходимости

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `all-todays`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: плагин создаёт `all-todays/YYYY-MM-DD.adoc` при необходимости.

#### Scenario: ZP-TODAY-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-TODAY-002 — запись содержит время и ссылку ../notes/UUID.adoc

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `all-todays`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: запись содержит время и ссылку `../notes/UUID.adoc`.

#### Scenario: ZP-TODAY-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-TODAY-003 — target должен существовать до регистрации

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `all-todays`.

Zettelkasten-CLI MUST сохранять следующий инвариант: target должен существовать до регистрации.

#### Scenario: ZP-TODAY-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
