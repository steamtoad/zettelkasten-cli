## MODIFIED Requirements

### Requirement: ARCH-013 — scripts/objects/ содержит нейтральные constructors постоянных типов Note, Memo, Todo, Diary и Topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `scripts/objects/` содержит нейтральные constructors постоянных типов Note, Memo, Todo, Diary и Topic; constructors гарантируют UUID-файл, обязательные метаданные, `:type:` и специфический object contract, но не выполняют интерактивный workflow.

#### Scenario: Object layer remains in canonical path

- **WHEN** a constructor is invoked
- **THEN** its implementation resolves from `scripts/objects/` and preserves the existing object contract

### Requirement: ARCH-014 — scripts/zettelkasten/ и scripts/zettelkasten/lib/ содержат Zettelkasten-specific policy

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `scripts/zettelkasten/` и `scripts/zettelkasten/lib/` содержат Zettelkasten-specific policy для Note, Memo, Topic и Todo; Diary workflow и Diary state принадлежат отдельному `scripts/diary/`.

#### Scenario: Plugin ownership survives relocation

- **WHEN** a Zettelkasten or Diary workflow runs
- **THEN** it resolves its canonical implementation below the corresponding `scripts/<plugin>/` directory

#### Scenario: ARCH-014 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ARCH-016 — разрешённые зависимости сохраняются под scripts/

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять разрешённые зависимости `lib -> lib`, `objects -> lib`, `zettelkasten -> objects/lib/собственный код`, `diary -> objects/lib/собственный код`, `inbox -> lib/собственный код`, `workspace -> lib/собственный код` внутри `scripts/`. Boundary checker MUST проверять executable dependencies и bare relative source по новым canonical paths.

#### Scenario: Boundary checks use relocated paths

- **WHEN** `scripts/dev/zt-plugin-boundaries-check.zsh` analyzes dependencies
- **THEN** it enforces the same dependency direction under `scripts/` and reports stale `.scripts/` anchors

### Requirement: ARCH-017 — top-level scripts/zt-*.zsh сохраняются как compatibility entrypoints

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация MUST сохранять top-level `scripts/zt-note.zsh`, `scripts/zt-memo.zsh`, `scripts/zt-keytopic.zsh`, `scripts/zt-todo.zsh` и `scripts/zt-diary.zsh` как compatibility entrypoints с прежними CLI semantics и делегированием canonical workflows в `scripts/`.

#### Scenario: Compatibility entrypoint remains callable

- **WHEN** an existing CLI workflow is invoked through `scripts/zt-*.zsh`
- **THEN** it produces the same observable result while sourcing only relocated canonical paths
