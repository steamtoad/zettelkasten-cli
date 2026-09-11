## Why

Текущая структура смешивает executable repository tooling в скрытом каталоге `.scripts/` и repo-local development skills в корне `skills/`. Это усложняет навигацию, упаковку и однозначное разрешение путей агентом разработки; сейчас подходящий момент закрепить открытый каталог `scripts/` и единый namespace `dev/skills/` до дальнейшего развития tooling.

Желаемое состояние — `.scripts/` переименован в `scripts/`, а содержимое repo-local `skills/` перенесено в `dev/skills/`, при этом поведение CLI, runtime managed skills, пользовательские данные и UUID-ссылки остаются совместимыми.

## What Changes

- Переименовать repository executable layer `.scripts/` в `scripts/`, сохранив внутреннюю структуру (`lib/`, `objects/`, plugins, `dev/`, host `zt-*.zsh`) и executable permissions.
- Перенести repo-local development skills из `skills/` в `dev/skills/` с сохранением имён, содержимого, references и процедурного назначения.
- Обновить все repository-local ссылки, source paths, документацию, тесты, OpenSpec context и проверки на новые пути `scripts/` и `dev/skills/`.
- Обновить repository-resolution и agent-skill packaging checks так, чтобы они проверяли `AGENTS.MD`, `openspec/config.yaml`, `scripts/docs/requirements.adoc` и `dev/skills/`.
- Сохранить совместимые top-level CLI entrypoints, runtime mapping managed skills и семантику пользовательского Vault; migration не изменяет `notes/`, `all-todays/`, `workspaces/`, `inbox/`, `.last-diary` или `.state/`.
- Выполнить migration только после Git preflight, с проверкой отсутствия коллизий и остаточных старых путей; предусмотреть recoverable rollback до удаления старых каталогов.

## Capabilities

### New Capabilities

<!-- Нет: изменение закрепляет новый layout существующих repository capabilities. -->

### Modified Capabilities

- `agent-governance`: заменить нормативные пути executable layer и repo-local skill layer, сохранив mapping и integration contract.
- `development-agent`: обновить repository resolution, расположение development skills и обязательные проверки.
- `architecture`: заменить `.scripts/` на `scripts/` во всех layer и compatibility-entrypoint требованиях без изменения направленности зависимостей.
- `library-boundaries`: перенести определения neutral/object/plugin libraries под `scripts/`.
- `validation`: обновить команды и пути development/repository validation checks.

## Impact

- Затрагиваются shell source paths, path helpers, host entrypoints, dev scripts, tests, README/AGENTS, OpenSpec baseline/context и legacy traceability links.
- Это repository layout migration с потенциально breaking effect для внешних пользователей, которые напрямую вызывают `.scripts/*` или загружают `skills/*`; план должен определить совместимый переходный alias/notice либо явно зафиксировать breaking change.
- Persistent knowledge documents, links, UUIDs и runtime managed OpenClaw skills находятся вне mutation scope.
- Git history должен сохранить rename detection и возможность восстановления; автоматический commit, tag или push не входят в change.
