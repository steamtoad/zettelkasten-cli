## 1. Inventory and preflight

- [x] 1.1 Зафиксировать Git worktree status, список файлов `scripts/dev/` и все
  tracked references на `scripts/dev/`; проверить protected user-data paths.
- [x] 1.2 Проверить prerequisites (`AGENTS.MD`, `openspec/config.yaml`,
  `scripts/docs/requirements.adoc`) и отсутствие коллизии `dev/scripts/`.

## 2. Relocate development scripts

- [x] 2.1 Переместить `scripts/dev/` в `dev/scripts/`, сохранив содержимое,
  LF endings, executable permissions и внутренние references.
- [x] 2.2 Обновить все repository-local ссылки в AGENTS, README, OpenSpec
  context, documentation, tests, packaging и validation tooling.
- [x] 2.3 Обновить publish/distribution paths так, чтобы development scripts
  попадали в `dev/scripts/`, а runtime `scripts/` сохранялся отдельно.
- [x] 2.4 Явно задокументировать breaking policy для старых `scripts/dev/*`
  callers без silent compatibility fallback.

## 3. Verification

- [x] 3.1 Добавить/обновить layout check: новый путь существует, старый путь
  отсутствует, protected user-data paths не изменены.
- [x] 3.2 Запустить `zsh -n`, development skill/package checks, plugin/OpenSpec
  checks и релевантные regression tests на временном `ZK_HOME`.
- [x] 3.3 Выполнить negative search по старому repository path и проверить
  `git diff --check` и Git diff summary.
