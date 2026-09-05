# Проверяемая публичная поставка и первое использование

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G07. Публичный suite требует отсутствующие личные файлы. README не обеспечивает воспроизводимый bootstrap; runtime skills и Detailed Notes внешние.

## Current Behavior

Публичный suite требует отсутствующие личные файлы. README не обеспечивает воспроизводимый bootstrap; runtime skills и Detailed Notes внешние. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Чистые Git checkout и ZIP проходят portable checks; новый пользователь получает документированный путь до первой заметки без agent state автора.

## What Changes

- `DIST-001`: Публичный тест не требует личного окружения.
- `DIST-002`: Bootstrap воспроизводится из README.
- `DIST-003`: Runtime integration устанавливается и проверяется отдельно.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `distribution-readiness`: Проверяемая публичная поставка и первое использование.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L2`; приоритет `P1`.
- Baseline traceability: `PUB-005`, `PUB-006`, `PUB-024`, `DEVAGENT-001`, `CHECK-008`, `ARCH-011`.
- IDs этой дельты: `DIST-001`, `DIST-002`, `DIST-003`.
- Польза сейчас: Чистые Git checkout и ZIP проходят portable checks; новый пользователь получает документированный путь до первой заметки без agent state автора.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `validate-diary-and-memo-chains`.

## Verification

Primary test: `tests/zt-make-public-distribution-reproducible.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
