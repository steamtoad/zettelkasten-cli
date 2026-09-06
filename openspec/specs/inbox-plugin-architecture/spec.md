# inbox-plugin-architecture

## Purpose

Определяет отдельную plugin boundary для Inbox, её допустимые зависимости, совместимые CLI entrypoints и инварианты пользовательских данных при развитии Inbox в репозитории `zettelkasten-cli`.

Реализованные изменения: [refactor-inbox-as-plugin](../../changes/archive/2026-09-06-refactor-inbox-as-plugin/proposal.md).

## Requirements

### Requirement: IP-ARCH-001 — Inbox является отдельным plugin layer

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Архитектура и совместимость`.
Система SHALL размещать канонические Inbox workflow и их plugin-specific документацию в отдельном sibling plugin `.scripts/inbox/` внутри репозитория `zettelkasten-cli`; Inbox SHALL оставаться вне ownership `.scripts/zettelkasten/`.

#### Scenario: Каноническое владение Inbox workflow
- **WHEN** определяется каноническая реализация capture или processed workflow
- **THEN** она находится под `.scripts/inbox/`, а не в `.scripts/zettelkasten/` или в теле top-level compatibility entrypoint

#### Scenario: Разработка остаётся в текущем репозитории
- **WHEN** изменяется поведение или документация Inbox plugin
- **THEN** изменение разрабатывается и проверяется в репозитории `zettelkasten-cli` без выделения отдельного Git repository или package

### Requirement: IP-ARCH-002 — Зависимости Inbox plugin направлены к neutral engine

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Архитектура и совместимость`.
Inbox plugin MAY depend on domain-neutral primitives under `.scripts/lib/`. Inbox plugin MUST NOT depend on `.scripts/zettelkasten/`; `.scripts/lib/`, `.scripts/objects/` и `.scripts/zettelkasten/` MUST NOT depend on `.scripts/inbox/`.

#### Scenario: Проверка направлений зависимостей
- **WHEN** repository boundary check анализирует source/import references Inbox plugin и существующих слоёв
- **THEN** разрешены зависимости Inbox plugin на `.scripts/lib/`, а ссылки `.scripts/inbox/` → `.scripts/zettelkasten/` и обратные ссылки существующих слоёв → `.scripts/inbox/` отсутствуют

### Requirement: IP-COMPAT-001 — Top-level Inbox entrypoints сохраняют совместимость

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Архитектура и совместимость`.
`.scripts/zt-inbox.zsh` и `.scripts/zt-processed.zsh` SHALL оставаться публичными compatibility entrypoints, делегировать каноническим workflow Inbox plugin и сохранять существующие CLI arguments, stdout/stderr и exit status, определённые `INBOX-001`–`INBOX-012`.

#### Scenario: Capture через compatibility entrypoint
- **WHEN** пользователь запускает `.scripts/zt-inbox.zsh` с поддерживаемыми аргументами
- **THEN** entrypoint делегирует capture workflow Inbox plugin и наблюдаемое поведение совпадает с требованиями `INBOX-001`–`INBOX-010`

#### Scenario: Processed через compatibility entrypoint
- **WHEN** пользователь запускает `.scripts/zt-processed.zsh` с поддерживаемым source path
- **THEN** entrypoint делегирует processed workflow Inbox plugin и наблюдаемое поведение совпадает с требованиями `INBOX-011`–`INBOX-012`

#### Scenario: Managed skill mapping остаётся стабильным
- **WHEN** проверяется mapping top-level commands на managed operational skills
- **THEN** `zt-inbox.zsh` по-прежнему соответствует `zettelkasten-inbox-capture`, а `zt-processed.zsh` — `zettelkasten-inbox-processed`

### Requirement: IP-DATA-001 — Выделение plugin не мигрирует Inbox data

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Архитектура и совместимость`.
Выделение Inbox plugin MUST preserve `ZK_HOME/inbox/raw` и `ZK_HOME/inbox/processed`, существующие имена и содержимое файлов, collision behavior и same-filesystem hard-link semantics. Оно MUST NOT перемещать или преобразовывать существующие пользовательские данные и MUST NOT считать ROADMAP import в Note, Memo или `all-todays` реализованным.

#### Scenario: Существующий data layout сохраняется
- **WHEN** Inbox workflow выполняется после выделения plugin
- **THEN** новые и обработанные элементы используют те же пути и форматы, что и до выделения plugin

#### Scenario: Пользовательские данные не мигрируются
- **WHEN** устанавливается или обновляется версия с отдельным Inbox plugin
- **THEN** существующие файлы под `ZK_HOME/inbox/` не читаются, не перемещаются и не изменяются самим архитектурным переходом

#### Scenario: ROADMAP import остаётся нереализованным
- **WHEN** проверяются Feature List и legacy requirement statuses после выделения plugin
- **THEN** импорт Inbox в persistent document types или `all-todays` не помечен как IMPLEMENTED без отдельной реализации и проверки

### Requirement: IP-DEV-001 — Inbox plugin проверяется изолированно от пользовательского Vault

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Архитектура и совместимость`.
Изменения Inbox plugin MUST сопровождаться regression verification через top-level compatibility entrypoints с временным `ZK_HOME`; ordinary development и validation MUST NOT mutate пользовательский Vault.

#### Scenario: Regression test использует временный Vault
- **WHEN** выполняется Inbox plugin regression test
- **THEN** capture, collision, editor arguments, path safety и atomic processed behavior проверяются внутри временного `ZK_HOME`

#### Scenario: Проверка не затрагивает пользовательские данные
- **WHEN** выполняются repository validation commands для Inbox plugin
- **THEN** ни один пользовательский файл под фактическим `ZK_HOME` не создаётся и не изменяется
