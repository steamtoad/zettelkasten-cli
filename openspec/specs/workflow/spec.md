# workflow Specification

## Purpose

Определить console/Vim/fzf creation workflow и обязательные side effects для persistent document creation.

## Requirements

### Requirement: FLOW-001 — основной интерактивный workflow строится вокруг zsh, grep/rg, awk, sed, fzf, Vim и cat

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: основной интерактивный workflow строится вокруг zsh, grep/rg, awk, sed, fzf, Vim и cat.

#### Scenario: FLOW-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FLOW-002 — команды создания постоянных документов регистрируют созданный документ в all-todays

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: команды создания постоянных документов регистрируют созданный документ в `all-todays`.

#### Scenario: FLOW-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FLOW-003 — команды создания постоянных документов автоматически открывают документ в Vim

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: команды создания постоянных документов автоматически открывают документ в Vim.

#### Scenario: FLOW-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FLOW-004 — после создания постоянного документа выводится готовая AsciiDoc-ссылка

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: после создания постоянного документа выводится готовая AsciiDoc-ссылка.

#### Scenario: FLOW-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FLOW-005 — новые Note наследуют тематические и связующие ключевые слова источника

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: новые Note наследуют тематические и связующие ключевые слова источника.

#### Scenario: FLOW-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: FLOW-006 — служебные теги типа исходного документа, например memo или topic, не наследуются Note

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Zettelkasten-CLI MUST сохранять следующий инвариант: служебные теги типа исходного документа, например `memo` или `topic`, не наследуются Note.

#### Scenario: FLOW-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: FLOW-007 — ручное создание документов вне CLI не обязано автоматически выполнять правила all-todays, Vim...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Development, migration или runtime process MUST соблюдать следующее правило: ручное создание документов вне CLI не обязано автоматически выполнять правила `all-todays`, Vim и вывода ссылки.

#### Scenario: FLOW-007 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: FLOW-008 — агент, создающий постоянный документ вручную вместо интерактивного CLI, воспроизводит обязате...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Workflow`.

Development, migration или runtime process MUST соблюдать следующее правило: агент, создающий постоянный документ вручную вместо интерактивного CLI, воспроизводит обязательные побочные эффекты соответствующего скрипта и добавляет требуемые агенту метаданные.

#### Scenario: FLOW-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
