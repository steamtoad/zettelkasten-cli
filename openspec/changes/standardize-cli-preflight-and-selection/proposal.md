# Общие ошибки CLI, выбор и пути

## Why

Источник: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc`, G04 / G05 / G07 / G11. Отсутствующий fzf маскируется под cancel, цели после выбора не проверяются, Inbox имеет иной root fallback, editor проверяется поздно.

## Current Behavior

До этого Change отсутствующий fzf маскировался под cancel, а цели после выбора не проверялись. Inbox editor preflight уже согласован отдельным зависимым Change; root fallback сохраняется и унифицируется по приоритету `ZK_HOME`. Реализация сверяется с baseline; вывод аудита не заменяет действующий contract при расхождении.

## Desired Behavior

Единый preflight и selector contract без потери действующего поиска, Vim и совместимых путей.

## What Changes

- `CLI-PREFLIGHT-001`: Зависимости проверяются до записи.
- `CLI-PREFLIGHT-002`: Отмена и повторная проверка выбора.
- `CLI-PREFLIGHT-003`: Пути и формат выбора совместимы.
- `CLI-PREFLIGHT-004`: Повтор processed восстанавливает только доказанный перенос.
- `FZF-002`: поиск и интерактивный выбор используют :description:.

## Non-Goals

Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения.
Подготовка Change изменяет только OpenSpec artifacts. Функции вне перечисленных требований не добавляются молча; другие уровни исправления вынесены в отдельные changes.

## Capabilities

### New Capabilities

- `cli-consistency`: Общие ошибки CLI, выбор и пути.

### Modified Capabilities

- `search`: уточнение связанных baseline contracts.

## Impact

- Уровень repository change: `L2`; приоритет `P1`.
- Baseline traceability: `FZF-001`, `FZF-002`, `FZF-003`, `FZF-006`, `LIB-005`, `LIB-006`, `STYLE-007`, `INBOX-008`, `INBOX-011`.
- IDs этой дельты: `CLI-PREFLIGHT-001`, `CLI-PREFLIGHT-002`, `CLI-PREFLIGHT-003`, `CLI-PREFLIGHT-004`, `FZF-002`.
- Польза сейчас: Единый preflight и selector contract без потери действующего поиска, Vim и совместимых путей.
- Совместимость: AsciiDoc, пять базовых типов, UUID v1, существующие имена/links и явные действия сохраняются; конкретные усиления preflight/output описаны в design и scenarios.
- Польза будущей архитектуре: проверяемый контракт, пригодный для общего CLI и существующих plugin boundaries.
- User-data: реализация и tests работают с временным ZK_HOME; фактическая миграция/публикация требует отдельного runtime поручения.
- Destructive impact: изменение алгоритмов записи не разрешает автоматически применять их к реальному Vault.
- Статусы: `PROPOSED`; baseline и legacy status не повышаются в этой specification-only задаче.

## Dependencies

- `fix-atomic-document-writes`.
- `unify-asciidoc-metadata-and-links`.
- `preflight-inbox-editor-before-capture`.

## Verification

Primary test: `tests/zt-standardize-cli-preflight-and-selection.zsh`. Проверяются observable outputs, exit, side effects и отрицательные сценарии из specs. Textual ID/Scenario checks не заменяют этот тест.
