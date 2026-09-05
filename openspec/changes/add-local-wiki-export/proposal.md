# Производная локальная wiki из AsciiDoc

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 — плановое развитие, не исправление аварии. zt-wiki отсутствует; нет формального безопасного контракта для производного просмотра знаний.

## Current Behavior

zt-wiki отсутствует; нет формального безопасного контракта для производного просмотра знаний. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Опционально экспортировать локальный HTML-view без превращения его в source of truth и без публикации.

## What Changes

- `WIKI-001`: Экспорт остаётся производным и локальным.
- `WIKI-002`: Ссылки и deprecation не расширяют область.
- `WIKI-003`: Чужой output не уничтожается.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `local-wiki-export`: Производная локальная wiki из AsciiDoc.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P3`.
- Baseline traceability: `DOC-001`, `PATH-002`, `DEPR-003`, `ARCH-002`, `ARCH-003`.
- IDs этой дельты: `WIKI-001`, `WIKI-002`, `WIKI-003`.
- Польза сейчас: Опционально экспортировать локальный HTML-view без превращения его в source of truth и без публикации.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `unify-asciidoc-metadata-and-links`.
- `strengthen-document-integrity-checks`.

## Verification

Primary test: `tests/zt-add-local-wiki-export.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
