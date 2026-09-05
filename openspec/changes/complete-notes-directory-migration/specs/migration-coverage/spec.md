## ADDED Requirements

### Requirement: MIGRATE-LINK-001 — Dry-run содержит полную проверяемую область

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Migration MUST до apply построить manifest moved objects, всех найденных in-vault incoming links, исходных хешей и rewrite decisions. Неподдерживаемый target, неоднозначный body или источник вне writable scope SHALL блокировать apply и перечисляться в preview.

#### Scenario: Корневой overview

- **GIVEN** overview.adoc ссылается на root UUID.adoc
- **WHEN** выполнен dry-run
- **THEN** план включает перенос UUID и преобразование overview link на notes/UUID.adoc

#### Scenario: Необрабатываемый источник

- **GIVEN** внутренний источник содержит неоднозначный link syntax
- **WHEN** запрошен apply
- **THEN** отказ до первого move; список непокрытых ссылок доступен

### Requirement: MIGRATE-LINK-002 — Относительные ссылки преобразуются от физического source

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Apply MUST сохранять UUID и link description, вычисляя новый relative target от будущего source path. Корневые страницы, all-todays, Workspace и доступные plugin sources SHALL проходить этот же resolver; examples и внешние URL не переписываются.

#### Scenario: Смешанный граф

- **GIVEN** есть root overview, moved Note и Workspace с ссылками на moved объект
- **WHEN** применена миграция
- **THEN** все рабочие ссылки разрешимы из новых source paths; descriptions и примеры неизменны

#### Scenario: Коллизия назначения

- **GIVEN** notes уже содержит целевой basename
- **WHEN** запрошен apply
- **THEN** ошибка без переименования UUID и без потери обоих файлов

### Requirement: MIGRATE-LINK-003 — Postflight предшествует удалению backup

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Migration MUST после apply проверять весь manifest графа, metadata, Diary state и zt-check. Backup SHALL удаляться только после успешной проверки; ошибка SHALL приводить к проверяемому recovery, а не Migration complete.

#### Scenario: Сломанная корневая ссылка после apply

- **GIVEN** инъекция оставила старую цель в overview
- **WHEN** выполнен postflight
- **THEN** операция не объявлена успешной; backup сохранён либо исходные хеши восстановлены

#### Scenario: Повтор миграции

- **GIVEN** миграция уже успешно завершена
- **WHEN** повторён dry-run или apply
- **THEN** dry-run сообщает ноль переносов; apply не выполняет записи и явно сообщает отсутствие работы
