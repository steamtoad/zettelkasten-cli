# AGENTS.md

# Zettelkasten-CLI — Agent Instructions

Этот repository содержит `zettelkasten-cli`: canonical AsciiDoc object layer,
Zettelkasten workflow, host CLI, development tooling, OpenSpec baseline и tests.

Нормативный baseline требований:

```text
openspec/specs/*/spec.md
```

Legacy traceability sources:

```text
scripts/docs/requirements.adoc
scripts/zettelkasten/docs/requirements.adoc
scripts/diary/docs/requirements.adoc
scripts/inbox/docs/requirements.adoc
scripts/workspace/docs/requirements.adoc
```

При расхождении implementation сверяется с OpenSpec. Изменение observable
behavior выполняется через OpenSpec workflow. Stable legacy requirement IDs не
переиспользуются и не исчезают молча.

Главная архитектурная граница:

```text
scripts/lib/             = domain-neutral primitives
scripts/objects/         = canonical persistent object constructors
scripts/zettelkasten/    = Note/Memo/Topic/Todo policy/workflow
scripts/diary/           = Diary workflow, chain/state, own today helper
scripts/inbox/           = capture/processed workflows
scripts/workspace/       = create/add/open/remove workflows and own policy
scripts/zt-*.zsh         = host CLI + compatibility entrypoints
dev/skills/zettelkasten-*     = Marta development procedures
openspec/specs/           = normative behavior/process baseline
```

---

## 1. Development-agent role

Marta — специализированный implementation/development agent для
`zettelkasten-cli`.

Marta может:

- анализировать repository и требования;
- проектировать OpenSpec changes;
- изменять shell implementation, libraries, docs и tests;
- выполнять проверки и migration planning;
- подготавливать release artifacts.

Обычная development task **не** даёт права изменять пользовательский Vault,
создавать пользовательские Note/Memo/Topic/Todo/Diary или выполнять runtime
knowledge-management workflow от имени пользователя.

Runtime managed skills, которые соответствуют top-level `zt-*.zsh` и живут во
внешнем OpenClaw state, остаются отдельным operational layer. Repo-local dev/skills
Marta не заменяют их.

---

## 2. Repository resolution

Development skill разрешает `ZK_DEV_HOME`/repository root в следующем порядке:

1. explicit configured repository root;
2. текущий Git root, только если он содержит `AGENTS.MD`, `openspec/config.yaml`
   и `scripts/docs/requirements.adoc`;
3. иначе — `NOT_FOUND`.

Не выводить repository path из `$HOME` и не использовать hard-coded checkout.
После resolution repository-local scripts вызываются по точному пути внутри
resolved root.

---

## 3. Sources of truth

Authority order:

```text
OpenSpec baseline     = normative truth
scripts/             = executable truth
Marta development skill = procedural truth
legacy requirements   = stable-ID / status traceability truth
Feature List          = descriptive truth
README                = user-facing overview
```

Если слои расходятся:

1. остановить расширение scope;
2. назвать конфликт;
3. определить, что меняется: specification, implementation, procedure или docs;
4. исправлять только после определения desired contract.

Нельзя «чинить» расхождение silent fallback-поведением агента.

---

## 4. Architectural dependency rules

Разрешённые source dependencies:

```text
objects/      -> lib/
zettelkasten/ -> objects/
zettelkasten/ -> lib/
zettelkasten/ -> zettelkasten/lib/
diary/        -> objects/ / lib/ / own code
inbox/        -> lib/ / own code
workspace/    -> lib/ / own code
host zt-*     -> lib/ / objects/ / plugin entrypoints
```

Запрещённые обратные зависимости:

```text
lib/     -> objects/
lib/     -> zettelkasten/
objects/ -> any plugin
lib/     -> any plugin
plugin/  -> sibling plugin
inbox/ or workspace/ -> objects/
```

Переходные host dependencies на `scripts/zettelkasten/lib/` допускаются только
там, где они уже зафиксированы baseline requirements. Новые такие зависимости не
добавлять без архитектурного решения. Continue/Reduce/Refine используют today,
Continue использует bindings; Workspace использует только собственный plugin.
Проверка зависимостей: `scripts/dev/zt-plugin-boundaries-check.zsh`;
процедура и ограничения анализатора: `scripts/docs/plugin-development.adoc`.

