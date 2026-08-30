# architecture Specification

## Purpose

Определить слои, dependency direction, compatibility entrypoints и целевое развитие вокруг zcreate без разрушения текущего workflow.

## Requirements

### Requirement: ARCH-001 — проект рассматривается как единый продукт zettelkasten-cli

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: проект рассматривается как единый продукт `zettelkasten-cli`.

#### Scenario: ARCH-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-002 — нельзя ломать совместимость с AsciiDoc и существующими ссылками между документами

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: нельзя ломать совместимость с AsciiDoc и существующими ссылками между документами.

#### Scenario: ARCH-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-003 — задача по возможности решается в существующей shell-архитектуре

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Development, migration или runtime process MUST соблюдать следующее правило: задача по возможности решается в существующей shell-архитектуре; БД, веб-интерфейс и отдельные сервисы требуют отдельного обоснования.

#### Scenario: ARCH-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: ARCH-004 — Python, Go и Rust допустимы как дополнительный слой, но не должны незаметно заменять shell-wo...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Development, migration или runtime process MUST соблюдать следующее правило: Python, Go и Rust допустимы как дополнительный слой, но не должны незаметно заменять shell-workflow.

#### Scenario: ARCH-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: ARCH-005 — создание документов развивается в сторону единого генератора zcreate

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: создание документов развивается в сторону единого генератора `zcreate`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-005 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-006 — планируемый интерфейс

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: планируемый интерфейс: `zcreate note`, `zcreate memo`, `zcreate todo`, `zcreate diary`, `zcreate topic`; `keytopic` может сохраняться как совместимый alias.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-006 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-007 — тип или режим article должен быть отдельно определён до добавления zcreate article

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: тип или режим `article` должен быть отдельно определён до добавления `zcreate article`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-007 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-008 — zcreate становится каноническим генератором постоянных документов

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: `zcreate` становится каноническим генератором постоянных документов.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-008 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-009 — существующие команды создания становятся совместимыми CLI-обёртками над zcreate

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: существующие команды создания становятся совместимыми CLI-обёртками над `zcreate`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-009 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-010 — генерация UUID, метаданных, doclink, docfilename и регистрация в all-todays выполняются через...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: генерация UUID, метаданных, `doclink`, `docfilename` и регистрация в `all-todays` выполняются через `zcreate`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-010 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-011 — до реализации zcreate --no-edit интерактивные zt-note, zt-memo и другие creation scripts не с...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: до реализации `zcreate --no-edit` интерактивные `zt-note`, `zt-memo` и другие creation scripts не считаются unattended deterministic agent primitives; агент использует их поведение как механический reference и запускает их только в подходящем интерактивном контексте.

#### Scenario: ARCH-011 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-012 — после реализации zcreate --no-edit managed skills используют zcreate как детерминированную гр...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Целевая архитектура или поведение MUST сохранять следующий target contract: после реализации `zcreate --no-edit` managed skills используют `zcreate` как детерминированную границу между семантическими решениями агента и файловой моделью Zettelkasten.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: ARCH-012 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: ARCH-013 — .scripts/objects/ содержит нейтральные constructors постоянных типов Note, Memo, Todo, Diary...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.scripts/objects/` содержит нейтральные constructors постоянных типов Note, Memo, Todo, Diary и Topic; constructors гарантируют UUID-файл, обязательные метаданные, `:type:` и специфический object contract, но не выполняют интерактивный workflow.

#### Scenario: ARCH-013 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ARCH-014 — .scripts/zettelkasten/ и .scripts/zettelkasten/lib/ содержат Zettelkasten-specific policy

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.scripts/zettelkasten/` и `.scripts/zettelkasten/lib/` содержат Zettelkasten-specific policy: интерактивный ввод, bindings, `all-todays`, Diary state и другие workflow-правила.

#### Scenario: ARCH-014 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ARCH-015 — .scripts/lib/ содержит только нейтральные примитивы, доступные object layer, Zettelkasten lay...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `.scripts/lib/` содержит только нейтральные примитивы, доступные object layer, Zettelkasten layer и будущим plugin layers.

#### Scenario: ARCH-015 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-016 — разрешённые зависимости

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: разрешённые зависимости: `objects -> lib`, `zettelkasten -> objects`, `zettelkasten -> lib`, `zettelkasten -> zettelkasten/lib`; зависимости `lib -> zettelkasten` и `objects -> zettelkasten` запрещены.

#### Scenario: ARCH-016 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-017 — top-level zt-note.zsh, zt-memo.zsh, zt-keytopic.zsh, zt-todo.zsh и zt-diary.zsh сохранены как...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: top-level `zt-note.zsh`, `zt-memo.zsh`, `zt-keytopic.zsh`, `zt-todo.zsh` и `zt-diary.zsh` сохранены как compatibility entrypoints и делегируют каноническим workflow в `.scripts/zettelkasten/`.

#### Scenario: ARCH-017 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ARCH-018 — Zettelkasten-specific helper получает namespace zt_*

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Development, migration или runtime process MUST соблюдать следующее правило: Zettelkasten-specific helper получает namespace `zt_*`; нейтральная инфраструктура и object constructors используют `zk_*`.

#### Scenario: ARCH-018 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: ARCH-019 — в переходной архитектуре host CLI может напрямую использовать .scripts/zettelkasten/lib/

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: в переходной архитектуре host CLI может напрямую использовать `.scripts/zettelkasten/lib/`: Continue, Reduce и Refine используют `today.zsh`, Continue использует `bindings.zsh`, Workspace-команды используют `workspace.zsh`; эта зависимость должна быть удалена или перенесена вместе с соответствующим workflow при дальнейшей миграции.

#### Scenario: ARCH-019 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
