## ADDED Requirements

### Requirement: PUB-SAFE-001 — Preflight доказывает границы зеркала

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Publisher MUST отклонять равные или взаимно вложенные canonical paths, symlink escape и невалидный allowlist до mkdir/rsync mutation. Он SHALL проверять зависимости и source artifacts заранее.

#### Scenario: Вложенное назначение

- **GIVEN** dst находится внутри src либо является symlink на src
- **WHEN** запрошен --apply
- **THEN** ошибка до записи и удаления; source hashes неизменны

#### Scenario: Корректная пара

- **GIVEN** source и пустой destination независимы
- **WHEN** выполнен dry-run
- **THEN** план содержит только разрешённые деревья и root files

### Requirement: PUB-SAFE-002 — Локальные изменения назначения сохраняются

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Apply MUST отклонять dirty Git destination и unmanaged nonempty destination без подтверждённого предыдущего manifest. Неизвестные изменения SHALL NOT удаляться как stale files. Git add/commit/tag/push/reset автоматически не выполняются.

#### Scenario: Dirty файл внутри scripts

- **GIVEN** назначение содержит незакоммиченную правку .scripts/tool.zsh
- **WHEN** запрошен apply
- **THEN** STATE_CONFLICT; правка побайтно сохранена

#### Scenario: Чистый прошлый релиз

- **GIVEN** destination соответствует проверенному manifest
- **WHEN** план включает удаление прежнего stale artifact
- **THEN** после явного apply stale удалён только в publish scope

### Requirement: PUB-SAFE-003 — Apply использует актуальный preview

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Publisher MUST связывать preview с source/destination fingerprints, allowlist и списком удалений. Изменение любого затронутого файла после preview SHALL аннулировать план и требовать нового preview; noninteractive apply без plan identity SHALL отклоняться.

#### Scenario: Source изменился

- **GIVEN** после dry-run изменён tests файл
- **WHEN** запрошен apply прежнего плана
- **THEN** STATE_CONFLICT без mutation

#### Scenario: План актуален

- **GIVEN** fingerprints совпадают
- **WHEN** выполнен подтверждённый apply
- **THEN** копируется ровно просмотренная версия и выводится её manifest ID

### Requirement: PUB-SAFE-004 — Ошибка зеркала не становится успешным релизом

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Publisher MUST сохранять достаточный backup/manifest до postflight; failure любого rsync или проверки SHALL возвращать ненулевой exit и статус recovery. Итоговая проверка SHALL сравнивать publish artifacts, private exclusions и portable suite; backup не удаляется при unresolved failure.

#### Scenario: Второй mirror отказал

- **GIVEN** первое дерево применено, второй rsync завершился ошибкой
- **WHEN** выполняется recovery
- **THEN** нет Publish copy complete; старое состояние восстановлено либо дан RECOVERY_REQUIRED с backup

#### Scenario: Успешная поставка

- **GIVEN** все деревья применены и portable suite проходит
- **WHEN** выполнен postflight
- **THEN** manifest подтверждён; ни commit, ни push не выполнены
