# refine Specification

## Purpose

Определить выделение новой тематической линии, explicit selection, mutation scope, rollback и archival behavior.

## Requirements

### Requirement: REFINE-001 — выделение новой тематической линии выполняется отдельной от Reduce командой zt-refine

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: выделение новой тематической линии выполняется отдельной от Reduce командой `zt-refine`.

#### Scenario: REFINE-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-002 — операция запрашивает новый :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: операция запрашивает новый `:key-topic:` и создаёт каноническую Topic с соответствующими заголовком, `:description:` и `:doclink:`.

#### Scenario: REFINE-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-003 — пользователь явно выбирает документы, которые должны получить новый тематический ключ и связь...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: пользователь явно выбирает документы, которые должны получить новый тематический ключ и связь с новой Topic.

#### Scenario: REFINE-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-004 — операция не изменяет тематический ключ и связи документов вне явно подтверждённой области

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Zettelkasten-CLI MUST сохранять следующий инвариант: операция не изменяет тематический ключ и связи документов вне явно подтверждённой области.

#### Scenario: REFINE-004 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: REFINE-005 — до применения операция показывает dry-run со списком создаваемых документов, изменений :key-t...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: до применения операция показывает dry-run со списком создаваемых документов, изменений `:key-topic:`, новых и удаляемых связей и deprecated-меток.

#### Scenario: REFINE-005 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-006 — архивирование исходной Topic является отдельным явным решением и не следует автоматически из...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: архивирование исходной Topic является отдельным явным решением и не следует автоматически из создания новой тематической линии.

#### Scenario: REFINE-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-007 — исходная и новая Topic получают взаимные ссылки происхождения, не подменяющие тематический ключ

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: исходная и новая Topic получают взаимные ссылки происхождения, не подменяющие тематический ключ.

#### Scenario: REFINE-007 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-008 — операция собирает изменения в staging-области и восстанавливает существующие документы при ош...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: операция собирает изменения в staging-области и восстанавливает существующие документы при ошибке применения или прерывании.

#### Scenario: REFINE-008 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-009 — кандидатами для переноса являются только активные Memo, Note, Todo и Diary с точным исходным...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: кандидатами для переноса являются только активные Memo, Note, Todo и Diary с точным исходным `:key-topic:`.

#### Scenario: REFINE-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-010 — Refine отклоняет новый тематический ключ, если он пуст, совпадает с исходным или уже использу...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Refine отклоняет новый тематический ключ, если он пуст, совпадает с исходным или уже используется активной Topic.

#### Scenario: REFINE-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-011 — при явном архивировании исходной Topic выбранные документы переносятся в новую тематическую л...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: при явном архивировании исходной Topic выбранные документы переносятся в новую тематическую линию, а все невыбранные активные документы-кандидаты архивируются вместе с исходной Topic.

#### Scenario: REFINE-011 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-012 — выбранные документы теряют взаимные ссылки с исходной Topic и получают взаимные ссылки с ново...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: выбранные документы теряют взаимные ссылки с исходной Topic и получают взаимные ссылки с новой Topic.

#### Scenario: REFINE-012 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-013 — новая Topic регистрируется в all-todays, открывается в Vim, а её ссылка выводится после завер...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: новая Topic регистрируется в `all-todays`, открывается в Vim, а её ссылка выводится после завершения.

#### Scenario: REFINE-013 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: REFINE-014 — Refine читает управляющие атрибуты только из заголовка AsciiDoc-документа

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Выделение новой тематической линии`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: Refine читает управляющие атрибуты только из заголовка AsciiDoc-документа.

#### Scenario: REFINE-014 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure
