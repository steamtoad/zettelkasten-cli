# search Specification

## Purpose

Определить search/fzf behavior, display format, type/deprecated filtering и multibyte-safe handling.

## Requirements

### Requirement: FZF-001 — специализированный селектор показывает UUID/имя файла и :description

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Поиск и FZF`.

Development, migration или runtime process MUST соблюдать следующее правило: специализированный селектор показывает UUID/имя файла и `:description:` в однозначно разбираемом формате.

#### Scenario: FZF-001 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: FZF-002 — поиск и интерактивный выбор используют :description:

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Поиск и FZF`.

`zt-edit`, `zt-getlink` и специализированные selectors MUST искать и показывать `:description:`. `zt-find` и `zt-read` SHALL сохранять literal case-insensitive поиск по всему содержимому активного документа, включая body; `:description:` используется для описания ссылок. Эта разница MUST быть явно отражена в README и regression tests.

#### Scenario: Термин только в body

- **GIVEN** активная Note содержит искомую фразу только в body
- **WHEN** запущены find и read
- **THEN** Note SHALL присутствовать в обеих выдачах
- **AND** `:description:` SHALL остаться описанием ссылки

#### Scenario: FZF-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FZF-003 — новые селекторы не используют хрупкое позиционное извлечение через cut -b

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Поиск и FZF`.

Development, migration или runtime process MUST соблюдать следующее правило: новые селекторы не используют хрупкое позиционное извлечение через `cut -b`.

#### Scenario: FZF-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: FZF-004 — учитывается совместимость используемых конструкций grep, rg, awk, sed и fzf на Linux и macOS

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Поиск и FZF`.

Development, migration или runtime process MUST соблюдать следующее правило: учитывается совместимость используемых конструкций `grep`, `rg`, `awk`, `sed` и `fzf` на Linux и macOS.

#### Scenario: FZF-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: FZF-005 — специализированные селекторы фильтруют требуемый :type

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Поиск и FZF`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: специализированные селекторы фильтруют требуемый `:type:` и deprecated; общие `find`, `read`, `edit` и `getlink` могут включать несколько активных типов.

#### Scenario: FZF-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FZF-006 — формат выбора следует унифицировать после определения совместимого формата для всех команд

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Поиск и FZF`.

Целевая архитектура или поведение MUST сохранять следующий target contract: формат выбора следует унифицировать после определения совместимого формата для всех команд.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: FZF-006 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability
