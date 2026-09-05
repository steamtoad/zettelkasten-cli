# Единая граница создания документов

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 — плановое развитие, не исправление аварии. Есть object constructors без полного workflow, но нет zcreate --no-edit для воспроизводимой автоматизации.

## Current Behavior

Есть object constructors без полного workflow, но нет zcreate --no-edit для воспроизводимой автоматизации. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Создавать пять существующих типов через один проверяемый workflow с activity, явными bindings, date и стабильным выводом.

## What Changes

- `ZCREATE-001`: Пять типов и совместимые entrypoints.
- `ZCREATE-002`: No-edit не требует терминала.
- `ZCREATE-003`: Создание включает полный согласованный workflow.
- `ZCREATE-004`: Date и родительские связи имеют явную семантику.
- `ZCREATE-005`: Template и context не обходят canonical metadata.
- `FLOW-003`: команды создания постоянных документов автоматически открывают документ в Vim.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `zcreate-workflow`: Единая граница создания документов.

### Modified Capabilities

- `workflow`: уточнение связанных baseline contracts.

## Impact

- Уровень repository change: `L4`; приоритет `P2`.
- Baseline traceability: `ARCH-005`, `ARCH-006`, `ARCH-008`, `ARCH-009`, `ARCH-010`, `ARCH-011`, `ARCH-012`, `FLOW-002`, `FLOW-003`, `FLOW-004`.
- IDs этой дельты: `ZCREATE-001`, `ZCREATE-002`, `ZCREATE-003`, `ZCREATE-004`, `ZCREATE-005`, `FLOW-003`.
- Польза сейчас: Создавать пять существующих типов через один проверяемый workflow с activity, явными bindings, date и стабильным выводом.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `strengthen-document-integrity-checks`.
- `add-recoverable-workflow-transactions`.
- `standardize-cli-preflight-and-selection`.
- `clarify-topic-membership-contract`.

## Verification

Primary test: `tests/zt-add-zcreate-workflow.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
