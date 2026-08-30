# links Specification

## Purpose

Определить canonical AsciiDoc link format, validation, idempotency и compatibility constraints.

## Requirements

### Requirement: LINK-001 — связи между core documents внутри notes/ оформляются относительными AsciiDoc-ссылками вида li...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Zettelkasten-CLI MUST сохранять следующий инвариант: связи между core documents внутри `notes/` оформляются относительными AsciiDoc-ссылками вида `link:UUID.adoc[Описание]`; внешние контексты используют правила `PATH-003`–`PATH-005`.

#### Scenario: LINK-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: LINK-002 — Topic хранит ссылки на явно связанные с ней Memo и Note

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Topic хранит ссылки на явно связанные с ней Memo и Note.

#### Scenario: LINK-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: LINK-003 — добавление новых связей не создаёт дублирующиеся заголовки разделов

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Zettelkasten-CLI MUST сохранять следующий инвариант: добавление новых связей не создаёт дублирующиеся заголовки разделов.

#### Scenario: LINK-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: LINK-004 — механизм перекрёстных ссылок идемпотентен

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Zettelkasten-CLI MUST сохранять следующий инвариант: механизм перекрёстных ссылок идемпотентен.

#### Scenario: LINK-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: LINK-005 — идемпотентность связи определяется UUID целевого документа, независимо от текста ссылки

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Zettelkasten-CLI MUST сохранять следующий инвариант: идемпотентность связи определяется UUID целевого документа, независимо от текста ссылки.

#### Scenario: LINK-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: LINK-006 — парсинг AsciiDoc-ссылок совместим с zsh и не использует ошибочные glob-шаблоны вида %%[*

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Zettelkasten-CLI MUST сохранять следующий инвариант: парсинг AsciiDoc-ссылок совместим с zsh и не использует ошибочные glob-шаблоны вида `%%[*`.

#### Scenario: LINK-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: LINK-007 — после операций создания и изменения связей не должно оставаться битых ссылок

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Связанные документы`.

Development, migration или runtime process MUST соблюдать следующее правило: после операций создания и изменения связей не должно оставаться битых ссылок.

#### Scenario: LINK-007 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
