## Purpose

Определить строгую read-only проверку схемы, UUID v1 и семантических metadata каждого постоянного документа Zettelkasten.

## ADDED Requirements

### Requirement: INTEGRITY-001 — Каждый файл получает проверку даже при отсутствии строк

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-check MUST отдельно диагностировать zero-byte файл, отсутствие title и обязательного атрибута, дубли имён header-атрибутов, некорректные date/type/docfilename/doclink. Диагностика SHALL включать путь и стабильный код; любой ERROR SHALL давать ненулевой итоговый exit.

#### Scenario: Пустой файл

- **GIVEN** валидный fixture дополнен notes/empty.adoc
- **WHEN** запущен zt-check
- **THEN** получен ERROR EMPTY_DOCUMENT с именем файла и ненулевой exit

#### Scenario: Схема нарушена

- **GIVEN** отдельные fixtures содержат дубли type, дату 2026-02-30 и type=index внутри notes/UUID.adoc
- **WHEN** запущен checker для каждого fixture
- **THEN** каждый fixture отклонён; исходные хеши не изменены

### Requirement: INTEGRITY-002 — UUID v1 проверяется при генерации и диагностике

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Constructor MUST валидировать stdout UUID provider до создания destination. zt-check SHALL проверять UUID v1 постоянных документов по точному формату, version и variant; непустой текст и произвольные hex-группы недостаточны.

#### Scenario: Не UUID v1

- **GIVEN** provider возвращает UUID v4, not-a-uuid, лишнюю строку либо некорректный variant
- **WHEN** вызван constructor
- **THEN** отказ до создания документа; существующие документы неизменны

#### Scenario: UUID v1 принимается

- **GIVEN** корректный UUID v1 с разным регистром hex
- **WHEN** проверяется документ с согласованным именем
- **THEN** проверка UUID успешна без изменения регистра или имени

### Requirement: INTEGRITY-003 — Однострочные поля проверяются до записи

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Общие constructors и workflow MUST отклонять LF/CR и пустые после проверки пробелов обязательные title/description/key-topic; extra attrs SHALL сохранять запрет reserved/duplicate имён. Значения keywords/author/date MUST соблюдать ту же однострочность. Ошибка SHALL NOT создавать документ, связи или all-todays entry.

#### Scenario: Header injection через title

- **GIVEN** title содержит Title LF :deprecated:
- **WHEN** вызван note constructor
- **THEN** ненулевой exit; нового файла и journal entry нет

#### Scenario: Спецсимволы допустимого текста

- **GIVEN** title содержит кириллицу, пробелы, кавычки, обратный слеш и квадратные скобки
- **WHEN** создан Note
- **THEN** title и description сохраняют текст; сформированная ссылка корректно отображает его после Asciidoctor render

### Requirement: INTEGRITY-004 — Topic и self-link проверяются семантически

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Для активной Topic zt-check MUST требовать непустой key-topic и канонические title/description/doclink. Self-link MUST ссылаться на basename файла и использовать description с корректным AsciiDoc escaping; пустая или незавершённая ссылка SHALL отклоняться.

#### Scenario: Topic без key

- **GIVEN** у активной Topic удалён key-topic
- **WHEN** запущен checker
- **THEN** ERROR TOPIC_METADATA; checker не исправляет её автоматически

#### Scenario: Deprecated не отменяет базовую схему

- **GIVEN** архивная Note потеряла обязательный docfilename
- **WHEN** запущен checker
- **THEN** базовая ошибка обнаружена, даже если Note исключается из обычного поиска
