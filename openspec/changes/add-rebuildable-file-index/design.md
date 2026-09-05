# Design: Производный файловый индекс и измеряемый поиск

## Context

find/read вызывают дополнительные процессы для каждого файла, persistent rebuildable index отсутствует; два единичных замера не задают performance budget. Основание: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc` (G12). Это целевой контракт, а не заявление об устранённом дефекте.

## Goals / Non-Goals

Цель: Пакетный scan и необязательный пересоздаваемый индекс с полной семантической совместимостью файлового backend.
Вне scope: Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения. Не выполняются несвязанные cleanup, смена языка и обязательная БД.

## Decisions

### 1. Решение

Первый backend — текстовые derived artifacts в .state/index с schema version, generation ID и source fingerprints. Не вводится обязательная SQLite; прежние SQLite ROADMAP contracts остаются optional future backend.

### 2. Решение

Индекс включает basename, type, description, deprecated, date, keywords и fingerprint; encoding обязан round-trip Unicode, separators и backslashes. Canonical knowledge остаётся только в AsciiDoc.

### 3. Решение

Metadata cache не заменяет full-text find/read. Полнота body-search проверяется отдельно; если cache не может подтвердить актуальность, используется source scan.

### 4. Решение

Измерения: 100/1000/10000 синтетических документов, не менее пяти прогонов каждого workload; отдельные warm/cold measurements, medians и environment. Решение о cache фиксирует улучшение относительно прямого пакетного scan, без универсального обещания секунд.

## Dependencies and Composition

- `unify-asciidoc-metadata-and-links`.
- `strengthen-document-integrity-checks`.
- `standardize-cli-preflight-and-selection`.

Новые требования принадлежат только этому Change. Полные MODIFIED blocks используют точное baseline имя и stable ID. Перед интеграцией сверяются current baseline и связанные changes; при изменении одного ID выполняется явное объединение, не last-writer-wins.
Существующие `refactor-diary-as-plugin`, `refactor-inbox-as-plugin`, `refactor-workspace-as-plugin`, `add-knowledge-plugin` и `add-openspec-archive-contract` сохраняют своих владельцев. Разделение plugin directories не является предпосылкой локального исправления безопасности; после relocation применяются те же поведенческие контракты.

## Compatibility and Migration

Существующие UUID не переименовываются. Усиленный checker работает read-only и сообщает о старых некорректных данных, не нормализует их. Для несовместимых входных данных показывается диагностика; изменения пользовательских данных выполняются только отдельной проверяемой миграцией.
Все тестовые документы синтетические и находятся во временном ZK_HOME. Root paths с пробелами/Unicode, Unix mode и macOS/Linux differences включаются в проверки там, где scope связан с файловыми операциями.

## Failure, Rollback and Git Safety

Read-only и dry-run paths не создают knowledge side effects. Для mutation steps ошибка не маскируется финальным stdout. File writes используют scoped safe primitives; многофайловое восстановление — отдельный workflow-transactions contract после его внедрения. Если восстановление не доказано, сохраняются backup и ненулевой статус.
Implementation не выполняет commit/tag/push, destructive reset или очистку чужих изменений. Публикация или data migration из тестов возможна только между temporary fixtures.

## Alternatives

- Оставить исправление в инструкции агенту: отклонено, поскольку гарантия должна проверяться на CLI и не зависеть от личного окружения.
- Одновременно перенести все plugins и переписать shell stack: отклонено как ненужное расширение scope и риск для совместимости.
- Считать наличие Requirement/Scenario достаточной проверкой: отклонено; необходимы конкретные outputs/bytes/exit assertions.

## Baseline Integration

До реализации IDs зарезервированы только в active delta. После исполнения tasks новые IDs добавляются exact-once в соответствующую legacy группу с подтверждённым IMPLEMENTED/INVARIANT/PROCESS статусом; прежние ROADMAP не повышаются без полного evidence.
Затем синхронизируется полный применимый delta в baseline, проверяются legacy parity, Feature List и OpenSpec; archive выполняется только по отдельному действующему governance workflow. Подготовка этих artifacts ничего не архивирует.
