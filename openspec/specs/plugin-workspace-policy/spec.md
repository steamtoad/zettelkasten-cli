# plugin-workspace-policy Specification

## Purpose

Определить границы Workspace policy library Zettelkasten plugin.

Реализованные изменения: [refactor-workspace-as-plugin](../../changes/archive/2026-09-06-refactor-workspace-as-plugin/proposal.md).

## Requirements

### Requirement: ZP-WORKSPACE-001 — plugin library вычисляет каталог, title, безопасное filename и ссылки Workspace

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Workspace policy library`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: library отдельного Workspace plugin вычисляет каталог, title, безопасное filename и ссылки Workspace.

#### Scenario: ZP-WORKSPACE-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ZP-WORKSPACE-002 — библиотека не владеет top-level Workspace workflow

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/workspace/docs/requirements.adoc` → section `Workspace policy library`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Workspace policy library не является top-level workflow; canonical create/add/open/remove workflows принадлежат executable scripts того же Workspace plugin, а соответствующие top-level host commands являются только compatibility entrypoints.

#### Scenario: ZP-WORKSPACE-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
