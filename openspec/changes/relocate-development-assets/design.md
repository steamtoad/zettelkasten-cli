## Context

Текущий checkout использует `.scripts/` как корень executable layer, а `skills/` — как корень repo-local development skills. Оба имени зашиты в shell source, проверках, тестах, документации, OpenSpec и legacy traceability. Пользовательские каталоги и документы не должны участвовать в migration.

## Goals / Non-Goals

**Goals:**

- Ввести canonical mapping `.scripts/ → scripts/` и `skills/ → dev/skills/` во всём repository tooling.
- Сохранить внутреннюю архитектуру layer/plugin и наблюдаемое поведение top-level CLI.
- Сделать migration проверяемой, обратимой до финального удаления старых путей и безопасной для Git history.

**Non-Goals:**

- Изменение пользовательского Vault, UUID, AsciiDoc links, runtime OpenClaw state или managed-skill mapping.
- Переработка shell API, plugin boundaries или содержимого development procedures.
- Commit, tag, push или автоматическое изменение внешних каталогов.

## Decisions

### 1. Canonical directories are renamed in place

Git-visible directory renames сохраняют содержимое, mode bits и историю: `.scripts/` становится `scripts/`, а `skills/` — `dev/skills/`. Новые параллельные копии не создаются, чтобы исключить drift. `dev/` создаётся только как родитель для перенесённых skills; существующий `.scripts/dev/` после rename становится `scripts/dev/`.

Альтернатива — оставить symlink-алиасы навсегда — отклонена: это скрывает stale references, усложняет packaging и оставляет неоднозначный canonical root. Кратковременный compatibility alias допустим только если он отдельно обоснован и покрыт тестом; окончательный layout обязан иметь один canonical path.

### 2. Path resolution remains repository-relative

Все shell scripts вычисляют путь от собственного расположения или существующих path helpers; hard-coded checkout paths не добавляются. Repository resolver принимает только root с `AGENTS.MD`, `openspec/config.yaml` и `scripts/docs/requirements.adoc`. Проверки, README, AGENTS и OpenSpec context обновляются согласованно.

### 3. Runtime managed skills remain a separate layer

Перенос касается только repo-local development procedures. Внешние managed operational skills, их OpenClaw state, Detailed Notes и manifest semantics не перемещаются. `scripts/docs/managed-skills.adoc` обновляется только в части repository script paths и затем проверяется against runtime mapping.

### 4. Migration uses preflight, staged rewrite and post-validation

Перед rename выполняются Git worktree preflight, проверка отсутствия `scripts/` и `dev/skills/`, inventory файлов и snapshot ссылок на старые пути. После rename все repository references переписываются, затем запускаются path/layout checks, plugin boundary check, agent-skills check, OpenSpec check, релевантные tests и `git diff --check`.

Rollback до post-validation выполняется обратным Git-aware rename и восстановлением reference edits из отдельного migration patch; пользовательские данные при этом не затрагиваются. Если старые каталоги уже удалены и validation не пройдена, migration считается неуспешной и не должна автоматически продолжаться.

## Risks / Trade-offs

- [Breaking] Внешний вызов `.scripts/*` или чтение `skills/*` перестанет работать → явно перечислить compatibility policy в README/release notes и проверить все tracked references; не добавлять silent fallback.
- [Stale reference] Редкие пути могут остаться в документации или тестах → выполнить repository-wide search, dedicated negative check на `.scripts/` и root `skills/`, затем OpenSpec/agent checks.
- [Git history] Массовый rename может быть представлен как delete/add → использовать Git-aware rename и проверить `git diff --summary`/статистику, не коммитя автоматически.
- [Packaging drift] `dev/skills/` может содержать references на старую layout → прогнать `scripts/dev/zt-agent-skills-check.zsh` и проверить каждый canonical reference.
- [Overreach] Миграция может случайно затронуть пользовательские каталоги → ограничить список изменяемых путей repository source/docs/tests и добавить preflight guard на `notes/`, `all-todays/`, `workspaces/`, `inbox/`, `.last-diary`, `.state/`.
