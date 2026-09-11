# Design: Безопасная запись файлов и достоверные ошибки

## Context

zk_append_related_link обнуляет цель до завершения cat; Reduce игнорирует ошибки связывания. Проверка существования перед create не исключает гонку. Основание: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc` (G01, G04). Это целевой контракт, а не заявление об устранённом дефекте.

## Goals / Non-Goals

Цель: Не терять прежнее содержимое при ошибке одиночной записи; не продолжать Reduce после ошибки; атомарно резервировать новый файл.
Вне scope: Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения. Не выполняются несвязанные cleanup, смена языка и обязательная БД.

## Decisions

### 1. Решение

Подготовленный файл создаётся рядом с целью; проверяются запись, закрытие и замена. Сохраняются mode, буквальное содержимое и явно поддержанные filesystem-свойства; unsupported ownership/ACL policy диагностируется до replace.

### 2. Решение

Это локальный патч. Он не обещает атомарную многофайловую транзакцию; add-recoverable-workflow-transactions закрывает частично выполненный workflow.

### 3. Решение

Для нового объекта используется exclusive create, аналогичный существующему Inbox O_EXCL. Symlink назначения не обходится для записи вне выбранной области.

## Dependencies and Composition

- Нет обязательного предшествующего нового Change.

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
