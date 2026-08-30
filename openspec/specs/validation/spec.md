# validation Specification

## Purpose

Определить canonical validation behavior, agent verification minimums и roadmap integrity checks.

## Requirements

### Requirement: CHECK-001 — zt-check выполняет проверку без автоматического изменения документов

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-check` выполняет проверку без автоматического изменения документов.

#### Scenario: CHECK-001 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHECK-002 — zt-check проверяет структуру репозитория, заголовки, обязательные метаданные, известные типы,...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-check` проверяет структуру репозитория, заголовки, обязательные метаданные, известные типы, `:docfilename:`, `:doclink:`, ссылки, `all-todays`, `.last-diary` и существование элементов diary-цепочки.

#### Scenario: CHECK-002 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHECK-003 — zt-check игнорирует псевдометаданные и ссылки внутри блоков исходного кода

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-check` игнорирует псевдометаданные и ссылки внутри блоков исходного кода.

#### Scenario: CHECK-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHECK-004 — изменяющие структуру или данные операции завершаются запуском zt-check

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: изменяющие структуру или данные операции завершаются запуском `zt-check`.

#### Scenario: CHECK-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-005 — zt-check должен проверять deprecated-семантику, взаимность diary-цепочки и структуру постоянн...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: `zt-check` должен проверять deprecated-семантику, взаимность diary-цепочки и структуру постоянных индексов, если такие индексы появятся.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-005 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-006 — zt-scripts-patch исправляет отсутствие завершающего LF

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-scripts-patch` исправляет отсутствие завершающего LF; его назначение не следует смешивать с функциональной проверкой скриптов.

#### Scenario: CHECK-006 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHECK-007 — zt-scripts-review может использоваться для автоматического анализа качества скриптов

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: `zt-scripts-review` может использоваться для автоматического анализа качества скриптов.

#### Scenario: CHECK-007 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHECK-008 — интеграционные тесты выполняются на временном Zettelkasten и не изменяют рабочее хранилище

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: интеграционные тесты выполняются на временном Zettelkasten и не изменяют рабочее хранилище.

#### Scenario: CHECK-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-009 — нужны интеграционные сценарии Note→Memo, Memo→Topic, обычного/повторного/Full Copy Reduce и R...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: нужны интеграционные сценарии Note→Memo, Memo→Topic, обычного/повторного/Full Copy Reduce и Reduce с deprecated Note.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-009 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-010 — каждый постоянный документ, созданный агентом, до завершения задачи проходит минимальный набо...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Zettelkasten-CLI MUST сохранять следующий инвариант: каждый постоянный документ, созданный агентом, до завершения задачи проходит минимальный набор проверок: UUID v1, Asciidoctor-рендеринг, `zt-check` и `git diff --check`.

#### Scenario: CHECK-010 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: CHECK-011 — UUID v1 нового постоянного документа проверяется отдельно, поскольку текущий zt-check не пров...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: UUID v1 нового постоянного документа проверяется отдельно, поскольку текущий `zt-check` не проверяет версию UUID.

#### Scenario: CHECK-011 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-012 — каждый созданный или изменённый агентом AsciiDoc-документ рендерится Asciidoctor с --failure-...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: каждый созданный или изменённый агентом AsciiDoc-документ рендерится Asciidoctor с `--failure-level WARN`; выход сохраняется во временный каталог и не добавляется в репозиторий.

#### Scenario: CHECK-012 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-013 — после создания или изменения документов агент запускает .scripts/zt-check.zsh

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: после создания или изменения документов агент запускает `.scripts/zt-check.zsh`.

#### Scenario: CHECK-013 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-014 — после создания или изменения документов агент запускает git diff --check -- <changed-files>

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: после создания или изменения документов агент запускает `git diff --check -- <changed-files>`; полный `git diff --check` может использоваться дополнительно для обнаружения несвязанных проблем.

#### Scenario: CHECK-014 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-015 — минимальный набор проверок не заменяет проверку обязательных метаданных, all-todays, требуемы...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: минимальный набор проверок не заменяет проверку обязательных метаданных, `all-todays`, требуемых перекрёстных ссылок, Diary-цепочки, deprecated-семантики и специальных workflow.

#### Scenario: CHECK-015 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-016 — zt-check проверяет, что :deprecated

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: `zt-check` проверяет, что `:deprecated:` находится в заголовке и является его последним атрибутом.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-016 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-017 — zt-check выявляет активные Topic с пустым :key-topic

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: `zt-check` выявляет активные Topic с пустым `:key-topic:` и несогласованными каноническими заголовком, `:description:` и `:doclink:`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-017 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-018 — zt-check выявляет новые или активные связи, ошибочно направленные на deprecated Topic

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: `zt-check` выявляет новые или активные связи, ошибочно направленные на deprecated Topic.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-018 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-019 — интеграционные тесты покрывают следующую редакцию Topic через Reduce, выделение новой тематич...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: интеграционные тесты покрывают следующую редакцию Topic через Reduce, выделение новой тематической линии, повторный запуск и создание Memo после каждой операции.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-019 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-020 — интеграционный тест подтверждает, что Memo получает тематический ключ из :key-topic

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: интеграционный тест подтверждает, что Memo получает тематический ключ из `:key-topic:` выбранной Topic, а не из её заголовка или `:description:`.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-020 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-021 — интеграционный тест подтверждает, что ошибка разбора заголовка не приводит к добавлению :depr...

**Legacy status:** `ROADMAP`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Целевая архитектура или поведение MUST сохранять следующий target contract: интеграционный тест подтверждает, что ошибка разбора заголовка не приводит к добавлению `:deprecated:` в тело или конец документа.

До подтверждённой реализации проект MUST NOT описывать этот contract как `IMPLEMENTED`.

#### Scenario: CHECK-021 contract is verified

- **GIVEN** соответствующая roadmap capability планируется, проектируется или реализуется
- **WHEN** оценивается целевое поведение и его implementation status
- **THEN** target contract SHALL быть сохранён
- **AND** capability SHALL NOT считаться `IMPLEMENTED` без подтверждения кодом, проверками и traceability

### Requirement: CHECK-022 — metadata scanner прекращает разбор header на первой пустой строке после title и не принимает...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: metadata scanner прекращает разбор header на первой пустой строке после title и не принимает атрибутоподобные строки body за обязательные metadata или `:deprecated:`.

#### Scenario: CHECK-022 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

### Requirement: CHECK-023 — runtime core проверяется на временном Zettelkasten

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

Repository regression suite MUST на временном `ZK_HOME` проверять canonical constructors Note, Memo, Todo, Diary и Topic, обязательные metadata, UUID filename, успешную проверку валидного Vault и обнаружение broken link через `zt-check`.

#### Scenario: Runtime constructors and checker are exercised without user data

- **GIVEN** создан новый временный Zettelkasten
- **WHEN** runtime core integration test создаёт все canonical persistent object types и запускает `zt-check`
- **THEN** корректный fixture SHALL пройти validation
- **AND** broken link SHALL привести к validation failure
- **AND** пользовательский Vault SHALL оставаться неизменным