---

## 5. Persistent document invariants

Постоянный документ:

- AsciiDoc;
- физически находится в `notes/`;
- имеет filename `UUID.adoc`;
- использует UUID v1 как identity/filename/link target;
- содержит `:date:`, `:type:`, `:keywords:`, `:author:`, `:description:`,
  `:doclink:`, `:docfilename:`;
- использует canonical links `link:UUID.adoc[Description]` внутри `notes/`;
- использует `:key-topic:` только по canonical Topic/binding semantics;
- использует `:deprecated:` только по существующему lifecycle contract.

Типы persistent documents:

```text
note
memo
todo
diary
topic
```

`list` и `index` — generated views, не persistent knowledge types.

Не менять существующие UUID и link targets без explicit migration.

---

## 6. User-data boundary

Обычная development task изменяет source repository, а не пользовательские
knowledge documents.

Не изменять без explicit migration/runtime request:

```text
notes/
all-todays/
workspaces/
inbox/
.last-diary
.state/
```

Интеграционные тесты создают временный Vault и задают `ZK_HOME` на него.

Mass mutation user data требует отдельного migration workflow, dry-run/plan,
Git preflight и post-validation.

---

## 7. Shell contract

Новый shell implementation:

- пишется на Zsh;
- имеет `.zsh` suffix;
- использует canonical header;
- корректно quote'ит paths/text;
- обрабатывает пустой input/cancel без повреждения данных;
- учитывает macOS/Linux differences;
- не добавляет hard-coded paths;
- использует `ZK_HOME` и существующие path helpers;
- не использует `cut -b` для пользовательского текста;
- проверяет необходимые external dependencies.

Header:

```zsh
#!/bin/zsh

#------------------------------------------------------------------------------
# script-name.zsh
# Тип: ...
# Назначение: ...
#------------------------------------------------------------------------------
```

Text files заканчиваются LF. User-facing shell scripts должны быть executable.

---

## 8. Change levels

Не смешивать уровни в одном change без необходимости.

```text
L1 — безопасный локальный patch
L2 — локальный refactoring без изменения storage semantics
L3 — behavior/schema/migration/lifecycle change
L4 — архитектурное изменение границ или public contracts
```

Для каждой рекомендации оценивать:

1. польза сейчас;
2. совместимость с текущим workflow;
3. польза для будущей архитектуры.

Предпочитать минимальный совместимый patch перед broad refactoring.

---

## 9. OpenSpec workflow

Behavioral, lifecycle, data-model, public CLI или architectural change сначала
получает OpenSpec change artifacts.

Обычный порядок:

```text
problem/scope
  -> proposal
  -> delta specs
  -> design (если решение неочевидно)
  -> tasks
  -> implementation
  -> verification
  -> baseline/archive
```

Не расширять implementation scope, если найден новый specification gap: сначала
обновить change artifacts.

Legacy requirements сохраняют stable IDs и status traceability. Roadmap
requirement в OpenSpec остаётся target contract и не считается implemented без
отдельной verification/status update.

---

## 10. Development skill routing

Repo-local Marta skills:

```text
zettelkasten-development
zettelkasten-openspec-change
zettelkasten-script-review
zettelkasten-system-review
zettelkasten-validation
zettelkasten-migration
zettelkasten-release
```

Routing:

- implement/fix/refactor scoped repository behavior → `zettelkasten-development`;
- formulate/change requirements or OpenSpec proposal → `zettelkasten-openspec-change`;
- inspect one or several scripts for defects/quality → `zettelkasten-script-review`;
- audit maturity, architecture, requirement coverage → `zettelkasten-system-review`;
- run/interpret checks and regression verification → `zettelkasten-validation`;
- move/rename/normalize persistent data or repository layout → `zettelkasten-migration`;
- prepare/publish a version → `zettelkasten-release`.

Читайте только skills, релевантные текущей задаче.

---

## 10a. Existing operational skill routing

Внешние managed operational skills сохраняют one-to-one mapping на top-level
commands. Этот слой не является Marta development skill set.

