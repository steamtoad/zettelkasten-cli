## Why

Workspace сейчас разделён между top-level host workflow и policy library внутри Zettelkasten plugin, из-за чего ownership и направление развития остаются переходными. Выделение Workspace в sibling plugin создаёт единую границу для четырёх команд и их policy, сохраняя Workspace частью продукта `zettelkasten-cli` и существующего Vault layout.

## What Changes

- Вводится отдельный Workspace plugin под `.scripts/workspace/` как каноническое место create/add/open/remove workflow, Workspace policy library и plugin-specific документации.
- `.scripts/zt-workspace-create.zsh`, `.scripts/zt-workspace-add.zsh`, `.scripts/zt-workspace-open.zsh` и `.scripts/zt-workspace-remove.zsh` сохраняются как публичные compatibility entrypoints и делегируют Workspace plugin без изменения CLI, prompts, stdout/stderr и exit status.
- `.scripts/zettelkasten/lib/workspace.zsh` перестаёт принадлежать Zettelkasten plugin; Workspace plugin не зависит от `.scripts/zettelkasten/`.
- Сохраняются каталог `ZK_HOME/workspaces/`, безопасные имена `.adoc`, формат заголовка/раздела, относительные ссылки `../notes/UUID.adoc`, selection semantics, идемпотентность add и атомарность remove.
- Сохраняются четыре managed operational skills и их mapping на существующие top-level команды.
- Дальнейшая разработка Workspace ведётся внутри plugin boundary в текущем репозитории `zettelkasten-cli`.
- Не вводятся отдельный Git repository/package, runtime plugin discovery, новая persistent document type или миграция существующих Workspace.

## Capabilities

### New Capabilities

- `workspace-plugin-architecture`: ownership отдельного Workspace plugin, направления зависимостей, compatibility entrypoints и data-safety invariants при выделении plugin.

### Modified Capabilities

- `architecture`: `ARCH-016` добавляет Workspace plugin в dependency graph, а `ARCH-019` удаляет переходную host dependency на `.scripts/zettelkasten/lib/workspace.zsh`.
- `plugin-workspace-policy`: `ZP-WORKSPACE-001` и `ZP-WORKSPACE-002` переносят Workspace policy и canonical workflow из переходного host/Zettelkasten разделения в отдельный Workspace plugin.

## Impact

- Затрагиваемые области: `.scripts/workspace/`, `.scripts/zettelkasten/lib/workspace.zsh`, четыре `.scripts/zt-workspace-*.zsh`, Workspace/Zettelkasten documentation, Feature List, legacy traceability и `tests/zt-workspace-as-plugin.zsh`.
- Стабильные behavior contracts `AGGR-001`–`AGGR-004`, `WORKSPACE-001`–`WORKSPACE-014`, `PATH-004`, `PATH-008`–`PATH-010` сохраняются; изменяются ownership contracts `ZP-WORKSPACE-001`, `ZP-WORKSPACE-002`, `ARCH-016` и `ARCH-019`.
- Managed skill mappings `zettelkasten-workspace-{create,add,open,remove}` → соответствующие top-level scripts сохраняются.
- Архитектурный эффект: L4-изменение ownership и dependency graph без изменения пользовательского API или storage semantics.
- Совместимость: breaking changes отсутствуют; aliases, command paths, prompts и output formats сохраняются.
- Миграция: не требуется; существующие файлы остаются в `ZK_HOME/workspaces/` и продолжают ссылаться на `../notes/UUID.adoc`.
- Destructive operations: над пользовательскими данными отсутствуют. Planning и implementation verification используют временный `ZK_HOME` и не изменяют реальный Vault.
- Persistent document model, UUID/link targets и Git history пользователя не меняются.
