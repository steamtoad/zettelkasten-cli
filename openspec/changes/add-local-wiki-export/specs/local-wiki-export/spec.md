## ADDED Requirements

### Requirement: WIKI-001 — Экспорт остаётся производным и локальным

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-wiki export MUST по явному --apply создавать HTML-view из разрешённых AsciiDoc sources в выбранном output, сохраняя knowledge hashes. Default dry-run SHALL не писать файлы; сеть, hosting и публикация не выполняются.

#### Scenario: Dry-run

- **GIVEN** указан допустимый output
- **WHEN** выполнен export без --apply
- **THEN** показан manifest страниц; Vault и output неизменны

### Requirement: WIKI-002 — Ссылки и deprecation не расширяют область

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Экспорт MUST сохранять отображаемые descriptions и UUID identity в mapping страниц. Active-to-active ссылки SHALL разрешаться локально; исключённые deprecated targets помечаются как неэкспортированные references. Renderer SHALL не обходить unsafe includes и symlink escape.

#### Scenario: Историческая ссылка

- **GIVEN** активная Note ссылается на deprecated Topic
- **WHEN** экспортирован default view
- **THEN** история обозначена без экспорта содержимого архивной Topic

#### Scenario: Include наружу

- **GIVEN** документ содержит include за пределы Vault
- **WHEN** выполнен export preflight
- **THEN** ошибка до чтения внешнего файла и до публикации output

### Requirement: WIKI-003 — Чужой output не уничтожается

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Apply MUST писать в пустой output либо в scope предыдущего совпавшего export manifest. Ошибка render SHALL сохранять прежнюю complete generation; чужие файлы не удаляются. Удаление wiki output SHALL не влиять на Vault.

#### Scenario: Ошибка render

- **GIVEN** новая generation не отрендерилась
- **WHEN** выполняется apply
- **THEN** прежний output сохранён, ненулевой exit, source hashes неизменны
