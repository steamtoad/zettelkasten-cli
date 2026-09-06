## MODIFIED Requirements

### Requirement: ARCH-016 — разрешённые зависимости

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Zettelkasten-CLI MUST сохранять следующий инвариант: разрешены зависимости `lib -> lib`, `objects -> lib`, `zettelkasten -> objects/lib/собственный код`, `diary -> objects/lib/собственный код`, `inbox -> lib/собственный код`, `workspace -> lib/собственный код`. Здесь собственный код включает library того же plugin. Зависимости между sibling plugins (`zettelkasten`, `diary`, `inbox`, `workspace`), из `lib` в objects/plugins, из `objects` в plugins и из Inbox/Workspace в objects запрещены.

Boundary checker MUST проверять executable dependencies внутри command substitution и compound shell statements; bare relative source без directory anchor MUST диагностироваться как неподтверждённая dependency.

#### Scenario: ARCH-016 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

#### Scenario: Dependency in command substitution

- **WHEN** исходник plugin использует source другого plugin внутри command substitution или compound shell statement
- **THEN** boundary check обнаруживает запрещённую зависимость


#### Scenario: Relative source is not a static anchor

- **WHEN** source использует bare relative path без явного script-directory anchor
- **THEN** boundary check отклоняет неподтверждённую dependency вместо предположения о runtime cwd

### Requirement: ARCH-019 — в переходной архитектуре host CLI может напрямую использовать .scripts/zettelkasten/lib/

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Архитектура`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: в переходной архитектуре host CLI может напрямую использовать `.scripts/zettelkasten/lib/`: Continue, Reduce и Refine используют `today.zsh`, а Continue использует `bindings.zsh`; Workspace-команды являются compatibility entrypoints отдельного `.scripts/workspace/` и не используют `.scripts/zettelkasten/lib/workspace.zsh`.

#### Scenario: ARCH-019 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
