## ADDED Requirements

### Requirement: ADOC-PARSE-001 — Одинаковый header во всех потребителях

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Constructors validation, Reduce, Refine, Continue, selectors и checker MUST использовать одинаковые правила header boundary. Body-псевдоатрибут SHALL NOT менять metadata или deprecated status. Неоднозначный header MUST отклоняться до mutation.

#### Scenario: Псевдоатрибут после пробельной границы

- **GIVEN** после whitespace-only строки body содержит :deprecated:
- **WHEN** документ проходит parser, selector и Reduce preflight
- **THEN** все считают его активным; parser возвращает только header attrs

#### Scenario: Сломанная граница

- **GIVEN** некорректный header не позволяет безопасно добавить deprecated
- **WHEN** запрошено архивирование
- **THEN** ошибка до изменения всех затронутых файлов

### Requirement: ADOC-PARSE-002 — Примеры не являются рабочими связями

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Dedup, checker, migration, Continue и link removal MUST использовать общий профиль opaque-блоков. Ссылка только в примере SHALL NOT мешать добавлению настоящей связи и SHALL NOT становиться целью автоматической правки.

#### Scenario: Dedup по примеру

- **GIVEN** link:UUID.adoc есть только внутри ---- блока
- **WHEN** добавляется рабочая связь на UUID
- **THEN** добавлена ровно одна рабочая ссылка, пример побайтно сохранён

#### Scenario: Повторный запуск

- **GIVEN** та же рабочая связь уже существует
- **WHEN** добавление повторяется
- **THEN** байты файла не изменяются, нет дубликата

### Requirement: ADOC-PARSE-003 — Удаление связи сохраняет авторский текст

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Refine и Workspace removal MUST изменять только выбранные машинно управляемые элементы ссылки. Bullet со смешанным авторским текстом или несколькими ссылками SHALL сохраняться либо давать NEEDS_MANUAL_EDIT до записи; нельзя удалять целую строку ради одной ссылки.

#### Scenario: Смешанная строка

- **GIVEN** bullet содержит пояснение и две ссылки, удаляется одна
- **WHEN** построен план удаления
- **THEN** другая ссылка и пояснение сохранены либо весь apply отклонён без изменений

#### Scenario: Управляемая строка

- **GIVEN** отдельный элемент в каноническом разделе содержит только выбранную связь
- **WHEN** выполнено remove
- **THEN** удалена только эта строка; остальные sections и mode сохранены

### Requirement: ADOC-PARSE-004 — Конструкторы используют общий нейтральный writer

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Пять публичных object constructors MUST сохранять свои имена, типы и basename stdout, используя общий writer/validator. Общая библиотека SHALL NOT включать Topic policy, fzf, Vim, all-todays или обратные зависимости на objects/plugins.

#### Scenario: Parity constructors

- **GIVEN** имеются fixtures пяти старых constructor interfaces
- **WHEN** выполнен локальный refactoring
- **THEN** согласованные metadata/body/stdout совпадают; policy side effects не появились

#### Scenario: Граница зависимостей

- **GIVEN** проверяется neutral lib
- **WHEN** анализируется source graph
- **THEN** отсутствуют зависимости lib→objects/plugins
