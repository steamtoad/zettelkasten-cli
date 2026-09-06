## Context

См. мотивацию в `proposal.md`. Сейчас `.scripts/zt-inbox.zsh` и `.scripts/zt-processed.zsh` одновременно являются публичными командами и содержат реализацию workflow. Репозиторий уже разделяет neutral engine (`.scripts/lib/`, `.scripts/objects/`), Zettelkasten plugin (`.scripts/zettelkasten/`) и host compatibility entrypoints (`.scripts/zt-*.zsh`), а `ARCH-015` допускает дополнительные plugin layers.

Inbox хранит неперсистентные capture artifacts отдельно от document model в `ZK_HOME/inbox/{raw,processed}`. Поэтому архитектурное выделение должно быть code-only переходом: без обхода реального Vault, изменения формата или переноса данных. Нормативные границы заданы `specs/inbox-plugin-architecture/spec.md`; существующий behavior contract остаётся в capability `inbox` (`INBOX-001`–`INBOX-012`).

## Goals / Non-Goals

**Goals:**

- создать однозначное каноническое место для Inbox implementation, tests и plugin-specific documentation;
- оставить top-level команды стабильной поверхностью для пользователей и managed operational skills;
- сделать dependency direction проверяемым статически;
- провести переход одним совместимым изменением без промежуточной миграции данных.

**Non-Goals:**

- вводить универсальный plugin loader, runtime discovery или packaging framework;
- включать Inbox в ownership Zettelkasten plugin;
- реализовывать ROADMAP import в Note, Memo или `all-todays`;
- изменять persistent objects, UUID/link semantics или Git workflow пользователя.

## Decisions

### 1. Inbox plugin является sibling directory `.scripts/inbox/`

Канонические workflow размещаются как `.scripts/inbox/capture.zsh` и `.scripts/inbox/processed.zsh`; plugin-specific traceability и feature documentation размещаются в `.scripts/inbox/docs/requirements.adoc` и `.scripts/inbox/docs/features.adoc`. Общие primitive извлекаются в `.scripts/lib/` только если они действительно domain-neutral.

Это сохраняет принятую файловую архитектуру и делает ownership видимым без нового runtime abstraction. Альтернатива разместить Inbox под `.scripts/zettelkasten/inbox/` отклонена: capture queue не принадлежит persistent Zettelkasten document model и создала бы запрещённую связь. Отдельный repository/package отклонён как ненужная операционная граница для двух тесно связанных CLI workflow.

### 2. Top-level scripts становятся тонкими compatibility entrypoints

`.scripts/zt-inbox.zsh` и `.scripts/zt-processed.zsh` определяют путь относительно собственного location и передают все аргументы каноническому plugin script через `exec`. Это сохраняет signals, exit status и потоковый вывод, одновременно исключая дублирование реализации.

Альтернатива заменить публичные пути на `.scripts/inbox/*` отклонена как breaking change для пользователей и managed skills. Source-based delegation отклонена: она смешивает shell scopes и повышает риск отличий в `$0`, options и exit behavior.

### 3. Поведенческая совместимость проверяется через публичную поверхность

Основной regression test — `tests/zt-inbox-as-plugin.zsh`. Он вызывает только top-level entrypoints с временным `ZK_HOME` и фиксирует существующие сценарии capture/processed: создание каталогов, имя и содержимое item, collision handling, editor arguments, path/symlink safety, same-filesystem hard-link move и сохранение source при ошибке destination.

Дополнительная structural проверка подтверждает, что wrappers не содержат второй реализации, канонические scripts находятся в `.scripts/inbox/`, а запрещённые cross-layer references отсутствуют. Прямые тесты только внутренних scripts не считаются достаточными, потому что не защищают compatibility surface.

### 4. Data layout и ROADMAP status не меняются

Plugin продолжает вычислять пути от `ZK_HOME` и использовать `inbox/raw` и `inbox/processed`. Установка не запускает migration hook и не сканирует эти каталоги. Legacy traceability переносит ownership актуальных Inbox requirements в plugin documentation без изменения стабильных IDs или статуса; `INBOX-003` и `INBOX-006` остаются ROADMAP до отдельного изменения, реализующего import.

Альтернатива одновременно перенести queue под plugin-owned data directory отклонена: она смешала бы архитектурный refactor с data migration и сломала бы `PATH-008`.

## Risks / Trade-offs

- [Wrapper может изменить quoting, signal или exit semantics] → использовать `exec` с `"$@"` и проверять parity через публичные entrypoints.
- [Требования окажутся продублированы в host и plugin documentation] → определить `.scripts/inbox/docs/requirements.adoc` как единственный plugin-specific legacy traceability source и обновить агрегирующие ссылки вместо копирования IDs.
- [Boundary check даст ложные совпадения по документации или fixtures] → ограничить source-reference проверку исполняемыми Zsh files и отдельно проверять документированные paths.
- [Одновременный перенос двух workflow увеличивает diff] → выполнять capture и processed по отдельным task checkpoints, но переключать wrappers лишь после прохождения общей parity проверки.
- [Новый layer добавляет файловую структуру без loader abstraction] → принять явную простоту; loader вводится только отдельным change при появлении нескольких runtime-discoverable plugins.

## Migration Plan

1. Добавить regression test, фиксирующий текущее поведение top-level Inbox commands во временном `ZK_HOME`.
2. Создать `.scripts/inbox/`, перенести туда канонические capture/processed workflow и plugin-specific documentation без изменения behavior или data paths.
3. Превратить top-level scripts в `exec` wrappers, сохранив permissions, arguments и managed skill mapping.
4. Обновить Feature List, legacy traceability и repository boundary checks; не повышать статус ROADMAP import.
5. Выполнить Zsh syntax checks, Inbox regression test, OpenSpec validation и repository validation.

Переход не требует user-data migration и поэтому не имеет data rollback. До release кодовый rollback состоит в возврате реализаций в top-level scripts; после release предпочтителен forward fix wrappers/plugin, поскольку публичные пути и data layout не меняются. Ни rollback, ни recovery не должны выполнять операции над реальным `ZK_HOME`.
