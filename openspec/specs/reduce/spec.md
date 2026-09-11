# reduce Specification

## Purpose

Определить Reduce lifecycle для Topic generations, Memo/Note handling, confirmation, rollback и link semantics.

## Requirements

### Requirement: REDUCE-001 — Reduce создаёт новую версию выбранной активной Topic на основе выбранной Topic и связанных ак...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Reduce создаёт новую версию выбранной активной Topic на основе выбранной Topic и связанных активных Memo.

#### Scenario: REDUCE-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-002 — выбранная исходная Topic переводится в deprecated, новая Topic остаётся активной

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: выбранная исходная Topic переводится в deprecated, новая Topic остаётся активной.

#### Scenario: REDUCE-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-003 — в deprecated переводятся только активные Memo с точным совпадением :key-topic:

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: в deprecated переводятся только активные Memo с точным совпадением `:key-topic:`.

#### Scenario: REDUCE-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-004 — повторный Reduce пропускает уже архивированные Memo

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: повторный Reduce пропускает уже архивированные Memo.

#### Scenario: REDUCE-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-005 — Note автоматически не архивируются

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Note автоматически не архивируются.

#### Scenario: REDUCE-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-006 — активные Note с точным совпадением :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: активные Note с точным совпадением `:key-topic:` связываются с новой Topic.

#### Scenario: REDUCE-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-007 — deprecated Note не связываются с новой Topic

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: deprecated Note не связываются с новой Topic.

#### Scenario: REDUCE-007 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-008 — документы с другим :key-topic

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: документы с другим `:key-topic:` не изменяются.

#### Scenario: REDUCE-008 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-009 — Full Copy не изменяет содержимое тела исходных документов и блоков исходного кода

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Full Copy не изменяет содержимое тела исходных документов и блоков исходного кода.

#### Scenario: REDUCE-009 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-010 — строки, похожие на :doclink:, :docfilename

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: строки, похожие на `:doclink:`, `:docfilename:` и `:deprecated:`, внутри тела и `[source]`-блоков копируются буквально.

#### Scenario: REDUCE-010 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-011 — метаданные изменяются только в заголовке AsciiDoc-документа

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: метаданные изменяются только в заголовке AsciiDoc-документа.

#### Scenario: REDUCE-011 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-012 — старая и новая Topic связываются отношениями развития и основания

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: старая и новая Topic связываются отношениями развития и основания.

#### Scenario: REDUCE-012 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-013 — Reduce создаёт следующую редакцию той же тематической линии и сохраняет точное значение :key-...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Reduce создаёт следующую редакцию той же тематической линии и сохраняет точное значение `:key-topic:` исходной Topic.

#### Scenario: REDUCE-013 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-014 — создаваемая Reduce Topic получает канонические заголовок, :description

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: создаваемая Reduce Topic получает канонические заголовок, `:description:` и текст `:doclink:` из сохранённого `:key-topic:`.

#### Scenario: REDUCE-014 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-015 — интерфейс Reduce называет создаваемый документ следующей редакцией или Clean Successor и не п...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: интерфейс Reduce называет создаваемый документ следующей редакцией или Clean Successor и не предлагает произвольное новое тематическое название.

#### Scenario: REDUCE-015 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-016 — Reduce до первой записи показывает исходную Topic, наследуемый :key-topic:, создаваемую Topic...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Reduce до первой записи показывает исходную Topic, наследуемый `:key-topic:`, создаваемую Topic и полный список документов, которые будут архивированы или связаны.

#### Scenario: REDUCE-016 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-017 — Reduce завершается без изменений, если исходная Topic не содержит непустой :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Reduce завершается без изменений, если исходная Topic не содержит непустой `:key-topic:` или её канонические метаданные противоречат тематическому ключу.

#### Scenario: REDUCE-017 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REDUCE-018 — Reduce не изменяет :key-topic

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Reduce не изменяет `:key-topic:` связанных документов и не используется для неявного выделения новой тематической линии.

#### Scenario: REDUCE-018 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REDUCE-019 — изменение текущего поведения Reduce вводится только вместе с миграционным планом, интеграцион...

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Reduce`.

Development, migration или runtime process MUST соблюдать следующее правило: изменение текущего поведения Reduce вводится только вместе с миграционным планом, интеграционными тестами и синхронным обновлением Feature List и навыка `zt-reduce`.

#### Scenario: REDUCE-019 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
