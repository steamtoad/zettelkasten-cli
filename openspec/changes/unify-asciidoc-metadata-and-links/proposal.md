# Общий разбор AsciiDoc и безопасное редактирование связей

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G04 / G05. Metadata/header readers и block parsing расходятся. Link dedup учитывает примеры; удаление bullet может уничтожить авторскую фразу.

## Current Behavior

Metadata/header readers и block parsing расходятся. Link dedup учитывает примеры; удаление bullet может уничтожить авторскую фразу. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Все операции одинаково видят header, рабочие ссылки и opaque-блоки и меняют только явно управляемые связи.

## What Changes

- `ADOC-PARSE-001`: Одинаковый header во всех потребителях.
- `ADOC-PARSE-002`: Примеры не являются рабочими связями.
- `ADOC-PARSE-003`: Удаление связи сохраняет авторский текст.
- `ADOC-PARSE-004`: Конструкторы используют общий нейтральный writer.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `asciidoc-parsing`: Общий разбор AsciiDoc и безопасное редактирование связей.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L2`; приоритет `P1`.
- Baseline traceability: `DOC-009`, `LINK-001`, `LINK-002`, `CHECK-003`, `CHECK-022`, `LIB-001`, `REFINE-012`, `WORKSPACE-014`.
- IDs этой дельты: `ADOC-PARSE-001`, `ADOC-PARSE-002`, `ADOC-PARSE-003`, `ADOC-PARSE-004`.
- Польза сейчас: Все операции одинаково видят header, рабочие ссылки и opaque-блоки и меняют только явно управляемые связи.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `fix-atomic-document-writes`.

## Verification

Primary test: `tests/zt-unify-asciidoc-metadata-and-links.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
