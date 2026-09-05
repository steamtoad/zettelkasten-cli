## ADDED Requirements

### Requirement: ZT-GIT-001 — Локальный preflight сообщает состояние

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-git status MUST показывать branch/upstream, dirty/staged/untracked, незавершённые Git операции и divergence по доступным локальным refs без сети или mutation. Вне Git SHALL быть понятный NOT_GIT error.

#### Scenario: Dirty repository

- **GIVEN** есть staged, unstaged и untracked changes
- **WHEN** выполнен status
- **THEN** все категории показаны; хеши файлов/index/refs не изменены

### Requirement: ZT-GIT-002 — Sync допускает только безопасный fast-forward

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

По явному вызову sync инструмент MUST выполнить preflight, fetch configured upstream, повторную проверку state и только fast-forward текущей branch. Dirty/conflict/diverged/detached/missing upstream SHALL блокировать рабочую запись; локальные изменения никогда автоматически не прячутся и не удаляются.

#### Scenario: Локальная правка

- **GIVEN** tracked файл изменён
- **WHEN** вызван sync
- **THEN** dirty error; никаких reset/stash/merge рабочих файлов

#### Scenario: Чистое отставание

- **GIVEN** branch чиста и строго позади upstream
- **WHEN** явно выполнен sync
- **THEN** branch обновлена fast-forward; push не выполнялся

### Requirement: ZT-GIT-003 — Конфликты AsciiDoc разрешает пользователь

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-git conflicts MUST перечислять unmerged .adoc и доступные base/ours/theirs для просмотра. Он SHALL NOT выбирать сторону, удалять conflict markers, stage или commit без отдельного явного действия.

#### Scenario: Конфликт Note

- **GIVEN** Git содержит unmerged UUID.adoc
- **WHEN** выполнен conflicts
- **THEN** показаны версии/пути; working bytes и stages Git сохранены
