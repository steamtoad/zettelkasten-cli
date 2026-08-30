# plugin-compatibility Specification

## Purpose

Определить compatibility entrypoints и storage/link preservation при использовании plugin layer.

## Requirements

### Requirement: ZP-COMPAT-001 — top-level zt-note.zsh, zt-memo.zsh, zt-keytopic.zsh, zt-todo.zsh, zt-diary.zsh остаются тонки...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Совместимость`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: top-level `zt-note.zsh`, `zt-memo.zsh`, `zt-keytopic.zsh`, `zt-todo.zsh`, `zt-diary.zsh` остаются тонкими `exec`-обёртками.

#### Scenario: ZP-COMPAT-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-COMPAT-002 — существующие aliases продолжают работать через compatibility entrypoints

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Совместимость`.

Zettelkasten-CLI MUST сохранять следующий инвариант: существующие aliases продолжают работать через compatibility entrypoints.

#### Scenario: ZP-COMPAT-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ZP-COMPAT-003 — формат существующих AsciiDoc-документов и ссылок не меняется при подключении плагина

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/zettelkasten/docs/requirements.adoc` → section `Совместимость`.

Zettelkasten-CLI MUST сохранять следующий инвариант: формат существующих AsciiDoc-документов и ссылок не меняется при подключении плагина.

#### Scenario: ZP-COMPAT-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
