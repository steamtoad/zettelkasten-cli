# workspace Specification

## Purpose

Определить aggregator и Workspace contracts, включая безопасное именование, link semantics и отсутствие mutation target documents.

Реализованные изменения: [fix-plugin-regression-edge-cases](../../changes/archive/2026-09-06-fix-plugin-regression-edge-cases/proposal.md).

## Requirements

### Requirement: AGGR-001 — агрегаторы не являются постоянным знанием

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: агрегаторы не являются постоянным знанием.

#### Scenario: AGGR-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGGR-002 — агрегаторы могут не содержать стандартных атрибутов постоянного документа

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: агрегаторы могут не содержать стандартных атрибутов постоянного документа.

#### Scenario: AGGR-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGGR-003 — агрегаторы состоят преимущественно из ссылок на постоянные документы

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: агрегаторы состоят преимущественно из ссылок на постоянные документы.

#### Scenario: AGGR-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGGR-004 — Workspace является разновидностью агрегатора

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Workspace является разновидностью агрегатора.

#### Scenario: AGGR-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-001 — Workspace является рабочим набором документов

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Workspace является рабочим набором документов.

#### Scenario: WORKSPACE-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-002 — Workspace не является постоянным знанием

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Workspace не является постоянным знанием.

#### Scenario: WORKSPACE-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: WORKSPACE-003 — Workspace состоит преимущественно из ссылок на постоянные документы

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Workspace состоит преимущественно из ссылок на постоянные документы.

#### Scenario: WORKSPACE-003 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: WORKSPACE-004 — Workspace может не содержать стандартных атрибутов постоянного документа

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Workspace может не содержать стандартных атрибутов постоянного документа.

#### Scenario: WORKSPACE-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-005 — файлы Workspace располагаются в workspaces/

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: файлы Workspace располагаются в `workspaces/`.

#### Scenario: WORKSPACE-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-006 — именем файла Workspace является его безопасное смысловое название с расширением .adoc

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: именем файла Workspace является его безопасное смысловое название с расширением `.adoc`.

#### Scenario: WORKSPACE-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-007 — Workspace допускает ручное редактирование

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Workspace допускает ручное редактирование.

#### Scenario: WORKSPACE-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: WORKSPACE-008 — специализированные CLI-команды работают с Workspace как с отдельной сущностью

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: специализированные CLI-команды работают с Workspace как с отдельной сущностью.

#### Scenario: WORKSPACE-008 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-009 — zt-workspace-create.zsh создаёт Workspace с разделом Документы, отклоняет пустые, скрытые и с...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-workspace-create.zsh` создаёт Workspace с разделом `Документы`, отклоняет пустые, скрытые и содержащие разделители пути названия и не перезаписывает существующий файл.

#### Scenario: WORKSPACE-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-010 — zt-workspace-add.zsh добавляет выбранные активные постоянные документы идемпотентными относит...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-workspace-add.zsh` добавляет выбранные активные постоянные документы идемпотентными относительными ссылками `link:../notes/UUID.adoc[...]`.

#### Scenario: WORKSPACE-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-011 — zt-workspace-open.zsh выводит выбранный Workspace в stdout без изменения файла

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-workspace-open.zsh` выводит выбранный Workspace в stdout без изменения файла.

#### Scenario: WORKSPACE-011 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: WORKSPACE-012 — zt-workspace-remove.zsh через один fzf --multi выбирает и одним атомарным переписыванием удал...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Workspace remove SHALL через один fzf --multi выбирать active/deprecated/broken targets ../notes/UUID.adoc и одним atomic rewrite удалять только выбранные link macros за пределами supported code blocks. Не выбранные ссылки и окружающий ручной текст MUST сохраняться; bullet line удаляется целиком только если после удаления macro содержит лишь bullet marker и whitespace.

#### Scenario: WORKSPACE-012 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Mixed links and manual text

- **WHEN** выбрана одна из нескольких ссылок в строке Workspace
- **THEN** удалён только выбранный macro, соседние ссылки и текст сохранены


#### Scenario: Inline workspace link

- **WHEN** выбрана ссылка в обычном тексте вне bullet list
- **THEN** удаляется macro без удаления окружающего текста

### Requirement: WORKSPACE-013 — удаление ссылки из Workspace игнорирует поддерживаемые блоки кода, выполняется через временны...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Workspace remove MUST игнорировать supported code blocks, создавать temporary file в том же каталоге и filesystem, что и Workspace, сохранять исходный file mode и заменять файл только после успешной подготовки. Ошибка подготовки или замены MUST оставлять исходный Workspace неизменным и удалять созданный temporary file.

#### Scenario: WORKSPACE-013 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Failed rewrite cleanup

- **WHEN** подготовка или final replacement завершается ошибкой
- **THEN** исходные bytes и mode сохранены, temporary file отсутствует


#### Scenario: Same filesystem staging

- **WHEN** TMPDIR расположен на другом filesystem
- **THEN** temporary file всё равно создаётся рядом с Workspace для atomic rename

### Requirement: WORKSPACE-014 — операции Workspace не изменяют документы, на которые ссылается Workspace

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Zettelkasten-CLI MUST сохранять следующий инвариант: операции Workspace не изменяют документы, на которые ссылается Workspace.

#### Scenario: WORKSPACE-014 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
