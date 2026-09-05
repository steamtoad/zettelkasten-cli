# Полный граф входящих ссылок при миграции notes

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G06. Миграция меняет ссылки только в moved documents, all-todays и workspaces; корневой overview остаётся сломанным.

## Current Behavior

Миграция меняет ссылки только в moved documents, all-todays и workspaces; корневой overview остаётся сломанным. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Применять проверенный manifest всех поддерживаемых входящих ссылок, а неподдерживаемые случаи диагностировать до записи.

## What Changes

- `MIGRATE-LINK-001`: Dry-run содержит полную проверяемую область.
- `MIGRATE-LINK-002`: Относительные ссылки преобразуются от физического source.
- `MIGRATE-LINK-003`: Postflight предшествует удалению backup.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `migration-coverage`: Полный граф входящих ссылок при миграции notes.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P1`.
- Baseline traceability: `PATH-001`, `PATH-008`, `PATH-010`, `PATH-011`, `MIGR-002`, `MIGR-003`, `MIGR-005`, `CHECK-004`.
- IDs этой дельты: `MIGRATE-LINK-001`, `MIGRATE-LINK-002`, `MIGRATE-LINK-003`.
- Польза сейчас: Применять проверенный manifest всех поддерживаемых входящих ссылок, а неподдерживаемые случаи диагностировать до записи.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `unify-asciidoc-metadata-and-links`.
- `add-recoverable-workflow-transactions`.

## Verification

Primary test: `tests/zt-complete-notes-directory-migration.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
