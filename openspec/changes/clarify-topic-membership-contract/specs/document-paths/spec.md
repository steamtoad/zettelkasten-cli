## MODIFIED Requirements

### Requirement: DATA-004 — Topic агрегирует только явно связанные с ней Memo и Note

**Baseline legacy status до дельты:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Физическое пространство документов`.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Topic MUST агрегировать в своём навигационном содержимом только явно связанные Memo и Note. Принадлежность тематической линии SHALL определяться отдельно точным header key-topic; Reduce MUST сохранять выборку REDUCE-003/006 по этому ключу независимо от наличия прямой ссылки. Несколько активных Topic одного ключа SHALL NOT автоматически объединяться или архивироваться, согласно DEPR-008.

#### Scenario: Memo без прямой ссылки

- **GIVEN** Memo имеет тот же key-topic, но не включена в явные links Topic
- **WHEN** готовится Reduce выбранной Topic
- **THEN** Memo включена в preview архивации; отсутствие прямой ссылки не меняет REDUCE-003

#### Scenario: Siblings сохраняются

- **GIVEN** две активные Topic имеют один ключ
- **WHEN** Reduce выполнен для одной Topic
- **THEN** другая Topic остаётся активной; глобальная уникальность не навязана

#### Scenario: DATA-004 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
