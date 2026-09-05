## ADDED Requirements

### Requirement: RUNTIME-GATE-001 — Каждый runtime contract связан с поведением

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Traceability matrix MUST связывать requirement ID с primary test, observable assertions, platform, результатом и revision исходников. Проверка наличия Scenario/ID SHALL NOT считаться доказательством runtime implementation.

#### Scenario: Текст есть, поведения нет

- **GIVEN** ID присутствует в OpenSpec, но runtime тест отсутствует
- **WHEN** оценивается release readiness
- **THEN** requirement отмечен UNVERIFIED; release gate не засчитывает text grep как PASS

#### Scenario: Доказанный контракт

- **GIVEN** тест проверяет байты/exit/links для заданного ID на revision
- **WHEN** строится матрица
- **THEN** сохранены тест, платформа, revision и результат

### Requirement: RUNTIME-GATE-002 — Регрессия включает отрицательные сценарии аудита

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Portable suite MUST включать воспроизведения G01–G09 и совместимость G10: failed writes, empty files, invalid input, chains, code examples, migration incoming links, clean distribution, publisher conflict и LF idempotency. Tests SHALL проверять неизменность файлов вне scope и реальные bytes/exit, не копии реализации.

#### Scenario: Дефект Reduce возвращён

- **GIVEN** в контролируемой mutation исходника восстановлено игнорирование write error
- **WHEN** запущен primary regression
- **THEN** тест падает на потере/ложном успехе, даже если ID checker зелёный

#### Scenario: Все supported workflows

- **GIVEN** проверяются позитивные сценарии и отказ на каждом существенном write step
- **WHEN** выполнен suite во временном ZK_HOME
- **THEN** есть отдельные результаты и доказательства сохранности чужих файлов

### Requirement: RUNTIME-GATE-003 — Платформы и skips отражаются достоверно

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Release validation MUST запускать zsh syntax, portable tests и supported dependency checks на macOS и Linux. Отсутствие обязательного инструмента SHALL давать failure; optional live routing SHALL быть SKIP без сетевого запуска по умолчанию. Релиз не объявляется cross-platform по одному macOS прогону.

#### Scenario: Linux UUID

- **GIVEN** на Linux доступен uuidgen -t
- **WHEN** проверяется создание
- **THEN** UUID v1 реально подтверждён; Darwin uuid ветка не имитируется вместо него

#### Scenario: Агент не подключён

- **GIVEN** ZK_RUN_LIVE_ROUTING не включён
- **WHEN** выполнен portable suite
- **THEN** live test явно SKIP; runtime core проверен независимо

### Requirement: RUNTIME-GATE-004 — Готовность поставки основана на проверках

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Release evidence MUST включать source revision, artifact hashes, portable clean-install result, platform matrix, resolved/unresolved defects и recovery limitations. Новые deltas SHALL переходить в baseline/IMPLEMENTED только после доказанной реализации и exact-once legacy synchronization.

#### Scenario: Существуют незавершённые задачи

- **GIVEN** у Change есть unchecked tasks либо failed regression
- **WHEN** запрошена отметка implemented/archive
- **THEN** gate отклоняет повышение статуса

#### Scenario: Change архивирован

- **GIVEN** archive contract корректно перенесён в baseline и historical archive
- **WHEN** запущена последующая регрессия
- **THEN** тест не падает только из-за отсутствия прежнего active change directory

### Requirement: RUNTIME-GATE-005 — Документация точно описывает пределы проверок

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Feature List, README и отчёты tooling MUST различать read-only dump zt-scripts-review, структурный OpenSpec checker, runtime tests и optional integration. Они SHALL NOT объявлять все гарантии проверенными по одному успешному zt-check или текстовой трассируемости; известные recovery/performance ограничения должны быть названы.

#### Scenario: Выгрузка скриптов

- **GIVEN** zt-scripts-review только печатает содержимое
- **WHEN** обновляется документация команды
- **THEN** она описана как инструмент инспекции, не автоматический анализатор корректности

#### Scenario: Неполная проверка

- **GIVEN** suite пропустил optional live routing и не запускался на Linux
- **WHEN** готовится release report
- **THEN** SKIP и непроверенная платформа названы явно, без заявления о полной переносимости
