# Безопасная запись файлов и достоверные ошибки

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G01 / G04. zk_append_related_link обнуляет цель до завершения cat; Reduce игнорирует ошибки связывания. Проверка существования перед create не исключает гонку.

## Current Behavior

zk_append_related_link обнуляет цель до завершения cat; Reduce игнорирует ошибки связывания. Проверка существования перед create не исключает гонку. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Не терять прежнее содержимое при ошибке одиночной записи; не продолжать Reduce после ошибки; атомарно резервировать новый файл.

## What Changes

- `WRITE-SAFE-001`: Существующая цель сохраняется при неуспешной подготовке.
- `WRITE-SAFE-002`: Reduce прекращает выполнение при ошибке любой связи.
- `WRITE-SAFE-003`: Создание не перезаписывает коллизию.
- `WRITE-SAFE-004`: Ошибка записи передаётся через CLI.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `file-write-safety`: Безопасная запись файлов и достоверные ошибки.

### Modified Capabilities

Нет.

## Impact

- Уровень repository change: `L1`; приоритет `P0`.
- Baseline traceability: `SAFE-001`, `SAFE-002`, `STYLE-006`, `UUID-001`, `REDUCE-012`, `LINK-004`.
- IDs этой дельты: `WRITE-SAFE-001`, `WRITE-SAFE-002`, `WRITE-SAFE-003`, `WRITE-SAFE-004`.
- Польза сейчас: Не терять прежнее содержимое при ошибке одиночной записи; не продолжать Reduce после ошибки; атомарно резервировать новый файл.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- Нет обязательного предшествующего нового Change.

## Verification

Primary test: `tests/zt-fix-atomic-document-writes.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
