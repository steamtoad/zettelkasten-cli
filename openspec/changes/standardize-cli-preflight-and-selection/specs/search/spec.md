## MODIFIED Requirements

### Requirement: FZF-002 — поиск и интерактивный выбор используют :description:

**Baseline legacy status до дельты:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Поиск и FZF`.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-edit, zt-getlink и специализированные selectors MUST искать и показывать description. zt-find и zt-read SHALL сохранять literal case-insensitive поиск по всему содержимому активного документа, включая body; description используется для описания ссылок. Эта разница MUST быть явно отражена в README и regression tests.

#### Scenario: Термин только в body

- **GIVEN** активная Note содержит искомую фразу только в body
- **WHEN** запущены find и read
- **THEN** Note присутствует в обеих выдачах; description остаётся описанием ссылки

#### Scenario: FZF-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
