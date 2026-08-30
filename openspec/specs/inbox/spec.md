# inbox Specification

## Purpose

Определить Inbox staging boundary, capture/processed lifecycle, idempotency roadmap и source-of-truth constraints.

## Requirements

### Requirement: INBOX-001 — источник захвата не является источником истины

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Zettelkasten-CLI MUST сохранять следующий инвариант: источник захвата не является источником истины.

#### Scenario: INBOX-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: INBOX-002 — источником истины после будущего импорта остаются постоянные AsciiDoc-документы

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Zettelkasten-CLI MUST сохранять следующий инвариант: источником истины после будущего импорта остаются постоянные AsciiDoc-документы; raw/processed являются staging layer.

#### Scenario: INBOX-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: INBOX-003 — импорт является идемпотентным

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Целевая архитектура или поведение MUST сохранять следующий target contract: импорт является идемпотентным.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INBOX-003 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INBOX-004 — raw capture содержит :captured-at

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: raw capture содержит `:captured-at:` и `:source:` в заголовке AsciiDoc.

#### Scenario: INBOX-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-005 — захват в inbox/raw и перевод в inbox/processed являются разными явными операциями

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: захват в `inbox/raw` и перевод в `inbox/processed` являются разными явными операциями.

#### Scenario: INBOX-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-006 — Inbox Layer расширяется для новых источников без изменения канонической модели документов

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Целевая архитектура или поведение MUST сохранять следующий target contract: Inbox Layer расширяется для новых источников без изменения канонической модели документов.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INBOX-006 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INBOX-007 — zt-inbox.zsh создаёт raw-элемент с однострочным непустым заголовком и защищает существующие ф...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-inbox.zsh` создаёт raw-элемент с однострочным непустым заголовком и защищает существующие файлы от перезаписи.

#### Scenario: INBOX-007 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-008 — zt-inbox.zsh открывает созданный элемент через непустой существующий $EDITOR, включая editor...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-inbox.zsh` открывает созданный элемент через непустой существующий `$EDITOR`, включая editor command с аргументами.

#### Scenario: INBOX-008 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-009 — zt-processed.zsh обрабатывает только непосредственный обычный файл inbox/raw и отклоняет внеш...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-processed.zsh` обрабатывает только непосредственный обычный файл `inbox/raw` и отклоняет внешние, вложенные и symlink-пути.

#### Scenario: INBOX-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-010 — перевод в processed не перезаписывает существующее назначение и атомарно резервирует destinat...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: перевод в processed не перезаписывает существующее назначение и атомарно резервирует destination до удаления raw-файла.

#### Scenario: INBOX-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-011 — оба Inbox-скрипта используют ZK_HOME

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: оба Inbox-скрипта используют `ZK_HOME`; `ZETTELKASTEN_ROOT` поддерживается как совместимый fallback.

#### Scenario: INBOX-011 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-012 — raw и processed сохраняют исходное имя и содержимое

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Inbox Layer`.

Zettelkasten-CLI MUST сохранять следующий инвариант: raw и processed сохраняют исходное имя и содержимое; операция processed не создаёт постоянную Note/Memo и не регистрирует элемент в `all-todays`.

#### Scenario: INBOX-012 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
