## MODIFIED Requirements

### Requirement: INBOX-007 — zt-inbox.zsh создаёт raw-элемент с однострочным непустым заголовком и защищает существующие ф...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Capture SHALL создавать raw-элемент с однострочным непустым заголовком в пути с пробелами и Unicode; timestamp collisions, включая dangling symlink, MUST выбирать новый suffix без перезаписи существующего entry. Ошибка любой записи metadata MUST завершать capture ошибкой, удалять созданный неполный raw и не запускать editor.

#### Scenario: INBOX-007 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Unicode raw path

- **WHEN** ZK_HOME содержит пробелы и кириллицу
- **THEN** capture создаёт и печатает путь корректного raw AsciiDoc без изменения cwd редактора


#### Scenario: Concurrent capture collision

- **WHEN** одновременные capture имеют одинаковый timestamp либо занятый symlink basename
- **THEN** каждый успешный capture имеет уникальное имя, существующие entries не изменены


#### Scenario: Partial metadata write

- **WHEN** запись любого атрибута capture завершается ошибкой
- **THEN** неполный raw удалён, exit ненулевой, editor не вызван

### Requirement: INBOX-008 — zt-inbox.zsh открывает созданный элемент через непустой существующий $EDITOR, включая editor...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Capture SHALL запускать существующий непустой EDITOR, сохраняя lexical quoting пути и аргументов, включая пустой quoted argument; разбор MUST NOT выполнять eval, command substitution или shell operators из значения EDITOR. Проверка editor остаётся после создания raw.

#### Scenario: INBOX-008 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Quoted editor path

- **WHEN** EDITOR содержит путь с пробелами в кавычках и quoted arguments
- **THEN** вызывается указанный executable с точными аргументами без выполнения содержащегося в них shell code


### Requirement: INBOX-009 — zt-processed.zsh обрабатывает только непосредственный обычный файл inbox/raw и отклоняет внеш...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Processed MUST принимать только непосредственный обычный файл inbox/raw; symlink leaf MUST отклоняться до разрешения target, в том числе если он указывает на соседний raw. Внешние и вложенные physical paths MUST отклоняться.

#### Scenario: INBOX-009 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Internal raw symlink

- **WHEN** processed получает symlink на другой файл внутри raw
- **THEN** операция отклонена, symlink и target остаются без изменений


### Requirement: INBOX-010 — перевод в processed не перезаписывает существующее назначение и атомарно резервирует destinat...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/inbox/docs/requirements.adoc` → section `Inbox Layer`.

Processed MUST атомарно резервировать точное имя назначения hard link операцией без перезаписи и без directory-operand semantics. Любой существующий entry назначения, включая каталог, symlink и dangling symlink, MUST сохраняться, а raw MUST оставаться на месте при отказе. Создание directory destination между preflight и резервированием MUST NOT приводить к записи внутрь него.

#### Scenario: INBOX-010 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Directory destination collision

- **WHEN** processed destination является каталогом или symlink на каталог
- **THEN** операция завершается ошибкой без вложенного файла и без удаления raw


#### Scenario: Racing destination collision

- **WHEN** destination создаётся конкурентно перед hard link
- **THEN** точная atomic reservation отклонена и source не удаляется

