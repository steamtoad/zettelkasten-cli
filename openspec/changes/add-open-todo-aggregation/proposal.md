# Агрегация открытых задач из активных документов

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 — плановое развитие, не исправление аварии. Система создаёт Todo, но не собирает открытые задачи из всех активных постоянных документов.

## Current Behavior

Система создаёт Todo, но не собирает открытые задачи из всех активных постоянных документов. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Read-only команда zt-tasks выводит открытые задачи с source links, учитывая deprecation и examples.

## What Changes

- `TASKS-001`: Сканируются все активные типы.
- `TASKS-002`: Каждая задача сохраняет источник и положение.
- `TASKS-003`: Ошибки чтения не становятся полным успешным результатом.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `todo-aggregation`: Агрегация открытых задач из активных документов.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P2`.
- Baseline traceability: `DOC-003`, `DEPR-003`, `PATH-005`, `INDEX-002`.
- IDs этой дельты: `TASKS-001`, `TASKS-002`, `TASKS-003`.
- Польза сейчас: Read-only команда zt-tasks выводит открытые задачи с source links, учитывая deprecation и examples.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `unify-asciidoc-metadata-and-links`.
- `strengthen-document-integrity-checks`.

## Verification

Primary test: `tests/zt-add-open-todo-aggregation.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
