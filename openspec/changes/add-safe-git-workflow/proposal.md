# Явный безопасный Git workflow

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G12 / G08. Git хранит историю, но нет CLI preflight конфликтов и безопасного sync; publisher не является Git update.

## Current Behavior

Git хранит историю, но нет CLI preflight конфликтов и безопасного sync; publisher не является Git update. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Дать read-only status/conflicts и явный fast-forward sync без уничтожения локальных изменений.

## What Changes

- `ZT-GIT-001`: Локальный preflight сообщает состояние.
- `ZT-GIT-002`: Sync допускает только безопасный fast-forward.
- `ZT-GIT-003`: Конфликты AsciiDoc разрешает пользователь.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `git-workflow`: Явный безопасный Git workflow.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L3`; приоритет `P3`.
- Baseline traceability: `ARCH-001`, `SAFE-001`, `SAFE-004`, `MIGR-005`, `PUB-016`.
- IDs этой дельты: `ZT-GIT-001`, `ZT-GIT-002`, `ZT-GIT-003`.
- Польза сейчас: Дать read-only status/conflicts и явный fast-forward sync без уничтожения локальных изменений.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `add-runtime-regression-release-gates`.

## Verification

Primary test: `tests/zt-add-safe-git-workflow.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
