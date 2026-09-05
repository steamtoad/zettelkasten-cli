# Производный файловый индекс и измеряемый поиск

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 — плановое развитие, не исправление аварии. find/read вызывают дополнительные процессы для каждого файла, persistent rebuildable index отсутствует; два единичных замера не задают performance budget.

## Current Behavior

find/read вызывают дополнительные процессы для каждого файла, persistent rebuildable index отсутствует; два единичных замера не задают performance budget. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Пакетный scan и необязательный пересоздаваемый индекс с полной семантической совместимостью файлового backend.

## What Changes

- `FILE-INDEX-001`: Rebuild полностью выводится из исходных файлов.
- `FILE-INDEX-002`: Отсутствие или устаревание cache не меняет выдачу.
- `FILE-INDEX-003`: Индекс диагностируется отдельно от источника.
- `FILE-INDEX-004`: Оптимизация подтверждается семантикой и измерениями.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `file-index`: Производный файловый индекс и измеряемый поиск.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P2`.
- Baseline traceability: `INDEX-001`, `INDEX-002`, `INDEX-003`, `INDEX-005`, `INDEX-006`, `INDEX-009`, `DEPR-003`, `FZF-002`.
- IDs этой дельты: `FILE-INDEX-001`, `FILE-INDEX-002`, `FILE-INDEX-003`, `FILE-INDEX-004`.
- Польза сейчас: Пакетный scan и необязательный пересоздаваемый индекс с полной семантической совместимостью файлового backend.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `unify-asciidoc-metadata-and-links`.
- `strengthen-document-integrity-checks`.
- `standardize-cli-preflight-and-selection`.

## Verification

Primary test: `tests/zt-add-rebuildable-file-index.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
