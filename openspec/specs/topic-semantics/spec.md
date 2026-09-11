# topic-semantics Specification

## Purpose

Определить canonical Topic presentation, key-topic semantics и правила эволюции тематической линии.

## Requirements

### Requirement: TOPIC-001 — :key-topic

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Topic и тематический ключ`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `:key-topic:` является машинным идентификатором тематической линии; `:description:` и заголовок не используются вместо него.

#### Scenario: TOPIC-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: TOPIC-002 — новая Topic, созданная каноническим генератором, получает заголовок, :description

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Topic и тематический ключ`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: новая Topic, созданная каноническим генератором, получает заголовок, `:description:` и текст `:doclink:` вида `<key-topic> - ключевая тема`.

#### Scenario: TOPIC-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: TOPIC-003 — канонический генератор Topic не создаёт активную Topic с пустым :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Topic и тематический ключ`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: канонический генератор Topic не создаёт активную Topic с пустым `:key-topic:` или с метаданными, противоречащими выбранному тематическому ключу.

#### Scenario: TOPIC-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: TOPIC-004 — существующие Topic с неканоническим заголовком, :description:, :doclink

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Topic и тематический ключ`.

Development, migration или runtime process MUST соблюдать следующее правило: существующие Topic с неканоническим заголовком, `:description:`, `:doclink:` или противоречивым `:key-topic:` изменяются только через явную миграцию.

#### Scenario: TOPIC-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: TOPIC-005 — изменение названия тематической линии и создание следующей редакции той же тематической линии...

**Legacy status:** `INVARIANT`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Topic и тематический ключ`.

Zettelkasten-CLI MUST сохранять следующий инвариант: изменение названия тематической линии и создание следующей редакции той же тематической линии являются разными операциями.

#### Scenario: TOPIC-005 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
