# Design: Единая граница создания документов

## Context

Есть object constructors без полного workflow, но нет zcreate --no-edit для воспроизводимой автоматизации. Основание: `audit/2026-09-05/7b3fcec8-a907-11f1-8a46-53bdf0fb80b5.adoc` (G12). Это целевой контракт, а не заявление об устранённом дефекте.

## Goals / Non-Goals

Цель: Создавать пять существующих типов через один проверяемый workflow с activity, явными bindings, date и стабильным выводом.
Вне scope: Автоматическое изменение реального Vault, commit/tag/push и архивирование Change не входят в подготовку или реализацию без отдельного поручения. Не выполняются несвязанные cleanup, смена языка и обязательная БД.

## Decisions

### 1. Решение

Первый milestone — zcreate note|memo|todo|diary|topic, alias keytopic, --no-edit, --print-link. Следующие milestones в том же описанном контракте добавляют --date, --link/--keytopic, --template/--context; пакет не считается завершённым до проверенного согласованного scope всех флагов.

### 2. Решение

Публичный shell executable остаётся .scripts/zcreate.zsh; пользовательский alias zcreate документирован. Доменная orchestration живёт в существующем workflow слое, objects остаются нейтральными.

### 3. Решение

По умолчанию вывод успешного создания сохраняет одну AsciiDoc-ссылку; --print-link явно запрашивает тот же machine-clean stdout. Диагностика/preview уходят в stderr. UUID и текущая дата естественно новые: deterministic означает отсутствие скрытых prompts, а не одинаковый UUID при повторном запуске.

### 4. Решение

--link — явный basename родителя: для note это активный Memo, для memo активная Topic; для остальных типов неподдержанное сочетание отклоняется. --keytopic — basename конкретной активной Topic, не display string. Прямая Note→Topic разрешена только при явном --keytopic; прежний интерактивный Note→Memo default сохраняется.

### 5. Решение

Произвольные templates не выполняют shell или include. Шаблон предоставляет только body, не reserved metadata; context выбирает/показывает кандидатов и не создаёт связь без явного выбора. Agent-specific defaults остаются в external skill.

## Dependencies and Composition

- `strengthen-document-integrity-checks`.
- `add-recoverable-workflow-transactions`.
- `standardize-cli-preflight-and-selection`.
- `clarify-topic-membership-contract`.

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
