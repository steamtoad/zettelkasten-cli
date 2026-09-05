## MODIFIED Requirements

### Requirement: FLOW-003 — команды создания постоянных документов автоматически открывают документ в Vim

**Baseline legacy status до дельты:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Workflow`.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Интерактивные команды создания MUST после успешного завершения обязательных файловых изменений открывать созданный документ в Vim. zcreate --no-edit SHALL явно отключать этот шаг без изменения обязательных metadata/activity/bindings. Ошибка открытия редактора MUST диагностироваться отдельно от уже committed создания и не отменять сохранённое знание.

#### Scenario: No-edit как явное исключение

- **GIVEN** объект и обязательные связи успешно committed через zcreate --no-edit
- **WHEN** workflow завершает создание
- **THEN** Vim не запускается, итоговая ссылка выведена; при обычном интерактивном вызове открытие сохраняется

#### Scenario: FLOW-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
