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

Object constructor Topic MUST отклонять пустую строку key-topic и отсутствующий обязательный key-topic до создания destination или изменения существующих файлов, как при standalone CLI, так и при sourced вызове. Ошибка SHALL давать ненулевой статус с диагностикой поля без итогового filename; допустимый непустой ключ SHALL сохраняться буквально. Вызывающий workflow SHALL NOT добавлять activity, связи или запускать editor после отказа constructor.

#### Scenario: TOPIC-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Пустой либо отсутствующий ключ при прямом создании

- **GIVEN** snapshots временного ZK_HOME и валидный непустой title
- **WHEN** Topic constructor вызван с пустой строкой key-topic либо без обязательного key-topic, отдельно через CLI и sourced function
- **THEN** каждый вызов возвращает ненулевой статус с указанием key-topic; UUID.adoc не создан, существующие файлы неизменны и filename не напечатан

#### Scenario: Ошибка constructor проходит через workflow

- **GIVEN** creation workflow получает от Topic constructor отказ preflight key-topic
- **WHEN** workflow обрабатывает результат
- **THEN** статус ненулевой; нет новых activity entries, bindings, запуска editor и итогового success-link

#### Scenario: Допустимый ключ сохранён

- **GIVEN** непустой допустимый key-topic с кириллицей и пробелами
- **WHEN** Topic создаётся через constructor и канонический workflow
- **THEN** код 0; документ содержит обязательные metadata и переданный key-topic без подмены; canonical workflow сохраняет согласованность title/description/doclink с ключом

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
