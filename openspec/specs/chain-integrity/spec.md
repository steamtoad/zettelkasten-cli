# chain-integrity Specification

## Purpose

Определить проверяемую корректность Diary и Memo navigation chains до записи и
при read-only validation.

## Requirements

### Requirement: CHAIN-CHECK-001 — Preflight Diary предшествует любой записи

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Проверка цепочек`.

Текущая реализация Zettelkasten-CLI MUST до создания Diary проверить
`.last-diary`: значение является UUID v1 basename, существует в `notes/`, имеет
`:type: diary:` и указывает на хвост без `Следующая запись`. Отсутствующий или
пустой pointer допустим только в инициализированном Vault без Diary.

#### Scenario: Pointer указывает на Note

- **GIVEN** существующая `.last-diary` содержит basename Note
- **WHEN** вызван `zt-diary`
- **THEN** он сообщает `DIARY_POINTER_TYPE` до создания документа или изменения state

#### Scenario: Первая запись

- **GIVEN** в инициализированном Vault нет Diary и `.last-diary`
- **WHEN** вызван `zt-diary`
- **THEN** создаётся один Diary без previous и pointer на его basename

### Requirement: CHAIN-CHECK-002 — Проверка Diary включает граф и хронологию

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Проверка цепочек`.

Текущая реализация Zettelkasten-CLI MUST read-only проверять Diary links на
type, взаимность, единственный previous/next, цикл, единую компоненту, pointer
на единственный хвост и неубывающий `:date:`. Несколько Diary одной даты
допустимы.

#### Scenario: Невзаимность и цикл

- **GIVEN** fixtures с A→B без B→A и с A→B→A
- **WHEN** выполнен `zt-check`
- **THEN** каждый fixture завершается ненулевым статусом с chain diagnostic

#### Scenario: Две записи одной даты

- **GIVEN** взаимная линейная Diary chain с равными date и корректным pointer
- **WHEN** выполнен `zt-check`
- **THEN** chain принята без назначения новых дат или UUID

### Requirement: CHAIN-CHECK-003 — Memo chains различают основную линию, ветки и примеры

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Проверка цепочек`.

Текущая реализация Zettelkasten-CLI MUST разбирать Memo chain links только вне
opaque AsciiDoc blocks. Memo имеет не более одного `Следующее memo`; каждое
основное продолжение и ветка имеют взаимное `Предыдущее memo`; checker отклоняет
неверный type и циклы, но допускает несколько `Ветка:` целей.

#### Scenario: Пример не создаёт ветку

- **GIVEN** единственное `Следующее memo` находится в opaque block
- **WHEN** `zt-continue` создаёт первое реальное продолжение
- **THEN** создаётся link с label `Следующее memo`, а не `Ветка:`

#### Scenario: Ветвление допустимо

- **GIVEN** у Memo есть одна основная линия и две взаимные ветки
- **WHEN** запущен `zt-check`
- **THEN** checker принимает все продолжения, а duplicate основной линии отклоняет
