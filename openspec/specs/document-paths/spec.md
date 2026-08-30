# document-paths Specification

## Purpose

Определить физическое размещение persistent documents и контекстные правила ссылок между notes, all-todays, Workspace и root-level views.

## Requirements

### Requirement: PATH-001 — все постоянные UUID-документы типов note, memo, todo, diary и topic находятся непосредственно...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: все постоянные UUID-документы типов `note`, `memo`, `todo`, `diary` и `topic` находятся непосредственно в `notes/`.

#### Scenario: PATH-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-002 — постоянные документы внутри notes/ ссылаются друг на друга через link:UUID.adoc[...]

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: постоянные документы внутри `notes/` ссылаются друг на друга через `link:UUID.adoc[...]`.

#### Scenario: PATH-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-003 — all-todays ссылается на постоянные документы через link:../notes/UUID.adoc[...]

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `all-todays` ссылается на постоянные документы через `link:../notes/UUID.adoc[...]`.

#### Scenario: PATH-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-004 — Workspace ссылается на постоянные документы через link:../notes/UUID.adoc[...]

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Workspace ссылается на постоянные документы через `link:../notes/UUID.adoc[...]`.

#### Scenario: PATH-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-005 — root-level генерируемый индекс ссылается на постоянные документы через link:notes/UUID.adoc[...]

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: root-level генерируемый индекс ссылается на постоянные документы через `link:notes/UUID.adoc[...]`.

#### Scenario: PATH-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-006 — :docfilename

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `:docfilename:` содержит basename `UUID.adoc`, а `:doclink:` остаётся контекстной ссылкой `link:UUID.adoc[...]`.

#### Scenario: PATH-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-007 — .last-diary содержит basename UUID.adoc без notes/

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `.last-diary` содержит basename `UUID.adoc` без `notes/`; Diary разрешает его относительно `notes/`.

#### Scenario: PATH-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-008 — repository-level документы, all-todays, Workspace, Inbox, scripts и state не перемещаются авт...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: repository-level документы, `all-todays`, Workspace, Inbox, scripts и state не перемещаются автоматически в `notes/`.

#### Scenario: PATH-008 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PATH-009 — генераторы, Reduce/Refine, поиск, навигация, Workspace и zt-check используют единый notes/ na...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: генераторы, Reduce/Refine, поиск, навигация, Workspace и `zt-check` используют единый `notes/` namespace.

#### Scenario: PATH-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PATH-010 — zt-check разрешает ссылки относительно физического расположения исходного документа и отдельн...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-check` разрешает ссылки относительно физического расположения исходного документа и отдельно проверяет `notes`, `all-todays`, Workspace и Diary.

#### Scenario: PATH-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PATH-011 — zt-migrate-notes-dir.zsh по умолчанию выполняет dry-run

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-migrate-notes-dir.zsh` по умолчанию выполняет dry-run; `--apply` требует чистого Git worktree, проверяет коллизии, переносит только известные постоянные типы и обновляет внешние ссылки.

#### Scenario: PATH-011 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DATA-001 — все постоянные документы являются объектами единой модели Document

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: все постоянные документы являются объектами единой модели Document.

#### Scenario: DATA-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: DATA-002 — модель постоянных документов включает Note, Memo, Todo, Diary и Topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: модель постоянных документов включает Note, Memo, Todo, Diary и Topic.

#### Scenario: DATA-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DATA-003 — Diary образует двунаправленную хронологическую цепочку

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Diary образует двунаправленную хронологическую цепочку; индексом активности является `all-todays`.

#### Scenario: DATA-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: DATA-004 — Topic агрегирует только явно связанные с ней Memo и Note

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Topic агрегирует только явно связанные с ней Memo и Note.

#### Scenario: DATA-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
