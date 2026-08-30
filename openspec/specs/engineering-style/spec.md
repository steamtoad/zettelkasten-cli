# engineering-style Specification

## Purpose

Определить Zsh, portability, quoting, file-header, executable and line-ending engineering rules.

## Requirements

### Requirement: STYLE-001 — новые shell-скрипты проекта пишутся на zsh

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: новые shell-скрипты проекта пишутся на zsh.

#### Scenario: STYLE-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: STYLE-002 — используется единый заголовок файла

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Development, migration или runtime process MUST соблюдать следующее правило: используется единый заголовок файла.

#### Scenario: STYLE-002 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: STYLE-003 — текстовый файл завершается символом LF

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Development, migration или runtime process MUST соблюдать следующее правило: текстовый файл завершается символом LF.

#### Scenario: STYLE-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: STYLE-004 — жёстко прошитые пути не добавляются

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Development, migration или runtime process MUST соблюдать следующее правило: жёстко прошитые пути не добавляются; существующие постепенно заменяются использованием `ZK_HOME`.

#### Scenario: STYLE-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: STYLE-005 — учитывается совместимость Linux и macOS

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: учитывается совместимость Linux и macOS.

#### Scenario: STYLE-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: STYLE-006 — пробелы, кавычки и специальные символы в пользовательских значениях обрабатываются корректно

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: пробелы, кавычки и специальные символы в пользовательских значениях обрабатываются корректно.

#### Scenario: STYLE-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: STYLE-007 — пустой ввод и отмена интерактивного выбора обрабатываются без повреждения данных

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: пустой ввод и отмена интерактивного выбора обрабатываются без повреждения данных.

#### Scenario: STYLE-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: STYLE-008 — пользовательские CLI-скрипты должны быть исполняемыми

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Стиль CLI-скриптов`.

Development, migration или runtime process MUST соблюдать следующее правило: пользовательские CLI-скрипты должны быть исполняемыми.

#### Scenario: STYLE-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
