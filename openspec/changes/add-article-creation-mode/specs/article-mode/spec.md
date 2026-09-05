## ADDED Requirements

### Requirement: ARTICLE-001 — Article сохраняет модель Note

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zcreate article MUST создавать UUID v1 document в notes/ с type=note, дополнительным :article: и keywords note/article. Все обязательные metadata, activity и flags создания SHALL соблюдать zcreate-workflow; type=article не создаётся.

#### Scenario: Article без редактора

- **GIVEN** заданы title и --no-edit
- **WHEN** выполнен zcreate article
- **THEN** создан валидный Note с article marker, стандартными sections и одним activity entry

### Requirement: ARTICLE-002 — Режим не меняет lifecycle существующих документов

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Article SHALL участвовать в поиске, индексе и lifecycle как Note, включая запрет автоматической deprecation Note в Reduce. Существующие документы MUST оставаться побайтно неизменными при внедрении режима; никакая автоматическая миграция типов не выполняется.

#### Scenario: Reduce линии с Article

- **GIVEN** Article имеет тот же key-topic, что выбранная Topic
- **WHEN** выполнен Reduce
- **THEN** Article остаётся активной Note и получает предусмотренную связь

#### Scenario: Старые Note

- **GIVEN** в хранилище есть обычные Note
- **WHEN** установлена версия с article mode
- **THEN** старые metadata и UUID не изменены
