# bindings Specification

## Purpose

Определить Memo↔Topic binding behavior, key-topic/keyword inheritance и selector safety.

## Requirements

### Requirement: BIND-001 — zt-memo копирует в новую Memo точную строку :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Связывание Memo и Topic`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-memo` копирует в новую Memo точную строку `:key-topic:` выбранной Topic.

#### Scenario: BIND-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: BIND-002 — zt-memo использует :description

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Связывание Memo и Topic`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-memo` использует `:description:` Topic только для отображения в селекторе и тексте ссылки, а не для вычисления `:key-topic:`.

#### Scenario: BIND-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: BIND-003 — команды связывания не выводят и не изменяют тематический ключ на основании заголовка или :des...

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Связывание Memo и Topic`.

Zettelkasten-CLI MUST сохранять следующий инвариант: команды связывания не выводят и не изменяют тематический ключ на основании заголовка или `:description:`.

#### Scenario: BIND-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: BIND-004 — селектор не предлагает Topic без непустого header :key-topic:, а zt-memo повторно проверяет в...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Связывание Memo и Topic`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: селектор не предлагает Topic без непустого header `:key-topic:`, а `zt-memo` повторно проверяет выбранную Topic и отклоняет её до создания Memo.

#### Scenario: BIND-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: BIND-005 — при выборе Topic с противоречивыми каноническими метаданными команда предупреждает пользовате...

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Связывание Memo и Topic`.

Целевая архитектура или поведение MUST сохранять следующий target contract: при выборе Topic с противоречивыми каноническими метаданными команда предупреждает пользователя и требует явного решения до создания документа или связи.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: BIND-005 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: BIND-006 — после создания Memo проверяется точное совпадение её :key-topic

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Связывание Memo и Topic`.

Целевая архитектура или поведение MUST сохранять следующий target contract: после создания Memo проверяется точное совпадение её `:key-topic:` с выбранной Topic и взаимность созданной связи.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: BIND-006 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability
