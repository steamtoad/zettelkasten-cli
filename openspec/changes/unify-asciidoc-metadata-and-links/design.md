# Design: Общий разбор AsciiDoc и безопасное редактирование связей

## Context

Metadata/header readers и block parsing расходятся. Link dedup учитывает примеры; удаление bullet может уничтожить авторскую фразу. Основание: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc` (G04, G05). Это целевой контракт, а не заявление об устранённом дефекте.

## Goals / Non-Goals

Цель: Все операции одинаково видят header, рабочие ссылки и opaque-блоки и меняют только явно управляемые связи.
Вне scope: Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения. Не выполняются несвязанные cleanup, смена языка и обязательная БД.

## Decisions

### 1. Решение

Общий parser находится в neutral lib и не зависит от объектов или plugins. Команды используют его через стабильные shell helpers; policy выбора Topic остаётся в workflow.

### 2. Решение

Поддерживаемые непрозрачные блоки: парные standalone delimiters ----, ...., ____, ****, ====, ++++, //// длиной не менее четырёх одинаковых знаков и Markdown fences ``` с совпадающим закрытием. Неподдержанный или незакрытый блок при mutation даёт ошибку, не эвристическую правку.

### 3. Решение

Header завершается первой пустой/whitespace-only строкой или началом body; атрибуты после этого не управляют type/deprecated. Link target разрешается относительно source; :doclink: считается self-metadata, а не binding.

### 4. Решение

Изоляция opaque examples — сознательный совместимый профиль проекта, не заявление о поддержке всего AsciiDoc. Явные рабочие ссылки вне управляемого раздела показываются, но автоматическое удаление авторского текста запрещено.

## Dependencies and Composition

- `fix-atomic-document-writes`.

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
