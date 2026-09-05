## MODIFIED Requirements

### Requirement: ZP-ARCH-003 — канонические workflow

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Граница плагина`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: канонические workflow Zettelkasten plugin: Note, Memo, Topic и Todo; Diary является каноническим workflow отдельного Diary plugin.

#### Scenario: ZP-ARCH-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
