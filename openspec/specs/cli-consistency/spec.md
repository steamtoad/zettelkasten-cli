# cli-consistency Specification

## Purpose

Определить единый preflight, selector revalidation, path precedence и безопасный повтор Inbox processed для host CLI.

## Requirements

### Requirement: CLI-PREFLIGHT-001 — Зависимости проверяются до записи

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `CLI preflight и выбор`.

Workflow MUST проверить необходимые executable dependencies и разобранный editor command до создания объекта или state. Отсутствующий `fzf`, provider или editor SHALL давать ненулевой exit с именем зависимости, а не cancel или успех.

#### Scenario: Отсутствует fzf

- **GIVEN** `fzf` удалён из тестового `PATH`
- **WHEN** запущен edit/getlink либо обязательный selector workflow
- **THEN** команда SHALL завершиться понятной ошибкой
- **AND** документ или journal entry SHALL NOT быть создан

#### Scenario: Невалидный EDITOR Inbox

- **GIVEN** `EDITOR` пуст или указывает на отсутствующий executable
- **WHEN** запущен capture
- **THEN** raw-файл SHALL NOT быть создан
- **AND** ложный success path SHALL NOT выводиться

### Requirement: CLI-PREFLIGHT-002 — Отмена и повторная проверка выбора

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `CLI preflight и выбор`.

Все selectors MUST различать cancel, отсутствие результата и operational error. До mutation выбранный файл SHALL повторно проверяться по существованию, type, active status и ожидаемому fingerprint; несоответствие SHALL давать `STATE_CONFLICT` без нового binding.

#### Scenario: Пользователь отменяет

- **GIVEN** `fzf` возвращает cancel
- **WHEN** выполняется workflow
- **THEN** команда SHALL завершиться с exit `0`
- **AND** хеши Vault и список файлов SHALL остаться неизменными

#### Scenario: Цель удалена после выбора

- **GIVEN** `fzf` выдал basename существовавшей Note
- **WHEN** до getlink/add файл исчез
- **THEN** команда SHALL сообщить `TARGET_NOT_FOUND`
- **AND** успешная новая ссылка SHALL NOT быть напечатана

### Requirement: CLI-PREFLIGHT-003 — Пути и формат выбора совместимы

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `CLI preflight и выбор`.

Resolver MUST сохранять документированный порядок `ZK_HOME` и Inbox fallback `INBOX-011`; plugin relocation SHALL NOT менять выбранный Vault. Selectors MUST разделять display и identity, поддерживать пробелы/Unicode и SHALL NOT использовать `cut -b`.

#### Scenario: Root с пробелами

- **GIVEN** `ZK_HOME` содержит пробелы и кириллицу, а `ZETTELKASTEN_ROOT` указывает в другое место
- **WHEN** выполнены core и Inbox workflows
- **THEN** оба SHALL использовать `ZK_HOME`
- **AND** второй каталог SHALL остаться неизменным

#### Scenario: Title содержит разделительный текст

- **GIVEN** description включает строку ` - ` и Unicode
- **WHEN** выбран документ
- **THEN** workflow SHALL использовать точный basename из machine field

### Requirement: CLI-PREFLIGHT-004 — Повтор processed восстанавливает только доказанный перенос

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `CLI preflight и выбор`.

`zt-processed` MUST сохранять исходный basename/content и no-clobber. При наличии raw и processed одним inode повтор SHALL завершать предусмотренный перенос; разные inode или filesystem boundary SHALL диагностироваться без удаления любого файла.

#### Scenario: Прерывание после ln

- **GIVEN** raw и processed являются hard links одного inode
- **WHEN** повторён processed
- **THEN** SHALL остаться processed с прежним содержимым
- **AND** raw SHALL быть удалён с exit `0`

#### Scenario: Разные файлы с одним именем

- **GIVEN** processed уже содержит другой inode
- **WHEN** запущен processed
- **THEN** команда SHALL сообщить ошибку коллизии
- **AND** обе версии SHALL быть сохранены
