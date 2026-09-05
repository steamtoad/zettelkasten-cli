## ADDED Requirements

### Requirement: VAULT-001 — Выбранный корень прозрачен

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-vault path/status MUST показывать resolved data root, источник выбора root, наличие notes/all-todays/.scripts и Diary state, отдельно от source checkout. Они SHALL не создавать недостающие каталоги и не менять ZK_HOME глобально.

#### Scenario: Explicit root

- **GIVEN** --root и ZK_HOME указывают в разные каталоги
- **WHEN** выполнен path
- **THEN** показан --root и причина приоритета; оба каталога неизменны

### Requirement: VAULT-002 — Check использует выбранную область

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-vault check MUST запускать integrity checks только для явно resolved Vault с теми же diagnostics и exit codes. Несуществующий root SHALL давать NOT_FOUND без fallback в другое хранилище.

#### Scenario: Опечатка root

- **GIVEN** --root указывает отсутствующий каталог
- **WHEN** выполнен check
- **THEN** NOT_FOUND; не прочитано и не изменено запасное хранилище
