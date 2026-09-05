## Why

Diary сейчас является каноническим workflow Zettelkasten plugin, хотя его собственные state и chain contracts образуют самостоятельную функциональную границу. Выделение Diary в sibling plugin позволит развивать его независимо в том же репозитории, сохранив единый document model и существующий пользовательский workflow.

## What Changes

- Вводится отдельный Diary plugin под `.scripts/diary/` как каноническое место Diary workflow, chain/state policy и plugin-specific документации.
- `.scripts/zt-diary.zsh` сохраняется как публичный compatibility entrypoint и делегирует Diary plugin без изменения CLI, stdout/stderr и exit status.
- Zettelkasten plugin перестаёт владеть Diary workflow и Diary state; его остальные Note, Memo, Topic и Todo workflow не меняются.
- Diary plugin использует neutral Diary constructor и domain-neutral primitives, но не зависит от `.scripts/zettelkasten/`; neutral engine и другие plugins не зависят от Diary plugin.
- Сохраняются `notes/`, `.last-diary`, UUID/AsciiDoc metadata, bidirectional Diary chain, регистрация в `all-todays`, Vim и формат выводимой ссылки.
- Дальнейшая разработка Diary ведётся внутри plugin boundary в текущем репозитории `zettelkasten-cli`.
- Не вводятся отдельный Git repository/package, runtime plugin discovery, новая document type/schema или миграция пользовательских Diary.

## Capabilities

### New Capabilities

- `diary-plugin-architecture`: ownership отдельного Diary plugin, направления зависимостей, совместимость top-level entrypoint и инварианты state/data при выделении plugin.

### Modified Capabilities

- `architecture`: `ARCH-014`, `ARCH-016` и `ARCH-017` уточняют место Diary policy, допустимые зависимости Diary plugin и новое направление delegation `zt-diary.zsh`.
- `plugin-architecture`: `ZP-ARCH-003` исключает Diary из канонических workflow Zettelkasten plugin, поскольку Diary получает собственную plugin boundary.

## Impact

- Затрагиваемые области: `.scripts/diary/`, `.scripts/zettelkasten/zt-diary.zsh`, `.scripts/zt-diary.zsh`, Diary/Zettelkasten documentation, Feature List, legacy traceability и `tests/zt-diary-as-plugin.zsh`.
- Стабильные Diary contracts `ZP-DIARY-001`–`ZP-DIARY-005`, `DATA-003`, `PATH-001`, `PATH-002`, `PATH-007`, `ZP-TODAY-001`–`ZP-TODAY-003`, `ZP-COMPAT-001`–`ZP-COMPAT-003` и managed skill mapping `zt-diary.zsh` → `zettelkasten-diary` сохраняются.
- Архитектурный эффект: L4-изменение ownership и dependency graph; `ARCH-014`, `ARCH-016`, `ARCH-017` и `ZP-ARCH-003` изменяются явно.
- Совместимость: breaking changes отсутствуют; aliases и top-level command path сохраняются.
- Миграция: не требуется; существующие Diary остаются в `notes/`, а `.last-diary` остаётся в корне `ZK_HOME`.
- Destructive operations: отсутствуют. Planning и implementation verification не должны изменять реальный Vault; интеграционные проверки используют временный `ZK_HOME`.
- Persistent document model, UUID/link semantics и Git history пользователя не меняются.
