## MODIFIED Requirements

### Requirement: CHECK-002 — zt-check проверяет структуру репозитория, заголовки, обязательные метаданные, известные типы,...

**Baseline legacy status до дельты:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Проверки`.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-check MUST проверять структуру хранилища, title, обязательные metadata, domain types, docfilename/doclink, ссылки, all-todays, .last-diary и Diary chain. Структурная проверка SHALL различать инициализированное пустое хранилище без Diary и повреждение состояния уже существующей цепочки; отсутствие .last-diary допустимо только в первом случае.

#### Scenario: Инициализированный пустой Vault

- **GIVEN** созданы notes/, all-todays/, .scripts/, но Diary ещё нет
- **WHEN** выполнен checker
- **THEN** проверка структуры успешна без искусственного первого Diary

#### Scenario: CHECK-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
