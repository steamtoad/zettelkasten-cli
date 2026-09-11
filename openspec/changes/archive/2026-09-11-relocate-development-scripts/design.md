## Context

См. `proposal.md`. После предыдущей layout-миграции `.scripts/` уже является
`scripts/`, а development checks находятся в `scripts/dev/`. Runtime scripts и
development tooling используют разные контракты и должны быть разделены.

## Goals / Non-Goals

**Goals:**

- Сделать `dev/scripts/` единственным canonical расположением development
  scripts.
- Сохранить содержимое, executable permissions и поведение проверок.
- Обновить все repository-relative references и publication/validation paths.
- Сохранить Git-safe migration и защиту пользовательских данных.

**Non-Goals:**

- Не менять `scripts/lib/`, `scripts/objects/`, plugin code или top-level CLI.
- Не менять runtime managed skills, Vault data, UUIDs или storage semantics.
- Не добавлять постоянные compatibility symlinks без отдельного решения.

## Decisions

### Canonical move

Переместить каталог `scripts/dev/` в `dev/scripts/` одним Git-aware rename.
Параллельные копии не оставлять: это предотвращает drift и неоднозначное
разрешение development tooling.

### Reference resolution

Ссылки вычислять относительно repository root, найденного по `AGENTS.MD`,
`openspec/config.yaml` и `scripts/docs/requirements.adoc`. Runtime paths под
`scripts/` не переписывать; обновляются только пути development scripts.

### Compatibility policy

Прямые вызовы старого `scripts/dev/*` считаются breaking repository-layout
изменением. README и migration notes должны явно указать новый путь; silent
fallback и symlink alias не добавляются.

### Safety and validation

Перед переносом проверить чистоту/допустимость worktree, отсутствие коллизии
`dev/scripts/` и отсутствие изменений в пользовательских каталогах. После
переноса выполнить repository-wide search старого пути, syntax checks,
development checks, OpenSpec validation, релевантные tests и `git diff --check`.

## Risks / Trade-offs

- [Stale reference] Редкие ссылки на `scripts/dev/` могут остаться → выполнить
  negative search по repository source, docs и tests.
- [Breaking caller] Внешние callers старого пути перестанут работать → явно
  документировать новый путь и не скрывать ошибку fallback-логикой.
- [Git history] Rename может выглядеть как delete/add → проверить diff summary и
  сохранить содержимое/режимы файлов.
- [User-data overreach] Широкая замена может затронуть Vault → ограничить
  scope repository paths и проверить protected paths до и после migration.

## Migration Plan

1. Зафиксировать inventory `scripts/dev/`, Git status и references.
2. Проверить prerequisites и отсутствие `dev/scripts/`.
3. Переместить каталог и обновить repository-relative references.
4. Выполнить layout, syntax, packaging, OpenSpec и regression checks.
5. При failure остановить migration и восстановить rename/reference patch;
   пользовательские данные не откатывать и не изменять.
