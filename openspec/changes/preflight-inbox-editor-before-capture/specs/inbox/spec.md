## MODIFIED Requirements

### Requirement: INBOX-008 — zt-inbox.zsh открывает созданный элемент через непустой существующий $EDITOR, включая editor...

**Legacy status:** `IMPLEMENTED` до применения этой дельты; обновлённый contract получает этот статус только после regression verification.
**Traceability:** `scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Capture MUST до создания Inbox directories, raw-файла или иного state разобрать editor command и проверить, что он непустой, а его executable существует. Если `EDITOR` не задан, SHALL сохраняться совместимый default `vim`; явно пустой `EDITOR` MUST считаться ошибкой. Разбор MUST сохранять lexical quoting пути и аргументов, включая пустой quoted argument, и MUST NOT выполнять `eval`, command substitution или shell operators из значения `EDITOR`. После успешного preflight Capture SHALL создать raw и запустить проверенный editor с точными разобранными аргументами и путём raw-файла.

#### Scenario: INBOX-008 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Quoted editor path

- **WHEN** `EDITOR` содержит путь с пробелами в кавычках и quoted arguments
- **THEN** вызывается указанный executable с точными аргументами без выполнения содержащегося в них shell code

#### Scenario: EDITOR не задан

- **WHEN** `EDITOR` отсутствует в environment и доступен совместимый default `vim`
- **THEN** preflight SHALL выбрать `vim`, после чего capture создаёт raw и запускает editor по обычному success path

#### Scenario: EDITOR явно пуст

- **WHEN** `EDITOR` присутствует в environment с пустым значением
- **THEN** capture SHALL завершиться ненулевым exit с диагностикой `EDITOR must not be empty`
- **AND** Inbox directories и raw-файлы MUST NOT создаваться

#### Scenario: Editor executable отсутствует

- **WHEN** разобранный `EDITOR` указывает на отсутствующий executable
- **THEN** capture SHALL завершиться ненулевым exit с именем отсутствующего executable
- **AND** Inbox directories и raw-файлы MUST NOT создаваться
