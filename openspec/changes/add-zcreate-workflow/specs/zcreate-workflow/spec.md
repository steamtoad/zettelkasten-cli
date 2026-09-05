## ADDED Requirements

### Requirement: ZCREATE-001 — Пять типов и совместимые entrypoints

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zcreate MUST поддерживать note, memo, todo, diary, topic и keytopic как alias topic, сохраняя UUID v1, notes/ layout и domain types. Прежние creation entrypoints SHALL сохранять prompts, title conventions, bindings, Vim и итоговую ссылку через общий workflow.

#### Scenario: Пять типов

- **GIVEN** заданы допустимые аргументы для каждого типа
- **WHEN** созданы пять объектов
- **THEN** type, metadata, filenames и canonical templates соответствуют прежним контрактам

#### Scenario: Старый entrypoint

- **GIVEN** пользователь вызывает zt-memo
- **WHEN** проверяется workflow после миграции
- **THEN** сохранены датированный title, optional Topic selection и activity

### Requirement: ZCREATE-002 — No-edit не требует терминала

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zcreate --no-edit MUST завершаться без Vim/fzf/read prompts при полном наборе аргументов. Отсутствующие обязательные title или binding decisions SHALL давать usage error до записи. Успех SHALL выводить ровно одну готовую ссылку; --print-link закрепляет тот же stdout contract.

#### Scenario: Pipeline

- **GIVEN** stdin закрыт, title и параметры заданы
- **WHEN** выполнен zcreate note с --no-edit --print-link
- **THEN** нет вызовов редактора/selector; stdout одна ссылка; exit 0

#### Scenario: Не хватает title

- **GIVEN** stdin закрыт, title не задан для memo
- **WHEN** выполнен zcreate memo --no-edit
- **THEN** usage error без записи и ожидания ввода

### Requirement: ZCREATE-003 — Создание включает полный согласованный workflow

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zcreate MUST создавать объект, обязательные взаимные bindings и один all-todays entry в общей transaction. Для Diary SHALL обновляться chain и .last-diary по chain-integrity; constructors сами эти обязанности не получают.

#### Scenario: Отказ journal

- **GIVEN** объект подготовлен, запись all-todays отказала
- **WHEN** workflow выполняет recovery
- **THEN** нет успешного success-link; исходное состояние восстановлено либо явный RECOVERY_REQUIRED

#### Scenario: Создание без binding

- **GIVEN** Note создана без параметров связи
- **WHEN** workflow успешно завершён
- **THEN** одна Note и один activity entry, дополнительных связей нет

### Requirement: ZCREATE-004 — Date и родительские связи имеют явную семантику

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

--date YYYY-MM-DD MUST задавать document date и датированную часть стандартного title, сохраняя activity в день фактической операции. --link/--keytopic SHALL проверять активный тип цели и наследовать точный header key-topic. Несогласованные одновременно заданные родители MUST отклоняться; backdated Diary не может молча нарушать chain chronology.

#### Scenario: Дата Memo в прошлом

- **GIVEN** указан --date 2026-08-01
- **WHEN** Memo создаётся позднее
- **THEN** metadata/title используют заданную дату; activity находится в дне операции

#### Scenario: Несогласованные связи

- **GIVEN** родитель Memo имеет один key-topic, --keytopic указывает Topic другого ключа
- **WHEN** создаётся Note
- **THEN** отказ до записи с перечислением двух конфликтующих родителей

### Requirement: ZCREATE-005 — Template и context не обходят canonical metadata

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

--template MUST принимать явный разрешённый AsciiDoc body template без исполнения кода или overrides reserved attrs. --context SHALL выбирать среди активных кандидатов с UUID identity; в --no-edit context MUST быть явно разрешён без интерактивности. Context сам по себе не добавляет links.

#### Scenario: Шаблон пытается сменить тип

- **GIVEN** template содержит override header type либо executable include
- **WHEN** выполнен create
- **THEN** template отклонён до записи

#### Scenario: Контекст выбран явно

- **GIVEN** задан допустимый context из активных документов без --link
- **WHEN** выполнен --no-edit
- **THEN** создание не запускает fzf и не создаёт неоговорённые связи
