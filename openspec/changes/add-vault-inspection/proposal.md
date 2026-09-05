# Явное разрешение и диагностика Vault

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 / G07. Нет отдельной диагностики выбранного data vault и отличия от source repository.

## Current Behavior

Нет отдельной диагностики выбранного data vault и отличия от source repository. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Read-only zt-vault path/status/check показывает область данных и ошибки структуры без скрытого создания или переноса.

## What Changes

- `VAULT-001`: Выбранный корень прозрачен.
- `VAULT-002`: Check использует выбранную область.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `vault-inspection`: Явное разрешение и диагностика Vault.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P3`.
- Baseline traceability: `PATH-001`, `PATH-008`, `LIB-005`, `CHECK-001`, `ARCH-001`.
- IDs этой дельты: `VAULT-001`, `VAULT-002`.
- Польза сейчас: Read-only zt-vault path/status/check показывает область данных и ошибки структуры без скрытого создания или переноса.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `strengthen-document-integrity-checks`.
- `validate-diary-and-memo-chains`.

## Verification

Primary test: `tests/zt-add-vault-inspection.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