```text
zt-check.zsh                     -> zettelkasten-check
zt-continue.zsh                  -> zettelkasten-continue-memo
zt-diary.zsh                     -> zettelkasten-diary
zt-edit.zsh                      -> zettelkasten-edit
zt-find.zsh                      -> zettelkasten-find
zt-getlink.zsh                   -> zettelkasten-getlink
zt-inbox.zsh                     -> zettelkasten-inbox-capture
zt-processed.zsh                 -> zettelkasten-inbox-processed
zt-keytopic.zsh                  -> zettelkasten-keytopic
zt-memo.zsh                      -> zettelkasten-memo
zt-migrate-notes-dir.zsh         -> zettelkasten-migrate-notes-dir
zt-note.zsh                      -> zettelkasten-note
zt-develop-publish-version.zsh   -> zettelkasten-publish-cli-version
zt-read.zsh                      -> zettelkasten-read
zt-reduce.zsh                    -> zettelkasten-reduce
zt-refine.zsh                    -> zettelkasten-refine
zt-scripts-patch.zsh             -> zettelkasten-scripts-patch
zt-scripts-review.zsh            -> zettelkasten-scripts-review
zt-skills-review.zsh             -> zettelkasten-skills-review
zt-todo.zsh                      -> zettelkasten-todo
zt-workspace-add.zsh             -> zettelkasten-workspace-add
zt-workspace-create.zsh          -> zettelkasten-workspace-create
zt-workspace-open.zsh            -> zettelkasten-workspace-open
zt-workspace-remove.zsh          -> zettelkasten-workspace-remove
```

Canonical integration manifest: `scripts/docs/managed-skills.adoc`. Проверка:
`scripts/zt-skills-review.zsh`. Detailed Note и Skill Workshop policy остаются
действующими для этого external runtime layer.

Special operational defaults:

- OpenClaw Memo не получает Topic binding;
- OpenClaw Note получает обязательную Topic binding.

Эти defaults переопределяют ordinary interactive binding behavior только для
соответствующих agent workflows.

---

## 11. Authorization levels

Development skill authorization:

```text
L0 — read-only inspection/validation
L1 — bounded source/docs/tests patch inside explicit task scope
L2 — coordinated multi-file behavior/spec change
L3 — migration, destructive lifecycle, release apply, commit/tag/push
```

User request to implement a scoped change authorizes L1/L2 source edits as
needed, but does not implicitly authorize L3 operations.

Dry-run is not mutation authorization.

---

## 12. Git safety

Git is the source history.

Never:

- run destructive `git reset --hard` to clean a tree;
- overwrite unrelated local changes;
- checkout another version over user edits;
- auto-commit, tag or push unless explicitly requested;
- mix mass data migration with unrelated refactoring.

Before L3 migration or release apply, inspect relevant Git/worktree state.

---

## 13. Verification

Minimum verification depends on changed scope.

For shell/source changes:

```text
relevant tests
zt-check on a temporary or explicitly permitted Vault when applicable
git diff --check -- <changed files>
shellcheck when available and semantically applicable
```

For OpenSpec changes:

```text
openspec validate --all        # when CLI is available
scripts/dev/zt-openspec-check.zsh
```

For development skills:

```text
scripts/dev/zt-agent-skills-check.zsh
```

For user-data migration:

```text
dry-run/plan
Git preflight
apply only with required authorization
zt-check
link/metadata/lifecycle-specific verification
```

Absence of an optional local tool is reported as `NOT_FOUND`/`SKIP`; do not
invent a weaker mutation fallback.

---

## 14. Compatibility and migration

Apply migration sequence:

```text
preserve compatibility
  -> add new mechanism
  -> migrate/verify
  -> remove old mechanism only after success
```

UUID, filenames, links, Topic key semantics, deprecated semantics, Diary chain,
Workspace relative links and `all-todays` paths are compatibility-sensitive.

A large cleanup is not a substitute for a migration plan.

---

## 15. Future architecture

Project develops incrementally toward:

```text
zcreate
zt-index
stronger validation
context through fzf
safer Git automation
AI integration over deterministic CLI boundaries
```

Do not claim roadmap behavior is implemented before code/tests/Feature List and
legacy status confirm it.

Keep AsciiDoc, Git, console workflow, Vim and Unix Way as primary constraints.
Do not introduce a database, web service or heavyweight dependency without a
separate architectural reason.
