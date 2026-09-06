## Why

Inbox сейчас реализован как пара самостоятельных host workflow в top-level `.scripts/zt-*.zsh`, хотя архитектура репозитория уже предусматривает отдельные plugin layers. Выделение Inbox в sibling plugin создаёт явную границу владения и позволяет продолжать его разработку в этом же репозитории, не связывая Inbox с Zettelkasten plugin и не меняя пользовательские данные.

## What Changes

- Вводится отдельный Inbox plugin под `.scripts/inbox/` как каноническое место реализации и документации Inbox workflow.
- `.scripts/zt-inbox.zsh` и `.scripts/zt-processed.zsh` сохраняются как публичные compatibility entrypoints и делегируют соответствующие workflow Inbox plugin без изменения CLI-контракта, stdout/stderr и exit status.
- Фиксируется направление зависимостей: Inbox plugin может использовать domain-neutral primitives, но neutral engine и Zettelkasten plugin не зависят от Inbox plugin; Inbox plugin не зависит от `.scripts/zettelkasten/`.
- Сохраняются существующие `ZK_HOME/inbox/raw` и `ZK_HOME/inbox/processed`, форматы файлов, семантика capture/processed и mapping managed skills.
- Дальнейшая разработка Inbox ведётся внутри plugin boundary в текущем репозитории `zettelkasten-cli`.
- Не реализуется импорт Inbox в Note, Memo или `all-todays`, не создаётся отдельный Git repository/package и не выполняется миграция существующих данных.

## Capabilities

### New Capabilities

- `inbox-plugin-architecture`: граница отдельного Inbox plugin, направления зависимостей, совместимость top-level entrypoints и сохранение data layout при выделении plugin.

### Modified Capabilities

Нет. Наблюдаемое поведение существующей capability `inbox` и её требования `INBOX-001`–`INBOX-012` сохраняются.

## Impact

- Затрагиваемые области: `.scripts/inbox/`, `.scripts/zt-inbox.zsh`, `.scripts/zt-processed.zsh`, документация требований/Feature List и Inbox regression tests.
- Архитектурный эффект: новый sibling plugin рядом с `.scripts/zettelkasten/`; изменение совместимо с `ARCH-015` и не расширяет ownership Zettelkasten plugin, заданный `ZP-ARCH-004`.
- Совместимость: сохраняются `INBOX-001`–`INBOX-012`, `PATH-008`, `ROADMAP-004`, имена команд и mapping `zettelkasten-inbox-capture`/`zettelkasten-inbox-processed`.
- Миграция: не требуется; существующие файлы остаются в `ZK_HOME/inbox/{raw,processed}`.
- Destructive operations: отсутствуют. Изменение не должно читать, перемещать или изменять пользовательские Inbox/Vault данные; интеграционные проверки используют временный `ZK_HOME`.
- Зависимости и persistent document model не меняются.
