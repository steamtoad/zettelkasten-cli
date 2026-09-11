## Why

Текущий `INBOX-008` проверяет разобранный `$EDITOR` только после создания raw-файла. Если editor пуст или executable отсутствует, capture завершается ошибкой, но оставляет новый staging-файл; это противоречит целевому preflight-контракту `standardize-cli-preflight-and-selection`.

Требуемое поведение: editor command проверяется до любых изменений Inbox, поэтому ошибка конфигурации не создаёт каталогов, raw-файлов или ложного success path. Вне scope остаются общий selector contract, processed recovery, изменение формата raw и импорт в постоянные документы.

## What Changes

- **BREAKING** `INBOX-008` переносит проверку непустого разобранного `$EDITOR` и наличия его executable до создания `inbox/raw` и raw-файла.
- Сохраняются lexical parsing без `eval`, точная передача quoted arguments и запрет выполнения shell operators/command substitution из `$EDITOR`.
- Добавляется regression verification через `scripts/zt-inbox.zsh` на временном `ZK_HOME`: пустой и отсутствующий editor дают ненулевой exit, называют причину и не изменяют Inbox.
- После проверенной реализации baseline и legacy traceability синхронизируются без изменения stable ID `INBOX-008`.

## Capabilities

### New Capabilities

Нет.

### Modified Capabilities

- `inbox`: `INBOX-008` требует editor preflight до создания raw при сохранении существующего безопасного разбора и запуска editor.

## Impact

- Implementation scope: `scripts/inbox/capture.zsh`, top-level compatibility entrypoint tests и Inbox regression fixtures.
- Specification scope: `openspec/specs/inbox/spec.md`, `scripts/inbox/docs/requirements.adoc` и подтверждённое описание возможностей после реализации.
- Compatibility: успешный capture, формат raw, `ZK_HOME`/`ZETTELKASTEN_ROOT`, arguments, stdout и editor invocation сохраняются; меняется только side effect ошибочного запуска с невалидным `$EDITOR`.
- Architecture: изменение остаётся внутри Inbox plugin и не добавляет межплагинных зависимостей.
- User-data/destructive impact: proposal не изменяет Vault; implementation и tests используют временный `ZK_HOME`. Миграция существующих raw-файлов, commit/tag/push и публикация не входят в scope.
- Composition: `standardize-cli-preflight-and-selection` может применять `CLI-PREFLIGHT-001` только после согласования с этим изменённым `INBOX-008`.
