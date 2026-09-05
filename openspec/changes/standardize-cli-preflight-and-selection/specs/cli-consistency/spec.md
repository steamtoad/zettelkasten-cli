## ADDED Requirements

### Requirement: CLI-PREFLIGHT-001 — Зависимости проверяются до записи

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Workflow MUST проверить необходимые executable dependencies и разобранный editor command до создания объекта или state. Отсутствующий fzf/provider/editor SHALL давать ненулевой exit с именем зависимости, а не cancel или успех.

#### Scenario: Отсутствует fzf

- **GIVEN** fzf удалён из тестового PATH
- **WHEN** запущен edit/getlink либо обязательный selector workflow
- **THEN** понятная ошибка; не создано ни документа, ни journal entry

#### Scenario: Невалидный EDITOR Inbox

- **GIVEN** EDITOR пуст или указывает на отсутствующий executable
- **WHEN** запущен capture
- **THEN** raw файл не создан; нет ложного success path

### Requirement: CLI-PREFLIGHT-002 — Отмена и повторная проверка выбора

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Все selectors MUST различать cancel, отсутствие результата и operational error. До mutation выбранный файл SHALL повторно проверяться по существованию, type, active status и ожидаемому fingerprint; несоответствие SHALL давать STATE_CONFLICT без нового binding.

#### Scenario: Пользователь отменяет

- **GIVEN** fzf возвращает cancel
- **WHEN** выполняется workflow
- **THEN** exit 0; хеши Vault и список файлов неизменны

#### Scenario: Цель удалена после выбора

- **GIVEN** fzf выдал basename существовавшей Note
- **WHEN** до getlink/add файл исчез
- **THEN** команда сообщает TARGET_NOT_FOUND и не печатает успешную новую ссылку

### Requirement: CLI-PREFLIGHT-003 — Пути и формат выбора совместимы

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Resolver MUST сохранять документированный порядок ZK_HOME и Inbox fallback INBOX-011; plugin relocation SHALL NOT менять выбранный Vault. Selectors MUST разделять display и identity, поддерживать пробелы/Unicode и не использовать cut -b.

#### Scenario: Root с пробелами

- **GIVEN** ZK_HOME содержит пробелы и кириллицу, ZETTELKASTEN_ROOT указывает в другое место
- **WHEN** выполнены core и Inbox workflows
- **THEN** оба используют ZK_HOME, второй каталог не изменён

#### Scenario: Title содержит разделительный текст

- **GIVEN** description включает строку - и Unicode
- **WHEN** выбран документ
- **THEN** использован правильный basename из machine field

### Requirement: CLI-PREFLIGHT-004 — Повтор processed восстанавливает только доказанный перенос

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-processed MUST сохранять исходный basename/content и no-clobber. При наличии raw и processed одним inode повтор SHALL завершать предусмотренный перенос; разные inode или filesystem boundary SHALL диагностироваться без удаления любого файла.

#### Scenario: Прерывание после ln

- **GIVEN** raw и processed — hard links одного inode
- **WHEN** повторён processed
- **THEN** остаётся processed с прежним содержимым, raw удалён, код 0

#### Scenario: Разные файлы с одним именем

- **GIVEN** processed уже содержит другой inode
- **WHEN** запущен processed
- **THEN** ошибка коллизии; обе версии сохранены
