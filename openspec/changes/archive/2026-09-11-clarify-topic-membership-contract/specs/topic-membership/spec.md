## ADDED Requirements

### Requirement: TOPIC-MEMBER-001 — Неоднозначность линии диагностируется без нормализации

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Checker и preview Reduce MUST показывать все активные Topic точного ключа при неоднозначности. Checker SHALL выдавать WARN AMBIGUOUS_TOPIC_LINE; Reduce SHALL показывать выбранную Topic, siblings, Memo для архивации и Note для связи до подтверждения.

#### Scenario: Два активных Topic

- **GIVEN** валидные Topic имеют один ключ
- **WHEN** запущен checker
- **THEN** предупреждение содержит оба UUID; документы не меняются и одна лишь неоднозначность не делает exit ненулевым

#### Scenario: Отказ от preview

- **GIVEN** preview показывает ранее не связанную Memo того же ключа
- **WHEN** пользователь отменяет Reduce
- **THEN** ни UUID-документ, ни activity entry не создаются

### Requirement: TOPIC-MEMBER-002 — История и активная принадлежность не смешиваются

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Проверка deprecated links MUST различать исторические provenance/chain links и новые active bindings. Ссылки Основано на, Развитие и сохранённая история SHALL оставаться допустимыми. Новый binding к deprecated Topic MUST отклоняться; сомнительную старую ссылку без признака назначения SHALL диагностировать как WARN, не удалять.

#### Scenario: История Reduce

- **GIVEN** активная successor Topic ссылается Основано на архивную Topic
- **WHEN** запущен checker
- **THEN** provenance принята, история сохранена

#### Scenario: Новая связь в архив

- **GIVEN** явно выбран deprecated Topic как новый binding target
- **WHEN** планируется создание связи
- **THEN** отказ до mutation с указанием target

### Requirement: TOPIC-MEMBER-003 — Refine сохраняет отличающийся lifecycle

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Refine MUST до подтверждения отдельно перечислять переносимые документы и все архивируемые невыбранные кандидаты, включая Note при archive-source. Он SHALL NOT наследовать запрет автоматического архивирования Note, принадлежащий Reduce, и SHALL NOT менять key-topic по отображаемому title.

#### Scenario: Archive-source в Refine

- **GIVEN** невыбранная активная Note является кандидатом исходного ключа
- **WHEN** подтверждён Refine с archive-source
- **THEN** Note архивируется по REFINE-011; preview заранее показывал её UUID

#### Scenario: Название отличается от ключа

- **GIVEN** отображаемая фраза не совпадает с key-topic
- **WHEN** готовится binding
- **THEN** тематический ключ берётся только из header, не вычисляется из title
