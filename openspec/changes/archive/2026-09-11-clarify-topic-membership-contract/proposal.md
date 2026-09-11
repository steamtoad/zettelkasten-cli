# Принадлежность линии и явные связи Topic

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G10 / G02. DATA-004 про явно связанные документы читается как область Reduce, хотя REDUCE-003/006 выбирают по key-topic. DEPR-008 запрещает неявно обеспечивать глобальную уникальность Topic.

## Current Behavior

DATA-004 про явно связанные документы читается как область Reduce, хотя REDUCE-003/006 выбирают по key-topic. DEPR-008 запрещает неявно обеспечивать глобальную уникальность Topic. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Разделить тематическую принадлежность по key-topic и навигационное агрегирование по links, сохранив текущую область Reduce и допустимость нескольких активных Topic.

## What Changes

- `DATA-004`: Topic агрегирует только явно связанные с ней Memo и Note.
- `TOPIC-MEMBER-001`: Неоднозначность линии диагностируется без нормализации.
- `TOPIC-MEMBER-002`: История и активная принадлежность не смешиваются.
- `TOPIC-MEMBER-003`: Refine сохраняет отличающийся lifecycle.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `topic-membership`: Принадлежность линии и явные связи Topic.

### Modified Capabilities

- `document-paths`: уточнение связанных baseline contracts.

## Impact

- Уровень repository change: `L3`; приоритет `P1`.
- Baseline traceability: `DATA-004`, `TOPIC-001`, `BIND-003`, `REDUCE-003`, `REDUCE-006`, `REDUCE-008`, `DEPR-008`, `REFINE-011`.
- IDs этой дельты: `DATA-004`, `TOPIC-MEMBER-001`, `TOPIC-MEMBER-002`, `TOPIC-MEMBER-003`.
- Польза сейчас: Разделить тематическую принадлежность по key-topic и навигационное агрегирование по links, сохранив текущую область Reduce и допустимость нескольких активных Topic.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- Нет обязательного предшествующего нового Change.

## Verification

Primary test: `tests/zt-clarify-topic-membership-contract.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
