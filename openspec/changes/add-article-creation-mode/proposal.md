# Article как режим Note без нового domain type

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 — плановое развитие, не исправление аварии. zcreate article находится в исходном плане, но article не входит в пять постоянных типов и не имеет модели.

## Current Behavior

zcreate article находится в исходном плане, но article не входит в пять постоянных типов и не имеет модели. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Определить article как явный шаблонный режим создания Note с дополнительным признаком, сохранив canonical type list.

## What Changes

- `ARTICLE-001`: Article сохраняет модель Note.
- `ARTICLE-002`: Режим не меняет lifecycle существующих документов.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `article-mode`: Article как режим Note без нового domain type.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L4`; приоритет `P3`.
- Baseline traceability: `ARCH-007`, `DOC-003`, `DOC-006`, `ARCH-006`, `DEPR-005`.
- IDs этой дельты: `ARTICLE-001`, `ARTICLE-002`.
- Польза сейчас: Определить article как явный шаблонный режим создания Note с дополнительным признаком, сохранив canonical type list.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `add-zcreate-workflow`.

## Verification

Primary test: `tests/zt-add-article-creation-mode.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
