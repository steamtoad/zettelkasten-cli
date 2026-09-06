## 1. Зафиксировать существующий Workspace contract

- [x] 1.1 Создать основной regression test `tests/zt-workspace-as-plugin.zsh`, вызывающий четыре top-level commands только с временным `ZK_HOME` и scripted `fzf`; проверить create validation, safe filename, collision и exact Workspace template на текущей реализации.
- [x] 1.2 Добавить add/open scenarios для selection, cancel, active-type filtering, idempotent `../notes/UUID.adoc` links и read-only stdout; проверить `WORKSPACE-010`, `WORKSPACE-011` и неизменность hashes linked documents.
- [x] 1.3 Добавить remove scenarios для active/deprecated/broken targets, `fzf --multi`, cancel, supported code blocks, atomic failure и file-mode preservation; проверить `WORKSPACE-012`–`WORKSPACE-014`.
- [x] 1.4 Добавить structural assertions для четырёх direct wrappers, canonical code под `.scripts/workspace/`, отсутствия `.scripts/zettelkasten/lib/workspace.zsh` и запрещённых cross-layer references; проверить, что assertions различают исходную и целевую архитектуру.

## 2. Выделить Workspace plugin

- [x] 2.1 Создать `.scripts/workspace/lib/workspace.zsh` и перенести safe naming, path/link formatting, preflight и selection policy без изменения observable behavior; проверить library-dependent scenarios основного regression test.
- [x] 2.2 Перенести create и open workflows в `.scripts/workspace/zt-workspace-{create,open}.zsh`, адаптировав только source paths; проверить template/error/cancel/stdout parity через top-level commands.
- [x] 2.3 Перенести add и remove workflows в `.scripts/workspace/zt-workspace-{add,remove}.zsh` без изменения selection, idempotency, atomicity, code-block и mode contracts; проверить соответствующие regression scenarios и hashes target documents.
- [x] 2.4 Превратить четыре `.scripts/zt-workspace-*.zsh` в executable direct `exec` wrappers с полным forwarding `"$@"`, затем удалить `.scripts/zettelkasten/lib/workspace.zsh`; проверить stdout/stderr/exit parity и четыре managed skill mappings.
- [x] 2.5 Добавить или расширить repository boundary check для `WP-ARCH-001`, `WP-ARCH-002`, `ARCH-016` и `ARCH-019`; проверить разрешённые `workspace -> lib/workspace/lib` и отсутствие зависимостей `workspace <-> zettelkasten` и обратных engine/plugin dependencies.

## 3. Перенести документацию и traceability

- [x] 3.1 Создать `.scripts/workspace/docs/requirements.adoc`, перенести туда `ZP-WORKSPACE-001` и `ZP-WORKSPACE-002` без смены stable IDs и удалить их из Zettelkasten plugin documentation; проверить exact-once legacy coverage, оставив `AGGR-*`/`WORKSPACE-*` только в общей requirements source.
- [x] 3.2 Создать `.scripts/workspace/docs/features.adoc`, перенести ownership `ZP-FEATURE-022` и обновить агрегирующий Feature List; проверить, что Workspace описан как отдельный plugin и остаётся агрегатором продукта, а не persistent document.
- [x] 3.3 Обновить architecture/tree/development documentation согласно `ARCH-016`, `ARCH-019` и целевому plugin layout; проверить отсутствие заявлений о host ownership, зависимости на `.scripts/zettelkasten/lib/workspace.zsh`, отдельном repository или data migration.

## 4. Выполнить итоговую проверку

- [x] 4.1 Выполнить `zsh -n` для всех изменённых Zsh files и `tests/zt-workspace-as-plugin.zsh`; исправить все syntax failures.
- [x] 4.2 Запустить `tests/zt-workspace-as-plugin.zsh` с временным Vault и подтвердить `WORKSPACE-001`–`WORKSPACE-014`, compatibility wrappers и отсутствие изменений реального Vault.
- [x] 4.3 Запустить профильные boundary/documentation checks и `tests/zt-all.zsh`; подтвердить отсутствие новых failures и документировать unrelated pre-existing failures отдельно.
- [x] 4.4 После синхронизации с параллельными Diary/Inbox changes проверить композицию `ARCH-016` без потери sibling plugin rules, затем запустить `openspec validate refactor-workspace-as-plugin --strict`, `openspec validate --all`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check`.
