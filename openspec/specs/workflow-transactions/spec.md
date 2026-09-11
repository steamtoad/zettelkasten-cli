# workflow-transactions Specification

## Purpose

Определить persistent manifest, staging, rollback, locking и явное recovery многофайловых mutating workflows.

## Requirements

### Requirement: TXN-001 — Manifest и staging предшествуют первой knowledge-записи

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Восстановимые workflow transactions`.

Создание с activity/bindings, Diary, Continue, Reduce, Refine и двусторонний link workflow MUST подготовить manifest всей области изменений, backups и проверенные staged files до изменения существующих документов. Успех SHALL означать успешный postflight всех файлов.

#### Scenario: План невалиден

- **GIVEN** вторая из предполагаемых связей имеет недопустимый target
- **WHEN** подготавливается workflow
- **THEN** ни документ, ни первая связь, ни activity/state SHALL NOT быть применены

#### Scenario: Успешная операция

- **GIVEN** валидные документы и все storage steps успешны
- **WHEN** выполнен workflow
- **THEN** transaction status SHALL быть `committed`
- **AND** все взаимные связи и journal SHALL быть согласованы

### Requirement: TXN-002 — Rollback не скрывает собственную ошибку

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Восстановимые workflow transactions`.

Ошибка apply MUST запускать проверяемое восстановление. Если хотя бы один файл не восстановлен, команда SHALL вернуть `RECOVERY_REQUIRED` с ненулевым exit, перечнем файлов и путём backup; она MUST NOT писать `changes rolled back`. Backups SHALL сохраняться до подтверждённого recovery.

#### Scenario: Сбой rollback

- **GIVEN** после первой замены вторая запись и одно восстановление отказали
- **WHEN** выполнен rollback
- **THEN** результат SHALL содержать `RECOVERY_REQUIRED`, а backups SHALL сохраниться
- **AND** ложное утверждение о полном откате SHALL NOT выводиться

#### Scenario: Полный rollback

- **GIVEN** инъекция apply failure не препятствует восстановлению
- **WHEN** workflow завершён
- **THEN** все исходные hashes и modes SHALL быть восстановлены
- **AND** новые partial documents SHALL отсутствовать, а exit SHALL быть ненулевым

### Requirement: TXN-003 — Устаревший план и конкуренция не перезаписывают данные

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Восстановимые workflow transactions`.

Writer MUST проверять блокировку и source fingerprints перед apply и каждой заменой. Изменение source после plan SHALL давать `STATE_CONFLICT`; recovery SHALL NOT перезаписывать чужую версию файла. Повторный writer MUST ждать ограниченно либо завершаться `LOCKED` без изменения Vault.

#### Scenario: Внешняя правка после плана

- **GIVEN** Vim изменил Note между preview и apply
- **WHEN** запрошено применение старого плана
- **THEN** workflow SHALL завершиться `STATE_CONFLICT`
- **AND** правка Vim SHALL сохраниться

#### Scenario: Два Diary writers

- **GIVEN** два CLI одновременно используют один хвост
- **WHEN** выполняется создание
- **THEN** операции SHALL быть сериализованы либо одна SHALL быть отклонена
- **AND** два `next` от одного хвоста SHALL NOT появиться

### Requirement: TXN-004 — Прерванная операция обнаруживается и восстанавливается явно

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Восстановимые workflow transactions`.

После аварийного прекращения процесса незавершённая transaction MUST обнаруживаться следующим writer и checker. Они SHALL сообщать `RECOVERY_REQUIRED`; явный recovery SHALL быть идемпотентным и проверять source identity перед restore. Автоматическое удаление unresolved backups запрещено.

#### Scenario: SIGKILL во время apply

- **GIVEN** дочерний процесс завершён после первой файловой замены
- **WHEN** запущен checker и следующий writer
- **THEN** оба SHALL увидеть незавершённую операцию
- **AND** новая запись SHALL NOT продолжить повреждённое состояние

#### Scenario: Повтор recovery

- **GIVEN** явное восстановление успешно завершено
- **WHEN** тот же recovery запущен второй раз
- **THEN** документы и state SHALL NOT измениться повторно
