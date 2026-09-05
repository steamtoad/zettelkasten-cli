# Идемпотентное исправление завершающего LF

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G09. Command substitution удаляет LF из tail output; каждый запуск scripts-patch дописывает байт в уже корректный файл.

## Current Behavior

Command substitution удаляет LF из tail output; каждый запуск scripts-patch дописывает байт в уже корректный файл. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Проверять реальный последний байт, дописывать только отсутствующий LF и сохранять корректные файлы побайтно.

## What Changes

- `CHECK-006`: zt-scripts-patch исправляет отсутствие завершающего LF.
- `SCRIPT-FORMAT-001`: Проверка формата отделена от исправления.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `script-formatting`: Идемпотентное исправление завершающего LF.

### Modified Capabilities

- `validation`: уточнение связанных baseline contracts.

## Impact

- Уровень repository change: `L1`; приоритет `P1`.
- Baseline traceability: `STYLE-003`, `CHECK-006`.
- IDs этой дельты: `CHECK-006`, `SCRIPT-FORMAT-001`.
- Польза сейчас: Проверять реальный последний байт, дописывать только отсутствующий LF и сохранять корректные файлы побайтно.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- Нет обязательного предшествующего нового Change.

## Verification

Primary test: `tests/zt-fix-script-ending-idempotency.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
