# Design: Принадлежность линии и явные связи Topic

## Context

DATA-004 про явно связанные документы читается как область Reduce, хотя REDUCE-003/006 выбирают по key-topic. DEPR-008 запрещает неявно обеспечивать глобальную уникальность Topic. Основание: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc` (G10, G02). Это целевой контракт, а не заявление об устранённом дефекте.

## Goals / Non-Goals

Цель: Разделить тематическую принадлежность по key-topic и навигационное агрегирование по links, сохранив текущую область Reduce и допустимость нескольких активных Topic.
Вне scope: Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения. Не выполняются несвязанные cleanup, смена языка и обязательная БД.

## Decisions

### 1. Решение

Несколько активных Topic одного key-topic допускаются baseline. Checker выдаёт предупреждение AMBIGUOUS_TOPIC_LINE, а не произвольное новое нарушение схемы.

### 2. Решение

Reduce выбранной Topic охватывает Memo/Note точного ключа, включая явно не связанные, но не архивирует sibling Topic. Preview показывает весь набор и sibling Topics; существующее подтверждение охватывает этот явный список.

### 3. Решение

Новые интерактивные bindings всегда требуют явного выбора конкретной Topic при нескольких кандидатах. Semantic migration не выполняется автоматически. Refine сохраняет выборочное архивирование по REFINE-011, включая невыбранные Note.

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
