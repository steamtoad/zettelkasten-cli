# library-boundaries Specification

## Purpose

Определить neutral/plugin library boundaries, path handling, dependency checks и deduplication policy.

## Requirements

### Requirement: LIB-001 — повторяющийся нейтральный код переносится в scripts/lib/

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Development, migration или runtime process MUST соблюдать следующее правило: повторяющийся нейтральный код переносится в `scripts/lib/`; Zettelkasten-specific повторяющийся код — в `scripts/zettelkasten/lib/`, когда это уменьшает реальное дублирование.

#### Scenario: LIB-001 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: LIB-002 — нейтральные библиотеки scripts/lib/

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: нейтральные библиотеки `scripts/lib/`: `paths.zsh`, `uuid.zsh`, `asciidoc.zsh`; Zettelkasten-specific библиотеки находятся в `scripts/zettelkasten/lib/`.

#### Scenario: LIB-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: LIB-003 — нейтральные библиотеки templates.zsh, index.zsh и git.zsh добавляются только при появлении со...

**Legacy status:** `ROADMAP`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Целевая архитектура или поведение MUST сохранять следующий target contract: нейтральные библиотеки `templates.zsh`, `index.zsh` и `git.zsh` добавляются только при появлении соответствующего общего поведения.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: LIB-003 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: LIB-004 — при анализе нескольких скриптов проверяется дублирование и возможность использования существу...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Development, migration или runtime process MUST соблюдать следующее правило: при анализе нескольких скриптов проверяется дублирование и возможность использования существующих библиотек.

#### Scenario: LIB-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: LIB-005 — все команды используют ZK_HOME и библиотеку путей вместо прямого $HOME/zettelkasten

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Development, migration или runtime process MUST соблюдать следующее правило: все команды используют `ZK_HOME` и библиотеку путей вместо прямого `$HOME/zettelkasten`.

#### Scenario: LIB-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: LIB-006 — команда проверяет необходимые внешние зависимости и сообщает понятную ошибку при их отсутствии

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Development, migration или runtime process MUST соблюдать следующее правило: команда проверяет необходимые внешние зависимости и сообщает понятную ошибку при их отсутствии.

#### Scenario: LIB-006 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
