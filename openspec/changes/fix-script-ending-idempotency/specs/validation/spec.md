## MODIFIED Requirements

### Requirement: CHECK-006 — zt-scripts-patch исправляет отсутствие завершающего LF

**Baseline legacy status до дельты:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-scripts-patch MUST исправлять только отсутствие завершающего LF у непустого shell-файла, сохраняя файл с существующим LF побайтно. Повторный запуск SHALL быть идемпотентным; форматирование не заменяет функциональную проверку скриптов.

#### Scenario: Корректный файл

- **GIVEN** непустой .zsh уже оканчивается одним или несколькими LF
- **WHEN** fixer выполнен два раза
- **THEN** размер, hash и mode не меняются

#### Scenario: Отсутствует LF

- **GIVEN** непустой файл заканчивается буквой
- **WHEN** fixer выполнен два раза
- **THEN** первый запуск дописывает один LF; второй не меняет байты

#### Scenario: CHECK-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
