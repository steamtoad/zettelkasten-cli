# inbox Specification

## Purpose

Определить Inbox staging boundary, capture/processed lifecycle, idempotency roadmap и source-of-truth constraints.

Реализованные изменения: [fix-plugin-regression-edge-cases](../../changes/archive/2026-09-06-fix-plugin-regression-edge-cases/proposal.md).

## Requirements

### Requirement: INBOX-001 — источник захвата не является источником истины

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Zettelkasten-CLI MUST сохранять следующий инвариант: источник захвата не является источником истины.

#### Scenario: INBOX-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: INBOX-002 — источником истины после будущего импорта остаются постоянные AsciiDoc-документы

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Zettelkasten-CLI MUST сохранять следующий инвариант: источником истины после будущего импорта остаются постоянные AsciiDoc-документы; raw/processed являются staging layer.

#### Scenario: INBOX-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: INBOX-003 — импорт является идемпотентным

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Целевая архитектура или поведение MUST сохранять следующий target contract: импорт является идемпотентным.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INBOX-003 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INBOX-004 — raw capture содержит :captured-at

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: raw capture содержит `:captured-at:` и `:source:` в заголовке AsciiDoc.

#### Scenario: INBOX-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-005 — захват в inbox/raw и перевод в inbox/processed являются разными явными операциями

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: захват в `inbox/raw` и перевод в `inbox/processed` являются разными явными операциями.

#### Scenario: INBOX-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-006 — Inbox Layer расширяется для новых источников без изменения канонической модели документов

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Целевая архитектура или поведение MUST сохранять следующий target contract: Inbox Layer расширяется для новых источников без изменения канонической модели документов.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INBOX-006 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INBOX-007 — zt-inbox.zsh создаёт raw-элемент с однострочным непустым заголовком и защищает существующие ф...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Capture SHALL создавать raw-элемент с однострочным непустым заголовком в пути с пробелами и Unicode; timestamp collisions, включая dangling symlink, MUST выбирать новый suffix без перезаписи существующего entry. Ошибка любой записи metadata MUST завершать capture ошибкой, удалять созданный неполный raw и не запускать editor.

#### Scenario: INBOX-007 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Unicode raw path

- **WHEN** ZK_HOME содержит пробелы и кириллицу
- **THEN** capture создаёт и печатает путь корректного raw AsciiDoc без изменения cwd редактора


#### Scenario: Concurrent capture collision

- **WHEN** одновременные capture имеют одинаковый timestamp либо занятый symlink basename
- **THEN** каждый успешный capture имеет уникальное имя, существующие entries не изменены


#### Scenario: Partial metadata write

- **WHEN** запись любого атрибута capture завершается ошибкой
- **THEN** неполный raw удалён, exit ненулевой, editor не вызван

### Requirement: INBOX-008 — zt-inbox.zsh открывает созданный элемент через непустой существующий $EDITOR, включая editor...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Capture SHALL запускать существующий непустой EDITOR, сохраняя lexical quoting пути и аргументов, включая пустой quoted argument; разбор MUST NOT выполнять eval, command substitution или shell operators из значения EDITOR. Проверка editor остаётся после создания raw.

#### Scenario: INBOX-008 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Quoted editor path

- **WHEN** EDITOR содержит путь с пробелами в кавычках и quoted arguments
- **THEN** вызывается указанный executable с точными аргументами без выполнения содержащегося в них shell code

### Requirement: INBOX-009 — zt-processed.zsh обрабатывает только непосредственный обычный файл inbox/raw и отклоняет внеш...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Processed MUST принимать только непосредственный обычный файл inbox/raw; symlink leaf MUST отклоняться до разрешения target, в том числе если он указывает на соседний raw. Внешние и вложенные physical paths MUST отклоняться.

#### Scenario: INBOX-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Internal raw symlink

- **WHEN** processed получает symlink на другой файл внутри raw
- **THEN** операция отклонена, symlink и target остаются без изменений

### Requirement: INBOX-010 — перевод в processed не перезаписывает существующее назначение и атомарно резервирует destinat...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Processed MUST атомарно резервировать точное имя назначения hard link операцией без перезаписи и без directory-operand semantics. Любой существующий entry назначения, включая каталог, symlink и dangling symlink, MUST сохраняться, а raw MUST оставаться на месте при отказе. Создание directory destination между preflight и резервированием MUST NOT приводить к записи внутрь него.

#### Scenario: INBOX-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Directory destination collision

- **WHEN** processed destination является каталогом или symlink на каталог
- **THEN** операция завершается ошибкой без вложенного файла и без удаления raw


#### Scenario: Racing destination collision

- **WHEN** destination создаётся конкурентно перед hard link
- **THEN** точная atomic reservation отклонена и source не удаляется

### Requirement: INBOX-011 — оба Inbox-скрипта используют ZK_HOME

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: оба Inbox-скрипта используют `ZK_HOME`; `ZETTELKASTEN_ROOT` поддерживается как совместимый fallback.

#### Scenario: INBOX-011 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INBOX-012 — raw и processed сохраняют исходное имя и содержимое

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Zettelkasten-CLI MUST сохранять следующий инвариант: raw и processed сохраняют исходное имя и содержимое; операция processed не создаёт постоянную Note/Memo и не регистрирует элемент в `all-todays`.

#### Scenario: INBOX-012 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
