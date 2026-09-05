# Корректные указатели и навигационные цепочки

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G02 / G03. Diary связывается с Note по ошибочному .last-diary, а checker проверяет только существование целей. Memo branch parser видит ссылки в примерах.

## Current Behavior

Diary связывается с Note по ошибочному .last-diary, а checker проверяет только существование целей. Memo branch parser видит ссылки в примерах. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Отличать начальное хранилище от повреждённой цепочки; проверять типы, взаимность, ветвление и порядок до записи.

## What Changes

- `CHAIN-CHECK-001`: Preflight Diary предшествует любой записи.
- `CHAIN-CHECK-002`: Проверка Diary включает граф и хронологию.
- `CHAIN-CHECK-003`: Memo chains различают основную линию, ветки и примеры.
- `CHECK-002`: zt-check проверяет структуру репозитория, заголовки, обязательные метаданные, известные типы,....

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `chain-integrity`: Корректные указатели и навигационные цепочки.

### Modified Capabilities

- `validation`: уточнение связанных baseline contracts.

## Impact

- Уровень repository change: `L3`; приоритет `P0`.
- Baseline traceability: `DATA-003`, `PATH-007`, `ZP-DIARY-004`, `ZP-DIARY-005`, `CHAIN-001`, `CHAIN-006`, `CHECK-005`.
- IDs этой дельты: `CHAIN-CHECK-001`, `CHAIN-CHECK-002`, `CHAIN-CHECK-003`, `CHECK-002`.
- Польза сейчас: Отличать начальное хранилище от повреждённой цепочки; проверять типы, взаимность, ветвление и порядок до записи.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `strengthen-document-integrity-checks`.

## Verification

Primary test: `tests/zt-validate-diary-and-memo-chains.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
