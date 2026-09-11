# Восстановимые многофайловые операции

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G01 / G03 / G08. Reduce не имеет общего rollback; Refine скрывает ошибки восстановления. Concurrent edits и авария между файловыми заменами оставляют несогласованное состояние.

## Current Behavior

Reduce не имеет общего rollback; Refine скрывает ошибки восстановления. Concurrent edits и авария между файловыми заменами оставляют несогласованное состояние. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Согласованно применять документы, связи и state, обнаруживать конфликт планов, сохранять проверяемое recovery после отказов.

## What Changes

- `TXN-001`: Manifest и staging предшествуют первой knowledge-записи.
- `TXN-002`: Rollback не скрывает собственную ошибку.
- `TXN-003`: Устаревший план и конкуренция не перезаписывают данные.
- `TXN-004`: Прерванная операция обнаруживается и восстанавливается явно.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `workflow-transactions`: Восстановимые многофайловые операции.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L2`; приоритет `P1`.
- Baseline traceability: `SAFE-001`, `SAFE-002`, `SAFE-004`, `REFINE-008`, `ZP-DIARY-005`, `FLOW-002`.
- IDs этой дельты: `TXN-001`, `TXN-002`, `TXN-003`, `TXN-004`.
- Польза сейчас: Согласованно применять документы, связи и state, обнаруживать конфликт планов, сохранять проверяемое recovery после отказов.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `fix-atomic-document-writes`.
- `unify-asciidoc-metadata-and-links`.
- `validate-diary-and-memo-chains`.
- `standardize-cli-preflight-and-selection`.

## Verification

Primary test: `tests/zt-add-recoverable-workflow-transactions.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
