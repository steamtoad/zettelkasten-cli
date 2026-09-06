# diary-plugin-architecture

## Purpose

Определяет отдельную plugin boundary для Diary, её допустимые зависимости, совместимый CLI entrypoint и сохранение Diary chain, state и пользовательских данных при развитии в `zettelkasten-cli`.

Реализованные изменения: [refactor-diary-as-plugin](../../changes/archive/2026-09-06-refactor-diary-as-plugin/proposal.md).

## Requirements

### Requirement: DP-ARCH-001 — Diary является отдельным plugin layer

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/diary/docs/requirements.adoc` → section `Архитектура и совместимость`.
Zettelkasten-CLI SHALL размещать канонический Diary workflow, Diary chain/state policy и plugin-specific документацию в sibling plugin `.scripts/diary/` внутри репозитория `zettelkasten-cli`; Diary workflow MUST оставаться вне ownership `.scripts/zettelkasten/`.

#### Scenario: Каноническое владение Diary workflow
- **WHEN** определяется каноническая реализация создания Diary и обновления Diary chain/state
- **THEN** она находится под `.scripts/diary/`, а не в `.scripts/zettelkasten/` или в теле top-level compatibility entrypoint

#### Scenario: Разработка остаётся в текущем репозитории
- **WHEN** изменяется поведение или документация Diary plugin
- **THEN** изменение разрабатывается и проверяется в `zettelkasten-cli` без отдельного Git repository или package

### Requirement: DP-ARCH-002 — Diary plugin не создаёт обратных зависимостей

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/diary/docs/requirements.adoc` → section `Архитектура и совместимость`.
Diary plugin MUST depend only on its own plugin-specific code, `.scripts/objects/` и domain-neutral primitives under `.scripts/lib/`. Diary plugin MUST NOT depend on `.scripts/zettelkasten/`; `.scripts/lib/`, `.scripts/objects/`, `.scripts/zettelkasten/` и другие sibling plugins MUST NOT depend on `.scripts/diary/`.

#### Scenario: Проверка направления зависимостей
- **WHEN** repository boundary check анализирует executable source references между слоями
- **THEN** зависимости Diary plugin ограничены разрешёнными слоями, а ссылки `.scripts/diary/` → `.scripts/zettelkasten/` и обратные ссылки существующих слоёв → `.scripts/diary/` отсутствуют

### Requirement: DP-COMPAT-001 — Top-level Diary entrypoint сохраняет совместимость

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/diary/docs/requirements.adoc` → section `Архитектура и совместимость`.
`.scripts/zt-diary.zsh` SHALL оставаться публичным compatibility entrypoint, делегировать каноническому workflow Diary plugin и сохранять существующие CLI arguments, stdout/stderr, exit status, editor invocation и managed skill mapping.

#### Scenario: Diary создаётся через compatibility entrypoint
- **WHEN** пользователь запускает `.scripts/zt-diary.zsh`
- **THEN** entrypoint делегирует Diary plugin, а наблюдаемое поведение соответствует `ZP-DIARY-001`–`ZP-DIARY-005` и `ZP-TODAY-001`–`ZP-TODAY-003`

#### Scenario: Managed skill mapping остаётся стабильным
- **WHEN** проверяется mapping top-level commands на managed operational skills
- **THEN** `zt-diary.zsh` по-прежнему соответствует `zettelkasten-diary`

### Requirement: DP-DATA-001 — Выделение plugin сохраняет Diary model, chain и state

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/diary/docs/requirements.adoc` → section `Архитектура и совместимость`.
Выделение Diary plugin MUST preserve создание Diary через neutral constructor, размещение в `notes/`, UUID/AsciiDoc metadata, canonical links, bidirectional Diary chain, basename state в `ZK_HOME/.last-diary` и регистрацию в `all-todays`. Оно MUST NOT перемещать, переписывать или переиндексировать существующие пользовательские Diary и state.

#### Scenario: Новый Diary сохраняет существующий contract
- **WHEN** Diary успешно создаётся после выделения plugin
- **THEN** документ, chain links, `.last-diary`, `all-todays`, Vim invocation и выводимая ссылка совпадают с прежним observable contract

#### Scenario: Ошибка не продвигает state
- **WHEN** создание документа, регистрация в `all-todays` или связывание Diary завершается ошибкой
- **THEN** `.last-diary` не обновляется на новый basename и существующая цепочка не считается успешно продвинутой

#### Scenario: Существующие пользовательские данные не мигрируются
- **WHEN** устанавливается или обновляется версия с отдельным Diary plugin
- **THEN** существующие файлы в `notes/`, `all-todays/` и `.last-diary` не перемещаются и не преобразуются самим архитектурным переходом

### Requirement: DP-DEV-001 — Diary plugin проверяется на временном Vault

**Legacy status:** `PROCESS`.
**Traceability:** `.scripts/diary/docs/requirements.adoc` → section `Архитектура и совместимость`.
Изменения Diary plugin MUST сопровождаться regression verification через `.scripts/zt-diary.zsh` с временным `ZK_HOME`; ordinary development и validation MUST NOT mutate пользовательские `notes/`, `all-todays/` или `.last-diary`.

#### Scenario: Regression test изолирует Diary workflow
- **WHEN** выполняется `tests/zt-diary-as-plugin.zsh`
- **THEN** creation, metadata, previous/next links, invalid state, failure ordering, `all-todays`, editor и output behavior проверяются внутри временного `ZK_HOME`

#### Scenario: Реальный Vault не затрагивается
- **WHEN** выполняются repository validation commands для Diary plugin
- **THEN** фактические пользовательские Diary, `all-todays` и `.last-diary` не создаются и не изменяются
