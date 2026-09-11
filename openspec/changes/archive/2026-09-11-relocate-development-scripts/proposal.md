## Why

После переноса executable layer в `scripts/` development-проверки остаются
внутри того же каталога и смешиваются с runtime shell layer. Выделение
`dev/scripts/` делает repository development tooling явным и упрощает его
маршрутизацию, упаковку и поддержку.

## What Changes

- Перенести все repository development scripts из `scripts/dev/` в `dev/scripts/`
  с сохранением имён, содержимого и executable permissions.
- Обновить ссылки на development scripts в `AGENTS.MD`, README, OpenSpec
  context, тестах и документации.
- Обновить repository-resolution, validation и publication tooling на новый
  путь `dev/scripts/`.
- Сохранить runtime layer в `scripts/`, включая `scripts/zt-*.zsh`, libraries,
  objects и plugin directories.
- Не изменять пользовательские каталоги, внешний managed-skill state,
  persistent documents, UUID или CLI semantics.

## Capabilities

### New Capabilities

<!-- Чистая layout/tooling migration; новых runtime capabilities нет. -->

### Modified Capabilities

<!-- Нет spec-level behavior changes; specs пропущены через skip_specs: true. -->

## Impact

- Затрагиваются repository-local development scripts, тестовые пути,
  документация, OpenSpec context и packaging/publish checks.
- Внешние callers, использующие `scripts/dev/*`, получат breaking path change;
  compatibility policy должна быть явно зафиксирована без silent fallback.
- Runtime команды и пользовательские данные остаются вне scope.
