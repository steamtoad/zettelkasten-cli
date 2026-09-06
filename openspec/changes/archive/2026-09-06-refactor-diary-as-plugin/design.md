## Context

См. мотивацию в `proposal.md`. Сегодня top-level `.scripts/zt-diary.zsh` делегирует `.scripts/zettelkasten/zt-diary.zsh`. Workflow использует neutral constructor `.scripts/objects/diary-create.zsh`, Zettelkasten helper `lib/today.zsh`, корневой state `.last-diary`, изменяет предыдущий и новый Diary и затем открывает новый документ в Vim.

В отличие от Inbox, Diary является persistent document type и участвует в общих contracts `notes/`, canonical links и `all-todays`. Поэтому выделение меняет ownership, но не отделяет Diary от единой document model. Нормативная целевая граница описана в `specs/diary-plugin-architecture/spec.md`; behavioral contracts `ZP-DIARY-001`–`ZP-DIARY-005` остаются без изменения.

## Goals / Non-Goals

**Goals:**

- дать Diary самостоятельную code/documentation/test boundary;
- сохранить top-level command и точный порядок наблюдаемых Diary side effects;
- исключить source dependency Diary plugin на Zettelkasten plugin;
- оставить constructors и domain-neutral primitives общими для всех plugin layers.

**Non-Goals:**

- отделять Diary documents в другой storage namespace или repository;
- менять chain representation, state format или `all-todays` format;
- исправлять существующую transactionality chain workflow сверх действующих contracts;
- вводить универсальный plugin loader или общий inter-plugin service framework.

## Decisions

### 1. Канонический workflow размещается в `.scripts/diary/zt-diary.zsh`

Diary plugin получает собственные `.scripts/diary/zt-diary.zsh`, `.scripts/diary/lib/` и `.scripts/diary/docs/`. Он source'ит neutral `paths.zsh`, `asciidoc.zsh` и `objects/diary-create.zsh`, но не файлы `.scripts/zettelkasten/`.

Имя `zt-diary.zsh` внутри plugin сохраняет узнаваемость существующих workflow paths; plugin boundary задаётся каталогом. Альтернатива `.scripts/zettelkasten/diary/` отклонена, поскольку не меняет ownership. Отдельный repository/package отклонён: Diary разделяет object model, validation и release lifecycle с `zettelkasten-cli`.

### 2. Diary plugin самостоятельно реализует Diary-specific регистрацию в `all-todays`

Текущий `zt_today_append` принадлежит `.scripts/zettelkasten/lib/today.zsh`, поэтому direct reuse создал бы запрещённую dependency. Diary plugin получает узкий Diary-specific helper под `.scripts/diary/lib/`, который воспроизводит существующий внешний `all-todays` contract с помощью neutral path/file primitives. Общий Zettelkasten helper остаётся для Note, Memo, Topic и Todo.

Небольшое дублирование policy принято ради независимости plugin boundaries. Перенос `all-todays` в `.scripts/lib/` отклонён: это Zettelkasten storage policy, а не domain-neutral primitive. Выделение `all-todays` в третий plugin или dependency injection отклонено как несоразмерное расширение текущего change.

### 3. Top-level wrapper переключается непосредственно на Diary plugin

`.scripts/zt-diary.zsh` остаётся executable thin wrapper и выполняет `exec "$script_dir/diary/zt-diary.zsh" "$@"`. Промежуточный `.scripts/zettelkasten/zt-diary.zsh` удаляется после переключения и прохождения parity test, чтобы не оставлять ложного ownership или двойной канонической реализации.

Альтернатива оставить forwarding stub внутри `.scripts/zettelkasten/` отклонена: это сохранило бы ненужную транзитивную границу и противоречило бы `ZP-ARCH-004`. Замена публичного пути отклонена как breaking change для alias и managed skill.

### 4. Existing behavior фиксируется до переноса

Основной regression test `tests/zt-diary-as-plugin.zsh` сначала фиксирует текущее поведение через top-level entrypoint во временном `ZK_HOME`, подменяя editor и детерминируя внешние команды там, где нужно. После переноса тот же test проверяет UUID/metadata, `notes/`, `.last-diary`, previous/next links, `all-todays`, invalid state rejection, failure ordering, Vim argument, output link и exit status.

Structural assertions дополнительно проверяют direct delegation, отсутствие старого workflow под `.scripts/zettelkasten/`, plugin docs и запрещённых source references. `tests/zt-runtime-core.zsh` продолжает защищать neutral Diary constructor и общий document model.

### 5. Traceability переходит к Diary plugin без смены stable IDs

`ZP-DIARY-001`–`ZP-DIARY-005` перемещаются из `.scripts/zettelkasten/docs/requirements.adoc` в `.scripts/diary/docs/requirements.adoc` как единый legacy traceability source. Feature `ZP-FEATURE-005` аналогично перестаёт заявляться как Zettelkasten-plugin feature и документируется в Diary plugin; агрегирующая Feature List продолжает показывать Diary как функцию продукта.

Stable IDs не переименовываются: префикс `ZP-` является историческим идентификатором, а не разрешением на дублирование или создание новых эквивалентных IDs. Альтернатива заменить их на `DP-*` отклонена политикой stable traceability; новые `DP-*` используются только для новых архитектурных contracts.

## Risks / Trade-offs

- [Diary-specific `all-todays` helper разойдётся с Zettelkasten helper] → parity test фиксирует одинаковый формат; дальнейшее изменение общего внешнего contract должно обновлять оба plugin workflow в одной спецификации либо выделить отдельную capability.
- [Изменится порядок partial side effects при ошибке] → переносить workflow механически и тестировать `.last-diary`/chain state на каждом failure checkpoint без скрытого transactional redesign.
- [Удаление старого plugin path сломает внутренние непубличные вызовы] → `rg`-проверка всех repository references и сохранение только документированного top-level public entrypoint.
- [Traceability ID окажется одновременно в двух legacy documents] → удалить Diary section из Zettelkasten source и запустить exact-once OpenSpec/legacy check.
- [Проверка случайно изменит настоящий Vault] → каждый integration scenario создаёт временный `ZK_HOME`; команды без явно установленного test home считаются failure.

## Migration Plan

1. Добавить `tests/zt-diary-as-plugin.zsh` и подтвердить behavioral часть на текущем top-level workflow.
2. Создать `.scripts/diary/` с workflow, Diary-specific `all-todays` helper и документацией, сохранив точный side-effect order.
3. Переключить `.scripts/zt-diary.zsh` напрямую на новый plugin и удалить `.scripts/zettelkasten/zt-diary.zsh` после прохождения parity test.
4. Синхронизировать architecture/Feature List/legacy traceability и boundary checks без переименования stable IDs или managed skill.
5. Выполнить syntax, focused regression, repository и OpenSpec validation во временном окружении.

User-data migration отсутствует: installation не сканирует и не изменяет `notes/`, `all-todays/` или `.last-diary`. До release rollback возвращает workflow и wrapper destination в `.scripts/zettelkasten/`; после release предпочтителен forward fix. Оба пути являются code rollback и не выполняют recovery/mutation пользовательского Vault или Git history.
