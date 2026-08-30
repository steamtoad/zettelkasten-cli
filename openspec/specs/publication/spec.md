# publication Specification

## Purpose

Определить safe publication workflow, dry-run/apply boundary, exact mirror behavior, development-artifact packaging и Git non-mutation guarantees.

## Requirements

### Requirement: PUB-001 — публикуются только артефакты zettelkasten-cli

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: публикуются только артефакты `zettelkasten-cli`.

#### Scenario: PUB-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-002 — источник по умолчанию

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: источник по умолчанию: `/Users/steamtoad/zettelkasten`.

#### Scenario: PUB-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-003 — репозиторий назначения по умолчанию

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: репозиторий назначения по умолчанию: `/Users/steamtoad/dev/zettelkasten-cli`.

#### Scenario: PUB-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-004 — пути источника и назначения переопределяются через ZK_DEV_HOME и ZK_PUBLISH_HOME

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: пути источника и назначения переопределяются через `ZK_DEV_HOME` и `ZK_PUBLISH_HOME`.

#### Scenario: PUB-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-005 — копируются .scripts/, openspec/, skills/, tests/, LICENSE, README.MD, AGENTS.MD и .gitignore

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: копируются `.scripts/`, `openspec/`, `skills/`, `tests/`, `LICENSE`, `README.MD`, `AGENTS.MD` и `.gitignore`.

#### Scenario: PUB-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-006 — личные материалы Zettelkasten не публикуются

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: личные материалы Zettelkasten не публикуются.

#### Scenario: PUB-006 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-007 — режим по умолчанию — dry-run

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: режим по умолчанию — `dry-run`.

#### Scenario: PUB-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-008 — реальное копирование выполняется только с --apply

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: реальное копирование выполняется только с `--apply`.

#### Scenario: PUB-008 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-009 — поддерживается явный режим --dry-run

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: поддерживается явный режим `--dry-run`.

#### Scenario: PUB-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-010 — до копирования проверяются источник, назначение, .scripts/, openspec/, skills/, tests/, LICEN...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: до копирования проверяются источник, назначение, `.scripts/`, `openspec/`, `skills/`, `tests/`, `LICENSE`, `README.MD`, `AGENTS.MD` и `.gitignore`.

#### Scenario: PUB-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-011 — ошибки печатаются в stderr

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: ошибки печатаются в stderr.

#### Scenario: PUB-011 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-012 — для копирования используется rsync

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: для копирования используется `rsync`.

#### Scenario: PUB-012 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-013 — содержимое .scripts/, openspec/, skills/ и tests/ копируется в одноимённые каталоги репозитор...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: содержимое `.scripts/`, `openspec/`, `skills/` и `tests/` копируется в одноимённые каталоги репозитория назначения.

#### Scenario: PUB-013 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-014 — LICENSE, README.MD, AGENTS.MD и .gitignore копируются в корень репозитория назначения

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `LICENSE`, `README.MD`, `AGENTS.MD` и `.gitignore` копируются в корень репозитория назначения.

#### Scenario: PUB-014 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-015 — каталоги .scripts/, openspec/, skills/ и tests/ назначения создаются автоматически в режиме -...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: каталоги `.scripts/`, `openspec/`, `skills/` и `tests/` назначения создаются автоматически в режиме `--apply` через directory-mirror copy.

#### Scenario: PUB-015 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-016 — автоматические git add, git commit и git push запрещены

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: автоматические `git add`, `git commit` и `git push` запрещены.

#### Scenario: PUB-016 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-017 — скрипт выводит источник, назначение, режим и отчёт rsync

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: скрипт выводит источник, назначение, режим и отчёт `rsync`.

#### Scenario: PUB-017 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-018 — служебные файлы операционной системы не публикуются

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: служебные файлы операционной системы не публикуются.

#### Scenario: PUB-018 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-019 — .DS_Store исключается из dry-run и реального копирования публикуемых directory trees

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.DS_Store` исключается из dry-run и реального копирования публикуемых directory trees.

#### Scenario: PUB-019 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-020 — .gitignore копируется в публичный репозиторий

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.gitignore` копируется в публичный репозиторий.

#### Scenario: PUB-020 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-021 — перед публикацией выполняются zt-check, проверка зависимостей и проверка состояния репозитори...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Целевая архитектура или поведение MUST сохранять следующий target contract: перед публикацией выполняются `zt-check`, проверка зависимостей и проверка состояния репозитория назначения.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: PUB-021 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: PUB-022 — временный скрипт публикации заменяется полноценным release/workflow-слоем

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Целевая архитектура или поведение MUST сохранять следующий target contract: временный скрипт публикации заменяется полноценным release/workflow-слоем.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: PUB-022 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: PUB-023 — ошибка mkdir или любого вызова rsync завершает публикацию с ненулевым кодом и сообщением в st...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: ошибка `mkdir` или любого вызова `rsync` завершает публикацию с ненулевым кодом и сообщением в stderr.

#### Scenario: PUB-023 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-024 — персональные agent-integration файлы IDENTITY.md, SOUL.md, USER.md, TOOLS.md, HEARTBEAT.md, ....

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Zettelkasten-CLI MUST сохранять следующий инвариант: персональные agent-integration файлы `IDENTITY.md`, `SOUL.md`, `USER.md`, `TOOLS.md`, `HEARTBEAT.md`, `.hermes.md`, `.agent-skills/` и внешние managed operational OpenClaw skills не входят в публичный `zettelkasten-cli`; sanitized generic `AGENTS.MD` и repo-local development skills Marta являются публичными development artifacts.

#### Scenario: PUB-024 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: PUB-025 — по явному решению о публикации destination .scripts/, openspec/, skills/ и tests/ синхронизир...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: по явному решению о публикации destination `.scripts/`, `openspec/`, `skills/` и `tests/` синхронизируются как отдельные exact mirrors через `rsync --delete --delete-excluded`; dry-run показывает удаления, а реальное удаление возможно только с `--apply` и только внутри этих destination trees.

#### Scenario: PUB-025 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: PUB-026 — .DS_Store и каталоги __MACOSX/ исключаются из dry-run и реального зеркала публикуемых directo...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Публикация`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `.DS_Store` и каталоги `__MACOSX/` исключаются из dry-run и реального зеркала публикуемых directory trees, а `--delete-excluded` удаляет ранее опубликованные экземпляры из соответствующего destination tree.

#### Scenario: PUB-026 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
