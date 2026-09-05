## MODIFIED Requirements

### Requirement: CHECK-011 — UUID v1 нового постоянного документа проверяется отдельно, поскольку текущий zt-check не пров...

**Baseline legacy status до дельты:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Workflow проверки нового постоянного документа MUST включать UUID v1, version и variant. После внедрения INTEGRITY-002 результат zt-check SHALL удовлетворять этому шагу; отдельная проверка требуется, если используемая версия checker ещё не поддерживает UUID. Нельзя объявлять шаг успешным по одному hex-pattern без version check.

#### Scenario: Новая проверка доступна

- **GIVEN** checker поддерживает INTEGRITY-002
- **WHEN** проверяется новый документ
- **THEN** UUID gate подтверждён результатом checker без утверждения, что zt-check не умеет проверять UUID

#### Scenario: CHECK-011 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract
