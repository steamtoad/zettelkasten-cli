# Безопасное зеркало development-поставки

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G08. rsync --delete применяется без проверки равных/вложенных путей, dirty destination и изменения после просмотренного плана.

## Current Behavior

rsync --delete применяется без проверки равных/вложенных путей, dirty destination и изменения после просмотренного плана. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Сохранить явное exact mirror, но разрешать его только по актуальному плану с проверенными границами и восстановлением.

## What Changes

- `PUB-SAFE-001`: Preflight доказывает границы зеркала.
- `PUB-SAFE-002`: Локальные изменения назначения сохраняются.
- `PUB-SAFE-003`: Apply использует актуальный preview.
- `PUB-SAFE-004`: Ошибка зеркала не становится успешным релизом.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `publication-safety`: Безопасное зеркало development-поставки.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P1`.
- Baseline traceability: `PUB-004`, `PUB-007`, `PUB-008`, `PUB-010`, `PUB-016`, `PUB-023`, `PUB-025`.
- IDs этой дельты: `PUB-SAFE-001`, `PUB-SAFE-002`, `PUB-SAFE-003`, `PUB-SAFE-004`.
- Польза сейчас: Сохранить явное exact mirror, но разрешать его только по актуальному плану с проверенными границами и восстановлением.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `make-public-distribution-reproducible`.

## Verification

Primary test: `tests/zt-harden-publication-preflight.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
