## Context

См. мотивацию в `proposal.md`. Сейчас четыре `.scripts/zt-workspace-*.zsh` содержат полные host workflows и source'ят `.scripts/zettelkasten/lib/workspace.zsh`. Library владеет вычислением `workspaces/`, safe filename, title/link formatting, preflight и `fzf` selection; create/add/open/remove orchestration остаётся в top-level scripts. Это переходное исключение явно зафиксировано `ARCH-019` и `ZP-WORKSPACE-002`.

Workspace — редактируемый агрегатор, а не persistent document: он хранится отдельно от `notes/`, не требует UUID/metadata и не должен изменять linked documents. Целевая boundary описана в `specs/workspace-plugin-architecture/spec.md`; product behavior остаётся заданным `WORKSPACE-001`–`WORKSPACE-014`.

## Goals / Non-Goals

**Goals:**

- собрать Workspace policy и четыре canonical workflows в одном plugin directory;
- сделать top-level scripts однородными compatibility wrappers;
- устранить переходную host dependency на Zettelkasten plugin library;
- сохранить интерактивный и файловый contracts без миграции Workspace data.

**Non-Goals:**

- превращать Workspace в persistent object или переносить его в `notes/`;
- менять пользовательский формат, selection UX или ручную редактируемость;
- вводить новый transaction/storage framework для Workspace;
- реорганизовывать Continue, Reduce, Refine или остальные переходные host dependencies.

## Decisions

### 1. Workspace plugin содержит workflows и собственную policy library

Целевая структура — `.scripts/workspace/zt-workspace-{create,add,open,remove}.zsh`, `.scripts/workspace/lib/workspace.zsh` и `.scripts/workspace/docs/`. Workflow используют plugin-local library и domain-neutral `.scripts/lib/paths.zsh`/`asciidoc.zsh`; `.scripts/objects/` не требуется, потому что Workspace не является persistent document.

Это переносит существующий код по ownership boundary без runtime abstraction. Альтернатива оставить library в `.scripts/zettelkasten/` отклонена как inter-plugin dependency. Перенос library в neutral `.scripts/lib/` отклонён: safe Workspace naming, `workspaces/` layout и `../notes/` links являются Workspace policy, а не domain-neutral primitive.

### 2. Четыре top-level commands становятся прямыми `exec` wrappers

Каждый `.scripts/zt-workspace-<operation>.zsh` вычисляет собственный directory и выполняет соответствующий `.scripts/workspace/zt-workspace-<operation>.zsh` через `exec ... "$@"`. Это сохраняет public paths, signals, arguments и exit status. Managed skill manifest продолжает ссылаться на top-level scripts.

Альтернатива сохранить full workflows сверху отклонена из-за двойного ownership. Промежуточный forwarding через `.scripts/zettelkasten/` отклонён, поскольку Workspace не является функцией этого plugin по `ZP-ARCH-004`.

### 3. Перенос является механическим, включая selection и error order

Create/add/open/remove code переносится без изменения prompts, `fzf` delimiters/options, cancel exit behavior, printed messages и side-effect order. Plugin-local path calculation адаптируется только к новой глубине каталогов. Remove сохраняет временный файл, platform-specific mode lookup и единый final `mv`; add сохраняет проверку active types и идемпотентность link append.

Рефакторинг общих selection helpers сверх существующей library отклонён: он усложнил бы доказательство parity. Исправления обнаруженных behavioral defects требуют отдельного specification change, а не включаются скрыто в архитектурный перенос.

### 4. Совместимость проверяется через публичные entrypoints

Основной regression test — `tests/zt-workspace-as-plugin.zsh`. Он создаёт временный `ZK_HOME`, подставляет scripted `fzf` и вызывает только top-level commands. Сценарии покрывают create validation/collision, add selection/idempotency/cancel, open read-only/cancel и remove active/deprecated/broken links, multi-selection, supported code blocks, atomic failure и mode preservation.

Structural assertions проверяют четыре direct wrappers, отсутствие canonical Workspace code под `.scripts/zettelkasten/`/top-level scripts и запрещённых source references. Hash/diff fixtures linked documents подтверждают `WORKSPACE-014`.

### 5. Legacy ownership переносится без смены stable IDs

`ZP-WORKSPACE-001` и `ZP-WORKSPACE-002` переходят из `.scripts/zettelkasten/docs/requirements.adoc` в `.scripts/workspace/docs/requirements.adoc`; их stable IDs сохраняются как историческая traceability. Product-level `AGGR-*` и `WORKSPACE-*` остаются в `.scripts/docs/requirements.adoc` и не дублируются в plugin docs. `ZP-FEATURE-022` переносится в Workspace plugin Feature List, а Zettelkasten Feature List перестаёт заявлять Workspace library/host commands.

Альтернатива создать эквивалентные `WP-*` вместо существующих policy IDs отклонена политикой stable IDs. Новые `WP-*` используются только для новой plugin architecture.

## Risks / Trade-offs

- [Новая глубина directory сломает source paths] → вычислять repository scripts directory явно и проверять все четыре workflows через top-level entrypoints.
- [Scripted `fzf` test не воспроизведёт multi-line protocol] → использовать fixture, который проверяет delimiter, multi-selection и cancel отдельно для workspace/doc selectors.
- [Remove изменит mode или частично перепишет файл] → fault-injection проверяет неизменность исходного файла до успешного final move и отдельный test сравнивает mode.
- [Stable IDs окажутся продублированы после переноса docs] → удалить policy section из Zettelkasten source и запускать exact-once legacy coverage.
- [Связанные Note/Diary будут случайно изменены] → до и после каждого mutation scenario сравнивать hashes target documents во временном Vault.
- [Активные Diary/Inbox changes меняют общую architecture delta параллельно] → implementation должен сверить актуальный baseline после archive других changes и разрешить пересечение `ARCH-016` композиционно, не перезаписывая sibling plugin rules.

## Migration Plan

1. Добавить `tests/zt-workspace-as-plugin.zsh` и подтвердить behavioral часть на текущих host workflows с временным `ZK_HOME`.
2. Создать `.scripts/workspace/`, перенести library и четыре workflows с сохранением observable behavior.
3. Переключить четыре top-level scripts на direct `exec` wrappers и удалить `.scripts/zettelkasten/lib/workspace.zsh` после прохождения parity tests.
4. Обновить architecture, Feature List, legacy traceability, managed-skill/boundary checks и документацию plugin tree.
5. Выполнить syntax, focused regression, repository и OpenSpec validation.

User-data migration отсутствует: installation не сканирует и не изменяет `workspaces/` или `notes/`. До release code rollback возвращает library/workflows в прежние paths и тела top-level scripts; после release предпочтителен forward fix. Rollback и recovery не выполняют операции над реальным Vault или Git history пользователя.
