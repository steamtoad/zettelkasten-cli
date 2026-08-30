# indexing Specification

## Purpose

Определить source-of-truth и roadmap contracts для derived indexing и SQLite integration.

## Requirements

### Requirement: INDEX-001 — SQLite является необязательным вторичным индексом, а не источником истины

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: SQLite является необязательным вторичным индексом, а не источником истины.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-001 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-002 — текущие базовые команды работают напрямую с файлами и не требуют SQLite

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: текущие базовые команды работают напрямую с файлами и не требуют SQLite.

#### Scenario: INDEX-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: INDEX-003 — файл SQLite хранится в .state/

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: файл SQLite хранится в `.state/`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-003 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-004 — поисковые и аналитические команды могут использовать SQLite для ускорения

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: поисковые и аналитические команды могут использовать SQLite для ускорения.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-004 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-005 — при отсутствии или удалении SQLite система продолжает работать через файловый backend

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: при отсутствии или удалении SQLite система продолжает работать через файловый backend.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-005 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-006 — данные SQLite полностью восстанавливаются из AsciiDoc

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: данные SQLite полностью восстанавливаются из AsciiDoc.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-006 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-007 — ID записи SQLite однозначно соответствует имени AsciiDoc-файла

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: ID записи SQLite однозначно соответствует имени AsciiDoc-файла.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-007 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-008 — изменение постоянного знания выполняется через AsciiDoc-файлы и CLI, а не прямой записью в SQ...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: изменение постоянного знания выполняется через AsciiDoc-файлы и CLI, а не прямой записью в SQLite.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-008 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: INDEX-009 — zt-index rebuild полностью восстанавливает индекс

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Индексирование и SQLite`.

Целевая архитектура или поведение MUST сохранять следующий target contract: `zt-index rebuild` полностью восстанавливает индекс.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: INDEX-009 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability
