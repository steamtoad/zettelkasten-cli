# workspace-plugin-architecture

## Purpose

Определяет отдельную plugin boundary для Workspace, допустимые зависимости, совместимые CLI entrypoints и сохранение Workspace data/link semantics при развитии в репозитории `zettelkasten-cli`.

Реализованные изменения: [refactor-workspace-as-plugin](../../changes/archive/2026-09-06-refactor-workspace-as-plugin/proposal.md).

## Requirements

### Requirement: WP-ARCH-001 — Workspace является отдельным plugin layer

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Архитектура и совместимость`.
Zettelkasten-CLI SHALL размещать канонические create/add/open/remove workflow, Workspace policy library и plugin-specific документацию в sibling plugin `scripts/workspace/`; Workspace workflow и policy MUST оставаться вне ownership `scripts/zettelkasten/` и top-level host scripts.

#### Scenario: Каноническое владение Workspace
- **WHEN** определяется каноническая реализация Workspace workflow или policy
- **THEN** она находится под `scripts/workspace/`, а не в `scripts/zettelkasten/` или в теле top-level compatibility entrypoint

#### Scenario: Разработка остаётся в текущем репозитории
- **WHEN** изменяется поведение или документация Workspace plugin
- **THEN** изменение разрабатывается и проверяется в `zettelkasten-cli` без отдельного Git repository или package

### Requirement: WP-ARCH-002 — Workspace plugin не создаёт обратных зависимостей

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Архитектура и совместимость`.
Workspace plugin MUST depend only on its own plugin-specific code и domain-neutral primitives under `scripts/lib/`. Workspace plugin MUST NOT depend on `scripts/zettelkasten/`; `scripts/lib/`, `scripts/objects/`, `scripts/zettelkasten/` и другие sibling plugins MUST NOT depend on `scripts/workspace/`.

#### Scenario: Проверка направления зависимостей
- **WHEN** repository boundary check анализирует executable source references между слоями
- **THEN** зависимости Workspace plugin ограничены разрешёнными слоями, а ссылки `scripts/workspace/` → `scripts/zettelkasten/` и обратные ссылки существующих слоёв → `scripts/workspace/` отсутствуют

### Requirement: WP-COMPAT-001 — Top-level Workspace entrypoints сохраняют совместимость

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Архитектура и совместимость`.
`scripts/zt-workspace-create.zsh`, `scripts/zt-workspace-add.zsh`, `scripts/zt-workspace-open.zsh` и `scripts/zt-workspace-remove.zsh` SHALL оставаться публичными compatibility entrypoints, делегировать соответствующим canonical workflows Workspace plugin и сохранять CLI arguments, prompts, selection behavior, stdout/stderr, exit status и managed skill mappings.

#### Scenario: Workspace commands делегируют plugin
- **WHEN** пользователь запускает любую поддерживаемую `scripts/zt-workspace-*.zsh` команду
- **THEN** entrypoint делегирует соответствующий Workspace plugin workflow, а observable behavior соответствует `WORKSPACE-008`–`WORKSPACE-014`

#### Scenario: Managed skill mappings остаются стабильными
- **WHEN** проверяется mapping top-level commands на managed operational skills
- **THEN** create/add/open/remove scripts по-прежнему соответствуют `zettelkasten-workspace-create`, `zettelkasten-workspace-add`, `zettelkasten-workspace-open` и `zettelkasten-workspace-remove`

### Requirement: WP-DATA-001 — Выделение plugin сохраняет Workspace data semantics

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Архитектура и совместимость`.
Выделение Workspace plugin MUST preserve `ZK_HOME/workspaces/`, безопасные `.adoc` filenames, ручную редактируемость, раздел `Документы`, ссылки `link:../notes/UUID.adoc[...]`, selection/cancel behavior, idempotent add, read-only open и atomic multi-remove с сохранением file mode. Оно MUST NOT перемещать, переписывать или переиндексировать существующие Workspace самим архитектурным переходом.

#### Scenario: Существующий Workspace остаётся совместимым
- **WHEN** Workspace, созданный до выделения plugin, используется через create/add/open/remove commands после перехода
- **THEN** plugin читает и изменяет его по тем же `WORKSPACE-001`–`WORKSPACE-014` contracts без преобразования формата

#### Scenario: Referenced documents не изменяются
- **WHEN** Workspace plugin создаёт, открывает, добавляет или удаляет Workspace links
- **THEN** target documents under `notes/` не изменяются

#### Scenario: Пользовательские Workspace не мигрируются
- **WHEN** устанавливается или обновляется версия с отдельным Workspace plugin
- **THEN** существующие файлы под `ZK_HOME/workspaces/` не читаются, не перемещаются и не изменяются самим архитектурным переходом

### Requirement: WP-DEV-001 — Workspace plugin проверяется на временном Vault

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Архитектура и совместимость`.
Изменения Workspace plugin MUST сопровождаться regression verification через top-level compatibility entrypoints с временным `ZK_HOME`; ordinary development и validation MUST NOT mutate пользовательские `workspaces/` или referenced documents.

#### Scenario: Regression test изолирует Workspace workflows
- **WHEN** выполняется `tests/zt-workspace-as-plugin.zsh`
- **THEN** create validation/collision, add idempotency, open read-only behavior, remove selection/atomicity/code-block handling/mode preservation и cancel paths проверяются внутри временного `ZK_HOME`

#### Scenario: Реальный Vault не затрагивается
- **WHEN** выполняются repository validation commands для Workspace plugin
- **THEN** фактические пользовательские Workspace и target documents не создаются и не изменяются
