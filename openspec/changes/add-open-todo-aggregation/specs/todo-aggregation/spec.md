## ADDED Requirements

### Requirement: TASKS-001 — Сканируются все активные типы

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-tasks MUST read-only собирать все рабочие строки * [ ] из активных note/memo/todo/diary/topic внутри notes/. Deprecated документы, closed * [x], opaque examples, Inbox и Knowledge SHALL исключаться.

#### Scenario: Задачи разных типов

- **GIVEN** Note и Memo содержат открытые задачи, Todo содержит закрытую, deprecated Diary содержит открытую
- **WHEN** запущен aggregator
- **THEN** выведены только две активные открытые задачи

#### Scenario: Пример checkbox

- **GIVEN** * [ ] находится только в ----
- **WHEN** запущен aggregator
- **THEN** пример не выведен как задача

### Requirement: TASKS-002 — Каждая задача сохраняет источник и положение

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Output MUST сохранять буквальный текст каждой задачи, source basename/description и source line; одинаковые задачи в разных документах SHALL оставаться отдельными. Порядок SHALL быть детерминированным по basename и line; ссылки generated root view используют notes/UUID.adoc.

#### Scenario: Одинаковый текст

- **GIVEN** два документа содержат одинаковую задачу
- **WHEN** сформирован list
- **THEN** есть две записи с разными source links и правильными line numbers

#### Scenario: Нет открытых задач

- **GIVEN** в активных файлах нет открытых checkbox
- **WHEN** запущен aggregator
- **THEN** валидный пустой list, exit 0, Vault не изменён

### Requirement: TASKS-003 — Ошибки чтения не становятся полным успешным результатом

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Aggregator MUST выдавать ненулевой exit и source diagnostic при unreadable/invalid persistent document, влияющем на полноту scan. Он SHALL NOT изменять notes, all-todays или state.

#### Scenario: Один документ не читается

- **GIVEN** среди источников есть unreadable Note
- **WHEN** запущен aggregator
- **THEN** ненулевой exit; вывод не объявлен полным; хеши остальных файлов сохранены
