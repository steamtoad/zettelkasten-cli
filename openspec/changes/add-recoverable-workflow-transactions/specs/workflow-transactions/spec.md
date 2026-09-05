## ADDED Requirements

### Requirement: TXN-001 — Manifest и staging предшествуют первой knowledge-записи

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Создание с activity/bindings, Diary, Continue, Reduce, Refine и двусторонний link workflow MUST подготовить manifest всей области изменений, backups и проверенные staged files до изменения существующих документов. Успех SHALL означать успешный postflight всех файлов.

#### Scenario: План невалиден

- **GIVEN** вторая из предполагаемых связей имеет недопустимый target
- **WHEN** подготавливается workflow
- **THEN** ни документ, ни первая связь, ни activity/state не применены

#### Scenario: Успешная операция

- **GIVEN** валидные документы и все storage steps успешны
- **WHEN** выполнен workflow
- **THEN** manifest помечен committed; все взаимные связи и journal согласованы

### Requirement: TXN-002 — Rollback не скрывает собственную ошибку

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Ошибка apply MUST запускать проверяемое восстановление. Если хотя бы один файл не восстановлен, команда SHALL вернуть RECOVERY_REQUIRED с ненулевым exit, перечнем файлов и путём backup; она MUST NOT писать changes rolled back. Backups SHALL сохраняться до подтверждённого recovery.

#### Scenario: Сбой rollback

- **GIVEN** после первой замены вторая запись и одно восстановление отказали
- **WHEN** выполнен rollback
- **THEN** RECOVERY_REQUIRED, backups сохранены, нет ложного утверждения о полном откате

#### Scenario: Полный rollback

- **GIVEN** инъекция apply failure не препятствует восстановлению
- **WHEN** workflow завершён
- **THEN** все исходные хеши/mode восстановлены, новых partial documents нет, код ненулевой

### Requirement: TXN-003 — Устаревший план и конкуренция не перезаписывают данные

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Writer MUST проверять блокировку и source fingerprints перед apply и каждой заменой. Изменение source после plan SHALL давать STATE_CONFLICT; recovery SHALL NOT перезаписывать чужую версию файла. Повторный writer MUST ждать ограниченно либо завершаться LOCKED без изменения Vault.

#### Scenario: Внешняя правка после плана

- **GIVEN** Vim изменил Note между preview и apply
- **WHEN** запрошено применение старого плана
- **THEN** STATE_CONFLICT; правка Vim сохраняется

#### Scenario: Два Diary writers

- **GIVEN** два CLI одновременно используют один хвост
- **WHEN** выполняется создание
- **THEN** операции сериализованы либо одна отклонена; нет двух next от одного хвоста

### Requirement: TXN-004 — Прерванная операция обнаруживается и восстанавливается явно

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

После аварийного прекращения процесса незавершённая transaction MUST обнаруживаться следующим writer и checker. Они SHALL сообщать RECOVERY_REQUIRED; явный recovery SHALL быть идемпотентным и проверять source identity перед restore. Автоматическое удаление unresolved backups запрещено.

#### Scenario: SIGKILL во время apply

- **GIVEN** дочерний процесс завершён после первой файловой замены
- **WHEN** запущен checker и следующий writer
- **THEN** оба видят незавершённую операцию; новая запись не продолжает повреждённое состояние

#### Scenario: Повтор recovery

- **GIVEN** явное восстановление успешно завершено
- **WHEN** тот же recovery запущен второй раз
- **THEN** документы и state не меняются повторно
