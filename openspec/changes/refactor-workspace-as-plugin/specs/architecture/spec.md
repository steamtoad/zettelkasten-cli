## MODIFIED Requirements

### Requirement: ARCH-016 — разрешённые зависимости

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: разрешённые зависимости: `objects -> lib`, `zettelkasten -> objects`, `zettelkasten -> lib`, `zettelkasten -> zettelkasten/lib`, `workspace -> lib`, `workspace -> workspace/lib`; зависимости `lib -> objects`, `lib -> zettelkasten`, `lib -> workspace`, `objects -> zettelkasten`, `objects -> workspace`, `zettelkasten -> workspace` и `workspace -> zettelkasten` запрещены.

#### Scenario: ARCH-016 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: ARCH-019 — в переходной архитектуре host CLI может напрямую использовать .scripts/zettelkasten/lib/

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: в переходной архитектуре host CLI может напрямую использовать `.scripts/zettelkasten/lib/`: Continue, Reduce и Refine используют `today.zsh`, а Continue использует `bindings.zsh`; Workspace-команды являются compatibility entrypoints отдельного `.scripts/workspace/` и не используют `.scripts/zettelkasten/lib/workspace.zsh`.

#### Scenario: ARCH-019 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
