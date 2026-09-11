## MODIFIED Requirements

### Requirement: LIB-001 — повторяющийся нейтральный код переносится в scripts/lib/

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Development, migration или runtime process MUST соблюдать следующее правило: повторяющийся нейтральный код находится в `scripts/lib/`; Zettelkasten-specific повторяющийся код — в `scripts/zettelkasten/lib/`, когда это уменьшает реальное дублирование.

#### Scenario: Library placement follows new root

- **WHEN** a new shared helper is added
- **THEN** it is placed in the appropriate `scripts/` library namespace and no new `.scripts/` path is introduced

### Requirement: LIB-002 — нейтральные библиотеки scripts/lib/

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Библиотеки и зависимости`.

Текущая реализация MUST сохранять нейтральные библиотеки `scripts/lib/`: `paths.zsh`, `uuid.zsh`, `asciidoc.zsh`; Zettelkasten-specific библиотеки находятся в `scripts/zettelkasten/lib/`.

#### Scenario: Canonical libraries are discoverable

- **WHEN** a workflow sources a neutral or Zettelkasten-specific helper
- **THEN** it resolves the helper from the corresponding `scripts/` path

