# agent-governance Specification

## Purpose

Определить существующий operational agent/managed-skill governance, authority layers и traceability rules.

## Requirements

### Requirement: AGENT-001 — operational инструкции агентов организованы вокруг обязательной точки входа AGENTS.MD, управл...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: operational инструкции агентов организованы вокруг обязательной точки входа `AGENTS.MD`, управляемых OpenClaw-навыков `zettelkasten-*`, OpenSpec normative baseline, фактического поведения в `.scripts/` и legacy traceability в `.scripts/docs/requirements.adoc`.

#### Scenario: AGENT-001 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGENT-002 — AGENTS.MD содержит общие инварианты, правила безопасности и маршрутизацию, но не дублирует по...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `AGENTS.MD` содержит общие инварианты, правила безопасности и маршрутизацию, но не дублирует полные процедуры всех операций.

#### Scenario: AGENT-002 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGENT-003 — каждый top-level скрипт .scripts/zt-*.zsh имеет ровно один соответствующий управляемый навык...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: каждый top-level скрипт `.scripts/zt-*.zsh` имеет ровно один соответствующий управляемый навык `zettelkasten-*`.

#### Scenario: AGENT-003 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-004 — OpenSpec является normative truth, scripts/libs — executable truth, managed operational skill...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: OpenSpec является normative truth, scripts/libs — executable truth, managed operational skills — procedural truth, legacy requirements — stable-ID/status traceability truth, Feature List — descriptive truth; расхождение между слоями считается конфликтом specification, implementation, procedure, traceability или documentation и должно быть явно сообщено.

#### Scenario: AGENT-004 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-005 — при изменении zt-*.zsh или связанного требования соответствующий managed SKILL.md обновляется...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: при изменении `zt-*.zsh` или связанного требования соответствующий managed `SKILL.md` обновляется и проверяется через Skill Workshop в рамках того же изменения.

#### Scenario: AGENT-005 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-006 — агент читает только навыки, относящиеся к текущей задаче

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: агент читает только навыки, относящиеся к текущей задаче; маршрутизация `zt-*` → `zettelkasten-*` задаётся в `AGENTS.MD` и runtime-каталоге skills.

#### Scenario: AGENT-006 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-007 — каждый managed skill фиксирует область применения, источники истины, предварительные проверки...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: каждый managed skill фиксирует область применения, источники истины, предварительные проверки, шаги, побочные эффекты, проверки результата, ограничения и обработку ошибок.

#### Scenario: AGENT-007 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-008 — каждый operational skill, привязанный к top-level zt-*.zsh, имеет одну активную подробную Not...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: каждый operational skill, привязанный к top-level `zt-*.zsh`, имеет одну активную подробную Note-редакцию в `notes/`, указанную как `Detailed reference` в его `SKILL.md`; thin routing, inspection и domain/meta skills без one-to-one CLI operation могут не иметь Detailed Note, если manifest классифицирует их как `meta`.

#### Scenario: AGENT-008 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-009 — при смысловом изменении навыка создаётся новая UUID v1 Note-редакция

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: при смысловом изменении навыка создаётся новая UUID v1 Note-редакция; предыдущая помечается `:deprecated:`, а обе редакции связываются ссылками `Предыдущая редакция` и `Следующая редакция`.

#### Scenario: AGENT-009 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-010 — managed SKILL.md является актуальной операционной процедурой, а Note-редакции сохраняют подро...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: managed `SKILL.md` является актуальной операционной процедурой, а Note-редакции сохраняют подробное объяснение, обоснование, ограничения и историю развития навыка.

#### Scenario: AGENT-010 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-011 — .agent-skills/ является read-only историческим архивом прежнего AsciiDoc-слоя и не участвует...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: `.agent-skills/` является read-only историческим архивом прежнего AsciiDoc-слоя и не участвует в runtime routing или синхронизации со скриптами.

#### Scenario: AGENT-011 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGENT-012 — Git-версионируемый .scripts/docs/managed-skills.adoc является integration contract между chec...

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: Git-версионируемый `.scripts/docs/managed-skills.adoc` является integration contract между checkout Zettelkasten и внешним OpenClaw state: он фиксирует имя skill, класс, mapping на script, Detailed Note и SHA-256 активного `SKILL.md`.

#### Scenario: AGENT-012 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных

### Requirement: AGENT-013 — zt-skills-review проверяет полноту manifest, отсутствие лишних runtime skills, SHA-256, scrip...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: `zt-skills-review` проверяет полноту manifest, отсутствие лишних runtime skills, SHA-256, script mapping, существование и активность обязательных Detailed Note; несовпадение завершает проверку ошибкой.

#### Scenario: AGENT-013 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-014 — изменение managed skill через Skill Workshop и обновление manifest являются одной логической...

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Development, migration или runtime process MUST соблюдать следующее правило: изменение managed skill через Skill Workshop и обновление manifest являются одной логической операцией, но не одним Git transaction; до совпадения manifest и runtime skill интеграция считается несогласованной.

#### Scenario: AGENT-014 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: AGENT-015 — специальные workflow в AGENTS.MD переопределяют ordinary binding defaults managed skills

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Инструкции и навыки агентов`.

Zettelkasten-CLI MUST сохранять следующий инвариант: специальные workflow в `AGENTS.MD` переопределяют ordinary binding defaults managed skills; OpenClaw Memo не получает Topic binding, а OpenClaw Note получает обязательную Topic binding независимо от ограничений интерактивного `zt-note.zsh`.

#### Scenario: AGENT-015 contract is verified

- **GIVEN** операция или изменение затрагивает соответствующую capability
- **WHEN** поведение выполняется или проверяется
- **THEN** указанный invariant SHALL сохраняться
- **AND** несовместимое поведение SHALL быть отклонено или диагностировано до повреждения данных
