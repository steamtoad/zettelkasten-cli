# Полная проверка схемы постоянных документов

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G02 / G04. zt-check пропускает пустые файлы, дубли атрибутов, неверные даты и UUID; constructors принимают многострочные поля.

## Current Behavior

zt-check пропускает пустые файлы, дубли атрибутов, неверные даты и UUID; constructors принимают многострочные поля. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Каждый постоянный документ получает независимую проверку схемы, UUID и metadata; некорректный ввод отклоняется до создания.

## What Changes

- `INTEGRITY-001`: Каждый файл получает проверку даже при отсутствии строк.
- `INTEGRITY-002`: UUID v1 проверяется при генерации и диагностике.
- `INTEGRITY-003`: Однострочные поля проверяются до записи.
- `INTEGRITY-004`: Topic и self-link проверяются семантически.
- `CHECK-011`: UUID v1 нового постоянного документа проверяется отдельно, поскольку текущий zt-check не пров....
- `CHECK-017`: подтверждается проверка canonical metadata активной Topic.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `document-integrity`: Полная проверка схемы постоянных документов.

### Modified Capabilities

- `validation`: уточнение связанных baseline contracts.

## Impact

- Уровень repository change: `L3`; приоритет `P0`.
- Baseline traceability: `DOC-002`, `DOC-003`, `DOC-009`, `UUID-001`, `CHECK-002`, `CHECK-011`, `CHECK-017`.
- IDs этой дельты: `INTEGRITY-001`, `INTEGRITY-002`, `INTEGRITY-003`, `INTEGRITY-004`, `CHECK-011`.
- Польза сейчас: Каждый постоянный документ получает независимую проверку схемы, UUID и metadata; некорректный ввод отклоняется до создания.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `fix-atomic-document-writes`.

## Verification

Primary test: `tests/zt-strengthen-document-integrity-checks.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
