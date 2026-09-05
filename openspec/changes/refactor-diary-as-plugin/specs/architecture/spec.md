## MODIFIED Requirements

### Requirement: ARCH-014 — .scripts/zettelkasten/ и .scripts/zettelkasten/lib/ содержат Zettelkasten-specific policy

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.scripts/zettelkasten/` и `.scripts/zettelkasten/lib/` содержат Zettelkasten-specific policy для Note, Memo, Topic и Todo, включая интерактивный ввод, bindings, `all-todays` и другие workflow-правила; Diary workflow и Diary state принадлежат отдельному `.scripts/diary/`.

#### Scenario: ARCH-014 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: ARCH-016 — разрешённые зависимости

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: разрешённые зависимости: `objects -> lib`, `zettelkasten -> objects`, `zettelkasten -> lib`, `zettelkasten -> zettelkasten/lib`, `diary -> objects`, `diary -> lib`, `diary -> diary/lib`; зависимости `lib -> objects`, `lib -> zettelkasten`, `lib -> diary`, `objects -> zettelkasten`, `objects -> diary`, `zettelkasten -> diary` и `diary -> zettelkasten` запрещены.

#### Scenario: ARCH-016 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-017 — top-level zt-note.zsh, zt-memo.zsh, zt-keytopic.zsh, zt-todo.zsh и zt-diary.zsh сохранены как...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: top-level `zt-note.zsh`, `zt-memo.zsh`, `zt-keytopic.zsh` и `zt-todo.zsh` сохранены как compatibility entrypoints и делегируют каноническим workflow в `.scripts/zettelkasten/`; top-level `zt-diary.zsh` сохранён как compatibility entrypoint и делегирует каноническому workflow в `.scripts/diary/`.

#### Scenario: ARCH-017 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
