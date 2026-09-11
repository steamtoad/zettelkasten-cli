# migration-coverage Specification

## Purpose

Определить проверяемое покрытие входящих ссылок при переносе root UUID-документов в `notes/`.

## Requirements

### Requirement: MIGRATE-LINK-001 — Dry-run содержит полную проверяемую область

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Миграции`.

Migration MUST до apply построить manifest moved objects, всех найденных in-vault incoming links, исходных хешей и rewrite decisions. Неподдерживаемый source SHALL блокировать apply до первого move и перечисляться в preview.

#### Scenario: Корневой overview

- **GIVEN** overview.adoc ссылается на root UUID.adoc
- **WHEN** выполнен dry-run
- **THEN** план включает перенос UUID и преобразование overview link на notes/UUID.adoc

#### Scenario: Необрабатываемый источник

- **GIVEN** внутренний источник содержит неоднозначный link syntax
- **WHEN** запрошен apply
- **THEN** отказ происходит до первого move

### Requirement: MIGRATE-LINK-002 — Относительные ссылки преобразуются от физического source

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Миграции`.

Apply MUST сохранять UUID и link description, вычисляя новый relative target от будущего source path. Корневые страницы, all-todays, Workspace и доступные plugin sources SHALL проходить этот resolver; examples и внешние URL не переписываются.

#### Scenario: Смешанный граф

- **GIVEN** есть root overview, moved Note и Workspace с ссылками на moved объект
- **WHEN** применена миграция
- **THEN** все рабочие ссылки разрешимы из новых source paths; descriptions и примеры неизменны

#### Scenario: Коллизия назначения

- **GIVEN** notes уже содержит целевой basename
- **WHEN** запрошен apply
- **THEN** ошибка без переименования UUID и без потери обоих файлов

### Requirement: MIGRATE-LINK-003 — Postflight предшествует удалению backup

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Миграции`.

Migration MUST после apply проверять весь manifest графа и `zt-check`. Backup SHALL удаляться только после успешной проверки; ошибка SHALL приводить к recovery, а не Migration complete.

#### Scenario: Сломанная корневая ссылка после apply

- **GIVEN** инъекция оставила старую цель в overview
- **WHEN** выполнен postflight
- **THEN** операция не объявлена успешной; исходные bytes восстановлены, а backup сохранён

#### Scenario: Повтор миграции

- **GIVEN** миграция уже успешно завершена
- **WHEN** повторён dry-run или apply
- **THEN** apply не выполняет записи и явно сообщает отсутствие работы
