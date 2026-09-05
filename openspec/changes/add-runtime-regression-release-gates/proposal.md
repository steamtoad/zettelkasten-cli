# Поведенческая регрессия и проверяемая зрелость релиза

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G11 / G01 / G02 / G03 / G04 / G05 / G06 / G07 / G08 / G09 / G10. Зелёные проверки 316 ID не доказывают runtime; нет полной матрицы отказов, Linux/macOS и чистой поставки.

## Current Behavior

Зелёные проверки 316 ID не доказывают runtime; нет полной матрицы отказов, Linux/macOS и чистой поставки. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Связать runtime-гарантии с executable tests, платформами и release evidence; не выдавать SKIP за PASS.

## What Changes

- `RUNTIME-GATE-001`: Каждый runtime contract связан с поведением.
- `RUNTIME-GATE-002`: Регрессия включает отрицательные сценарии аудита.
- `RUNTIME-GATE-003`: Платформы и skips отражаются достоверно.
- `RUNTIME-GATE-004`: Готовность поставки основана на проверках.
- `RUNTIME-GATE-005`: Документация точно описывает пределы проверок.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `runtime-quality`: Поведенческая регрессия и проверяемая зрелость релиза.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L2`; приоритет `P1`.
- Baseline traceability: `CHECK-008`, `CHECK-009`, `CHECK-019`, `CHECK-020`, `CHECK-021`, `CHECK-023`, `SPEC-001`, `STYLE-005`.
- IDs этой дельты: `RUNTIME-GATE-001`, `RUNTIME-GATE-002`, `RUNTIME-GATE-003`, `RUNTIME-GATE-004`, `RUNTIME-GATE-005`.
- Польза сейчас: Связать runtime-гарантии с executable tests, платформами и release evidence; не выдавать SKIP за PASS.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `make-public-distribution-reproducible`.

## Verification

Primary test: `tests/zt-add-runtime-regression-release-gates.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
